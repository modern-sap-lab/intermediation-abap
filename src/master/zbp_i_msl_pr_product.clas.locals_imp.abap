CLASS lhc_principalproduct DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ValidatePrincipal FOR VALIDATE ON SAVE
       keys FOR PrincipalProduct~ValidatePrincipal.
    METHODS ValidateUniqueCode FOR VALIDATE ON SAVE
       keys FOR PrincipalProduct~ValidateUniqueCode.
    METHODS ValidateCodeFormat FOR VALIDATE ON SAVE
       keys FOR PrincipalProduct~ValidateCodeFormat.
    METHODS NormalizeExternalCode FOR DETERMINE ON MODIFY
      keys FOR PrincipalProduct~NormalizeExternalCode.
  ENDCLASS.

CLASS lhc_principalproduct IMPLEMENTATION.

  METHOD ValidatePrincipal.

    READ ENTITIES OF zi_msl_pr_product IN LOCAL MODE
      ENTITY PrincipalProduct
        FIELDS ( PrincipalUUID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      SELECT SINGLE @abap_true
        FROM zi_msl_principal
        WITH PRIVILEGED ACCESS
        WHERE PrincipalUUID = @product-PrincipalUUID
        INTO @DATA(principal_exists).

      IF principal_exists <> abap_true.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-principalproduct.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Principal does not exist'
          )
          %element-PrincipalUUID = if_abap_behv=>mk-on
        ) TO reported-principalproduct.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateUniqueCode.

    DATA code_exists TYPE abap_bool.

    READ ENTITIES OF zi_msl_pr_product IN LOCAL MODE
      ENTITY PrincipalProduct
        FIELDS ( ProductUUID PrincipalUUID ExternalCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      CLEAR code_exists.

      SELECT SINGLE @abap_true
        FROM zi_msl_pr_product
        WITH PRIVILEGED ACCESS
        WHERE PrincipalUUID = @product-PrincipalUUID
          AND ExternalCode  = @product-ExternalCode
          AND ProductUUID  <> @product-ProductUUID
        INTO @code_exists.

      IF code_exists = abap_true.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-principalproduct.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Product code already exists for this principal'
          )
          %element-ExternalCode = if_abap_behv=>mk-on
        ) TO reported-principalproduct.

        CONTINUE.

      ENDIF.

      LOOP AT products INTO DATA(other_product)
        WHERE PrincipalUUID = product-PrincipalUUID
          AND ExternalCode  = product-ExternalCode
          AND ProductUUID  <> product-ProductUUID.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-principalproduct.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Product code already exists for this principal'
          )
          %element-ExternalCode = if_abap_behv=>mk-on
        ) TO reported-principalproduct.

        EXIT.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

METHOD ValidateCodeFormat.

  READ ENTITIES OF zi_msl_pr_product IN LOCAL MODE
    ENTITY PrincipalProduct
      FIELDS ( ExternalCode )
      WITH CORRESPONDING #( keys )
    RESULT DATA(products).

  LOOP AT products INTO DATA(product).

    IF product-ExternalCode IS INITIAL
       OR NOT matches(
         val   = product-ExternalCode
         regex = '^[A-Z0-9.-]+$'
       ).

      APPEND VALUE #(
        %tky = product-%tky
      ) TO failed-principalproduct.

      APPEND VALUE #(
        %tky = product-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Product code may contain only A-Z, 0-9, hyphen and dot'
        )
        %element-ExternalCode = if_abap_behv=>mk-on
      ) TO reported-principalproduct.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD NormalizeExternalCode.

  READ ENTITIES OF zi_msl_pr_product IN LOCAL MODE
    ENTITY PrincipalProduct
      FIELDS ( ExternalCode )
      WITH CORRESPONDING #( keys )
    RESULT DATA(products).

  DATA updates TYPE TABLE FOR UPDATE zi_msl_pr_product.

  LOOP AT products INTO DATA(product).

    DATA(normalized_code) = to_upper( product-ExternalCode ).

    IF normalized_code <> product-ExternalCode.
      APPEND VALUE #(
        %tky         = product-%tky
        ExternalCode = normalized_code
      ) TO updates.
    ENDIF.

  ENDLOOP.

  IF updates IS NOT INITIAL.
    MODIFY ENTITIES OF zi_msl_pr_product IN LOCAL MODE
      ENTITY PrincipalProduct
        UPDATE FIELDS ( ExternalCode )
        WITH updates.
  ENDIF.

ENDMETHOD.
ENDCLASS.
