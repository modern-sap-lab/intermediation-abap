@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Principal product consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZC_MSL_PR_PRODUCT
  provider contract transactional_query
  as projection on ZI_MSL_PR_PRODUCT
{
  key ProductUUID,

      @EndUserText.label: 'Principal'
      PrincipalUUID,

      @EndUserText.label: 'Product Code'
      ExternalCode,

      @EndUserText.label: 'Name'
      Name,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
