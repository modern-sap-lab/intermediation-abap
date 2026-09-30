@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Intermediation partner interface entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MSL_PRINCIPAL as select from zmsl_principal
{
  key principal_uuid       as PrincipalUUID,

      external_code        as ExternalCode,
      name                 as Name,
      default_commission_pct
                           as DefaultCommissionPct,
      status               as Status,
      sap_business_partner as SapBusinessPartner,

      @Semantics.user.createdBy: true
      created_by           as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at           as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by
                           as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at
                           as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at      as LastChangedAt
}
