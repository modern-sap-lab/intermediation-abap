@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Principal product interface entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MSL_PR_PRODUCT
  as select from zmsl_pr_product

  association [1..1] to ZI_MSL_PRINCIPAL as _Principal
    on $projection.PrincipalUUID = _Principal.PrincipalUUID

{
  key product_uuid          as ProductUUID,

      principal_uuid        as PrincipalUUID,
      external_code         as ExternalCode,
      name                  as Name,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      _Principal
}
