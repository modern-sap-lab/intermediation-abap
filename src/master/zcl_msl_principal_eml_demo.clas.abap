CLASS zcl_msl_principal_eml_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_msl_principal_eml_demo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    MODIFY ENTITIES OF zi_msl_principal
      ENTITY Principal
      CREATE
      FIELDS (
        ExternalCode
        Name
        DefaultCommissionPct
        Status
        SapBusinessPartner
      )
      WITH VALUE #(
        (
          %cid                 = 'P1'
          ExternalCode         = 'DEMO001'
          Name                 = 'Demo Industrial'
          DefaultCommissionPct = '5.00'
          Status               = 'ACTIVE'
        )
      )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    out->write( mapped ).
    out->write( failed ).
    out->write( reported ).

    COMMIT ENTITIES.

    out->write( 'Create operation completed.' ).

  ENDMETHOD.

ENDCLASS.
