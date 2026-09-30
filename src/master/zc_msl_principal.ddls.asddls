@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Intermediation partner consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_MSL_PRINCIPAL
  provider contract transactional_query
  as projection on ZI_MSL_PRINCIPAL
{
  key PrincipalUUID,
      ExternalCode,
      Name,
      DefaultCommissionPct,
      Status,
      SapBusinessPartner,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
