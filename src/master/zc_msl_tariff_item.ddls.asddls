@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tariff item consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_MSL_TARIFF_ITEM
  as projection on ZI_MSL_TARIFF_ITEM
{
  key TariffItemUUID,

      TariffUUID,

      @EndUserText.label: 'Product'
      ProductUUID,

      @EndUserText.label: 'Unit Price'
      UnitPrice,

      @EndUserText.label: 'Commission %'
      CommissionPct,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,

      _Product,
      
      _Tariff : redirected to parent ZC_MSL_TARIFF
}
