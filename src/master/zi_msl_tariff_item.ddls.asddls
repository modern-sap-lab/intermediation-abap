@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tariff item interface entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MSL_TARIFF_ITEM
  as select from zmsl_tariff_item

  association to parent ZI_MSL_TARIFF as _Tariff
    on $projection.TariffUUID = _Tariff.TariffUUID

  association [1..1] to ZI_MSL_PR_PRODUCT as _Product
    on $projection.ProductUUID = _Product.ProductUUID

{
  key tariff_item_uuid      as TariffItemUUID,

      tariff_uuid           as TariffUUID,
      product_uuid          as ProductUUID,

      unit_price            as UnitPrice,
      commission_pct        as CommissionPct,

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

      _Tariff,
      _Product
}
