CLASS lhc_principal DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS SetInitialStatus FOR DETERMINE ON MODIFY
       keys FOR Principal~SetInitialStatus.
    METHODS Approve FOR MODIFY
       keys FOR ACTION Principal~Approve RESULT result.
    METHODS Reject FOR MODIFY
       keys FOR ACTION Principal~Reject RESULT result.
    METHODS Deactivate FOR MODIFY
       keys FOR ACTION Principal~Deactivate RESULT result.
    METHODS Reactivate FOR MODIFY
       keys FOR ACTION Principal~Reactivate RESULT result.
    METHODS Suspend FOR MODIFY
       keys FOR ACTION Principal~Suspend RESULT result.
    METHODS SubmitForReview FOR MODIFY
      keys FOR ACTION Principal~SubmitForReview RESULT result.

ENDCLASS.

CLASS lhc_principal IMPLEMENTATION.

  METHOD SetInitialStatus.

    MODIFY ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        UPDATE FIELDS ( Status )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky   = key-%tky
            Status = 'REVIEW'
          )
        ).

  ENDMETHOD.

  METHOD Approve.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(principals)
      FAILED DATA(read_failed)
      REPORTED DATA(read_reported).

    LOOP AT principals INTO DATA(principal).

      IF principal-Status <> 'REVIEW'.

        APPEND VALUE #(
          %tky = principal-%tky
        ) TO failed-Principal.

        APPEND VALUE #(
          %tky = principal-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only principals under review can be approved'
          )
        ) TO reported-Principal.

        CONTINUE.

      ENDIF.

      IF principal-SapBusinessPartner IS INITIAL.

        APPEND VALUE #(
          %tky = principal-%tky
        ) TO failed-Principal.

        APPEND VALUE #(
          %tky = principal-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'SAP Business Partner is required for approval'
          )
        ) TO reported-Principal.

        CONTINUE.

      ENDIF.

      DATA updates TYPE TABLE FOR UPDATE zi_msl_principal\\Principal.

      APPEND VALUE #(
        %tky   = principal-%tky
        Status = 'ACTIVE'
      ) TO updates.

      MODIFY ENTITIES OF zi_msl_principal IN LOCAL MODE
        ENTITY Principal
          UPDATE FIELDS ( Status )
          WITH updates.

    ENDLOOP.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(updated_principals).

    result = VALUE #(
      FOR updated_principal IN updated_principals
      (
        %tky   = updated_principal-%tky
        %param = updated_principal
      )
    ).

  ENDMETHOD.

  METHOD Reject.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(principals).

    LOOP AT principals INTO DATA(principal).

      IF principal-Status <> 'REVIEW'.

        APPEND VALUE #(
          %tky = principal-%tky
        ) TO failed-Principal.

        APPEND VALUE #(
          %tky = principal-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only principals under review can be rejected'
          )
        ) TO reported-Principal.

        CONTINUE.

      ENDIF.

      DATA updates TYPE TABLE FOR UPDATE zi_msl_principal\\Principal.

      APPEND VALUE #(
        %tky   = principal-%tky
        Status = 'INACTIVE'
      ) TO updates.

      MODIFY ENTITIES OF zi_msl_principal IN LOCAL MODE
        ENTITY Principal
          UPDATE FIELDS ( Status )
          WITH updates.

    ENDLOOP.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(updated_principals).

    result = VALUE #(
      FOR updated_principal IN updated_principals
      (
        %tky   = updated_principal-%tky
        %param = updated_principal
      )
    ).

  ENDMETHOD.

  METHOD Deactivate.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(principals).

    LOOP AT principals INTO DATA(principal).

      IF principal-Status <> 'ACTIVE'
         AND principal-Status <> 'SUSPENDED'.

        APPEND VALUE #(
          %tky = principal-%tky
        ) TO failed-Principal.

        APPEND VALUE #(
          %tky = principal-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only active or suspended principals can be deactivated'
          )
        ) TO reported-Principal.

        CONTINUE.

      ENDIF.

      DATA updates TYPE TABLE FOR UPDATE zi_msl_principal\\Principal.

      APPEND VALUE #(
        %tky   = principal-%tky
        Status = 'INACTIVE'
      ) TO updates.

      MODIFY ENTITIES OF zi_msl_principal IN LOCAL MODE
        ENTITY Principal
          UPDATE FIELDS ( Status )
          WITH updates.

    ENDLOOP.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(updated_principals).

    result = VALUE #(
      FOR updated_principal IN updated_principals
      (
        %tky   = updated_principal-%tky
        %param = updated_principal
      )
    ).

  ENDMETHOD.

  METHOD Reactivate.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(principals).

    LOOP AT principals INTO DATA(principal).

      IF principal-Status <> 'SUSPENDED'.

        APPEND VALUE #(
          %tky = principal-%tky
        ) TO failed-Principal.

        APPEND VALUE #(
          %tky = principal-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only suspended principals can be reactivated'
          )
        ) TO reported-Principal.

        CONTINUE.

      ENDIF.

      IF principal-SapBusinessPartner IS INITIAL.

        APPEND VALUE #(
          %tky = principal-%tky
        ) TO failed-Principal.

        APPEND VALUE #(
          %tky = principal-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'SAP Business Partner is required for reactivation'
          )
        ) TO reported-Principal.

        CONTINUE.

      ENDIF.

      DATA updates TYPE TABLE FOR UPDATE zi_msl_principal\\Principal.

      APPEND VALUE #(
        %tky   = principal-%tky
        Status = 'ACTIVE'
      ) TO updates.

      MODIFY ENTITIES OF zi_msl_principal IN LOCAL MODE
        ENTITY Principal
          UPDATE FIELDS ( Status )
          WITH updates.

    ENDLOOP.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(updated_principals).

    result = VALUE #(
      FOR updated_principal IN updated_principals
      (
        %tky   = updated_principal-%tky
        %param = updated_principal
      )
    ).

  ENDMETHOD.

  METHOD Suspend.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(principals).

    LOOP AT principals INTO DATA(principal).

      IF principal-Status <> 'ACTIVE'.

        APPEND VALUE #(
          %tky = principal-%tky
        ) TO failed-Principal.

        APPEND VALUE #(
          %tky = principal-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Only active principals can be suspended'
          )
        ) TO reported-Principal.

        CONTINUE.

      ENDIF.

      DATA updates TYPE TABLE FOR UPDATE zi_msl_principal\\Principal.

      APPEND VALUE #(
        %tky   = principal-%tky
        Status = 'SUSPENDED'
      ) TO updates.

      MODIFY ENTITIES OF zi_msl_principal IN LOCAL MODE
        ENTITY Principal
          UPDATE FIELDS ( Status )
          WITH updates.

    ENDLOOP.

    READ ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(updated_principals).

    result = VALUE #(
      FOR updated_principal IN updated_principals
      (
        %tky   = updated_principal-%tky
        %param = updated_principal
      )
    ).

  ENDMETHOD.

METHOD SubmitForReview.

  READ ENTITIES OF zi_msl_principal IN LOCAL MODE
    ENTITY Principal
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(principals).

  LOOP AT principals INTO DATA(principal).

    IF principal-Status <> 'INACTIVE'.

      APPEND VALUE #(
        %tky = principal-%tky
      ) TO failed-Principal.

      APPEND VALUE #(
        %tky = principal-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Only inactive principals can be submitted for review'
        )
      ) TO reported-Principal.

      CONTINUE.

    ENDIF.

    DATA updates TYPE TABLE FOR UPDATE zi_msl_principal\\Principal.

    APPEND VALUE #(
      %tky   = principal-%tky
      Status = 'REVIEW'
    ) TO updates.

    MODIFY ENTITIES OF zi_msl_principal IN LOCAL MODE
      ENTITY Principal
        UPDATE FIELDS ( Status )
        WITH updates.

    IF principal-SapBusinessPartner IS NOT INITIAL.

      APPEND VALUE #(
        %tky = principal-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-warning
          text     = 'Verify that the SAP Business Partner is still valid before approval'
        )
      ) TO reported-Principal.

    ENDIF.

  ENDLOOP.

  READ ENTITIES OF zi_msl_principal IN LOCAL MODE
    ENTITY Principal
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(updated_principals).

  result = VALUE #(
    FOR updated_principal IN updated_principals
    (
      %tky   = updated_principal-%tky
      %param = updated_principal
    )
  ).

ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

