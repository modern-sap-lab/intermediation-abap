CLASS lhc_tariff DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS NormalizeExternalCode FOR DETERMINE ON MODIFY
       keys FOR Tariff~NormalizeExternalCode.
    METHODS ValidateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Tariff~ValidateDates.
    METHODS ValidateNoOverlap FOR VALIDATE ON SAVE
      IMPORTING keys FOR Tariff~ValidateNoOverlap.
    METHODS GetDefaultsForCreate FOR READ
       keys FOR FUNCTION Tariff~GetDefaultsForCreate RESULT result.
    METHODS ValidateCodeFormat FOR VALIDATE ON SAVE
       keys FOR Tariff~ValidateCodeFormat.
    METHODS ValidateUniqueCode FOR VALIDATE ON SAVE
       keys FOR Tariff~ValidateUniqueCode.

ENDCLASS.

CLASS lhc_tariff IMPLEMENTATION.

  METHOD NormalizeExternalCode.

    READ ENTITIES OF zi_msl_tariff IN LOCAL MODE
      ENTITY Tariff
        FIELDS ( ExternalCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(tariffs).

    DATA updates TYPE TABLE FOR UPDATE zi_msl_tariff.

    LOOP AT tariffs INTO DATA(tariff).

      DATA(normalized_code) = to_upper( tariff-ExternalCode ).

      IF normalized_code <> tariff-ExternalCode.

        APPEND VALUE #(
          %tky         = tariff-%tky
          ExternalCode = normalized_code
        ) TO updates.

      ENDIF.

    ENDLOOP.

    IF updates IS NOT INITIAL.

      MODIFY ENTITIES OF zi_msl_tariff IN LOCAL MODE
        ENTITY Tariff
          UPDATE FIELDS ( ExternalCode )
          WITH updates.

    ENDIF.

  ENDMETHOD.

  METHOD ValidateDates.

    READ ENTITIES OF zi_msl_tariff IN LOCAL MODE
      ENTITY Tariff
        FIELDS ( ValidFrom ValidTo )
        WITH CORRESPONDING #( keys )
      RESULT DATA(tariffs).

    LOOP AT tariffs INTO DATA(tariff).

      IF tariff-ValidFrom IS INITIAL
         OR tariff-ValidTo IS INITIAL.

        APPEND VALUE #(
          %tky = tariff-%tky
        ) TO failed-tariff.

        APPEND VALUE #(
          %tky = tariff-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Both validity dates are required'
          )
          %element-ValidFrom = if_abap_behv=>mk-on
          %element-ValidTo   = if_abap_behv=>mk-on
        ) TO reported-tariff.

      ELSEIF tariff-ValidTo < tariff-ValidFrom.

        APPEND VALUE #(
          %tky = tariff-%tky
        ) TO failed-tariff.

        APPEND VALUE #(
          %tky = tariff-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Valid To must not precede Valid From'
          )
          %element-ValidFrom = if_abap_behv=>mk-on
          %element-ValidTo   = if_abap_behv=>mk-on
        ) TO reported-tariff.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateNoOverlap.

    READ ENTITIES OF zi_msl_tariff IN LOCAL MODE
      ENTITY Tariff
        FIELDS ( TariffUUID PrincipalUUID ValidFrom ValidTo )
        WITH CORRESPONDING #( keys )
      RESULT DATA(tariffs).

    LOOP AT tariffs INTO DATA(tariff).

      IF tariff-ValidFrom IS INITIAL
         OR tariff-ValidTo IS INITIAL
         OR tariff-ValidTo < tariff-ValidFrom.
        CONTINUE.
      ENDIF.

      DATA(overlap_exists) = abap_false.

      " Check already persisted tariffs
      SELECT SINGLE @abap_true
        FROM zi_msl_tariff
        WITH PRIVILEGED ACCESS
        WHERE PrincipalUUID = @tariff-PrincipalUUID
          AND TariffUUID <> @tariff-TariffUUID
          AND ValidFrom <= @tariff-ValidTo
          AND ValidTo >= @tariff-ValidFrom
        INTO @overlap_exists.

      " Check other tariffs in the same validation batch
      IF overlap_exists = abap_false.

        LOOP AT tariffs INTO DATA(other_tariff)
          WHERE PrincipalUUID = tariff-PrincipalUUID
            AND TariffUUID <> tariff-TariffUUID
            AND ValidFrom <= tariff-ValidTo
            AND ValidTo >= tariff-ValidFrom.

          overlap_exists = abap_true.
          EXIT.

        ENDLOOP.

      ENDIF.

      IF overlap_exists = abap_true.

        APPEND VALUE #(
          %tky = tariff-%tky
        ) TO failed-tariff.

        APPEND VALUE #(
          %tky = tariff-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Tariff validity period overlaps another tariff'
          )
          %element-ValidFrom = if_abap_behv=>mk-on
          %element-ValidTo   = if_abap_behv=>mk-on
        ) TO reported-tariff.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD GetDefaultsForCreate.

    result = VALUE #(
      FOR key IN keys
      (
        %cid = key-%cid
        %param = VALUE #(
          CurrencyCode = 'EUR'
        )
      )
    ).

  ENDMETHOD.

  METHOD ValidateCodeFormat.

    READ ENTITIES OF zi_msl_tariff IN LOCAL MODE
      ENTITY Tariff
        FIELDS ( ExternalCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(tariffs).

    LOOP AT tariffs INTO DATA(tariff).

      IF tariff-ExternalCode IS INITIAL
         OR NOT matches(
           val   = tariff-ExternalCode
           regex = '^[A-Z0-9.-]+$'
         ).

        APPEND VALUE #(
          %tky = tariff-%tky
        ) TO failed-tariff.

        APPEND VALUE #(
          %tky = tariff-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Tariff code may contain only A-Z, 0-9, hyphen and dot'
          )
          %element-ExternalCode = if_abap_behv=>mk-on
        ) TO reported-tariff.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateUniqueCode.

    READ ENTITIES OF zi_msl_tariff IN LOCAL MODE
      ENTITY Tariff
        FIELDS ( TariffUUID PrincipalUUID ExternalCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(tariffs).

    LOOP AT tariffs INTO DATA(tariff).

      DATA(code_exists) = abap_false.

      " Comprobar tarifas ya persistidas
      SELECT SINGLE @abap_true
        FROM zi_msl_tariff
        WITH PRIVILEGED ACCESS
        WHERE PrincipalUUID = @tariff-PrincipalUUID
          AND ExternalCode  = @tariff-ExternalCode
          AND TariffUUID   <> @tariff-TariffUUID
        INTO @code_exists.

      IF code_exists = abap_false.

        " Comprobar otras tarifas del mismo lote
        LOOP AT tariffs INTO DATA(other_tariff)
          WHERE PrincipalUUID = tariff-PrincipalUUID
            AND ExternalCode  = tariff-ExternalCode
            AND TariffUUID   <> tariff-TariffUUID.

          code_exists = abap_true.
          EXIT.

        ENDLOOP.

      ENDIF.

      IF code_exists = abap_true.

        APPEND VALUE #(
          %tky = tariff-%tky
        ) TO failed-tariff.

        APPEND VALUE #(
          %tky = tariff-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Tariff code already exists for this principal'
          )
          %element-ExternalCode = if_abap_behv=>mk-on
        ) TO reported-tariff.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
