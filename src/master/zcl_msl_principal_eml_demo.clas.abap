CLASS zcl_msl_principal_eml_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_msl_principal_eml_demo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    MODIFY ENTITIES OF zi_msl_principal
*      ENTITY Principal
*      CREATE
*      FIELDS (
*        ExternalCode
*        Name
*        DefaultCommissionPct
*        Status
*        SapBusinessPartner
*      )
*      WITH VALUE #(
*        (
*          %cid                 = 'P1'
*          ExternalCode         = 'DEMO001'
*          Name                 = 'Demo Industrial'
*          DefaultCommissionPct = '5.00'
*          Status               = 'ACTIVE'
*        )
*      )
*      MAPPED   DATA(mapped)
*      FAILED   DATA(failed)
*      REPORTED DATA(reported).
*
*    out->write( mapped ).
*    out->write( failed ).
*    out->write( reported ).
*
*    COMMIT ENTITIES.
*
*    out->write( 'Create operation completed.' ).

*
*    MODIFY ENTITIES OF zi_msl_principal
*      ENTITY Principal
*      UPDATE FIELDS (
*        Name
*        Status
*      )
*      WITH VALUE #(
*        (
*          PrincipalUUID = '9ED0DB71CA851FD1AF967C046E330DC5'
*          Name          = 'Demo Industrial Updated'
*          Status        = 'INACTIVE'
*        )
*      )
*      FAILED   DATA(update_failed)
*      REPORTED DATA(update_reported).
*
*    out->write( update_failed ).
*    out->write( update_reported ).
*
*    out->write( 'Update operation completed.' ).
*
*    COMMIT ENTITIES.
*
*    READ ENTITIES OF zi_msl_principal
*      ENTITY Principal
*      FIELDS (
*        PrincipalUUID
*        ExternalCode
*        Name
*        DefaultCommissionPct
*        Status
*        SapBusinessPartner
*        CreatedBy
*        CreatedAt
*        LocalLastChangedBy
*        LocalLastChangedAt
*        LastChangedAt
*      )
*      WITH VALUE #(
*        (
*          PrincipalUUID = '9ED0DB71CA851FD1AF967C046E330DC5'
*        )
*      )
*      RESULT   DATA(principals)
*      FAILED   DATA(read_failed)
*      REPORTED DATA(read_reported).
*
*    out->write( principals ).
*    out->write( read_failed ).
*    out->write( read_reported ).

MODIFY ENTITIES OF zi_msl_principal
  ENTITY Principal
  DELETE FROM VALUE #(
    (
      PrincipalUUID = '9ED0DB71CA851FD1AF967C046E330DC5'
    )
  )
  FAILED   DATA(delete_failed)
  REPORTED DATA(delete_reported).

out->write( delete_failed ).
out->write( delete_reported ).

COMMIT ENTITIES.

out->write( 'Delete operation completed.' ).

  ENDMETHOD.

ENDCLASS.
