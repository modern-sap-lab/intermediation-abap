@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tariff consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZC_MSL_TARIFF
  provider contract transactional_query
  as projection on ZI_MSL_TARIFF
{
  key TariffUUID,

      PrincipalUUID,
      ExternalCode,
      Name,
      ValidFrom,
      ValidTo,
      CurrencyCode,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,

      _Principal,

      _Items : redirected to composition child ZC_MSL_TARIFF_ITEM
}
