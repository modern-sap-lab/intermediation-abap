@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tariff interface entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MSL_TARIFF
  as select from zmsl_tariff

  association [1..1] to ZI_MSL_PRINCIPAL   as _Principal on $projection.PrincipalUUID = _Principal.PrincipalUUID

  composition [0..*] of ZI_MSL_TARIFF_ITEM as _Items
{
  key tariff_uuid           as TariffUUID,

      principal_uuid        as PrincipalUUID,
      external_code         as ExternalCode,
      name                  as Name,

      valid_from            as ValidFrom,
      valid_to              as ValidTo,

      currency_code         as CurrencyCode,

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

      _Principal,
      _Items
}
