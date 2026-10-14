# modern-sap-lab

[English version](README.md)

`modern-sap-lab` es un laboratorio práctico de arquitectura SAP construido sobre un caso de intermediación comercial.

El objetivo no es recrear un ERP fuera de SAP ni utilizar el mayor número posible de tecnologías. El objetivo es mostrar cómo pueden encajar **ABAP Cloud, RAP, CAP, SAP BTP, Integration Suite y S/4HANA** manteniendo limpio el core del ERP.

## Enfoque Clean Core

El proyecto sigue una regla principal:

> Mantener en S/4HANA las responsabilidades estándar del ERP e implementar las capacidades específicas de intermediación como extensiones desacopladas mediante APIs released y contratos explícitos.

Las responsabilidades se separan deliberadamente:

| Componente | Responsabilidad |
|---|---|
| **S/4HANA** | Business Partner, facturación, impuestos, condiciones de pago, contabilidad y demás capacidades estándar del ERP |
| **ABAP Cloud / RAP** | Dominio principal de intermediación y objetos de negocio transaccionales |
| **CAP** | Fachada de servicios para consumidores externos y APIs orientadas al consumidor |
| **SAP Integration Suite** | Conectividad, routing, transformación y adaptación de protocolos |
| **SAP BTP / extensiones side-by-side** | Runtime de extensiones y capacidades desacopladas |

Las reglas de negocio como pricing de intermediación, ciclo de vida, conciliación de entregas y cálculo de comisiones pertenecen al dominio de extensión, no a lógica custom embebida innecesariamente en S/4HANA.

## Escenario de negocio

La empresa actúa como intermediaria comercial.

Un **Principal** es una empresa cuyos productos son intermediados; por ejemplo, una fábrica, un mayorista o un distribuidor.

La intermediaria no compra ni almacena la mercancía:

1. un cliente realiza un pedido;
2. el Principal vende y entrega directamente al cliente;
3. la intermediaria aplica las condiciones comerciales vigentes;
4. se concilian las cantidades servidas;
5. la comisión se calcula sobre el negocio servido y confirmado;
6. la intermediaria factura posteriormente su servicio al Principal.

Desde la perspectiva SAP de la intermediaria, el Principal se prevé principalmente como **Business Partner con rol Customer**, porque es quien compra el servicio de intermediación.

## Arquitectura

```text
Consumidores / canales externos
            |
            v
           CAP
            |
            v
      Contrato RAP
            |
            v
 ABAP Cloud / Dominio de intermediación
            |
      +-----+------+
      |            |
      v            v
Integration     Persistencia
  Suite          ABAP/BTP
      |
      v
   S/4HANA
```

El diagrama representa fronteras de responsabilidad. No todos los flujos de integración tienen que atravesar todos los componentes.

## Repositorios

| Repositorio | Función | Estado |
|---|---|---|
| [`intermediation-abap`](https://github.com/modern-sap-lab/intermediation-abap) | Implementación del dominio con ABAP Cloud / RAP | **Funcional / en desarrollo** |
| `intermediation-cap` | Fachada CAP para consumidores externos | **Planificado** |
| `intermediation-integration` | Contratos y flujos de Integration Suite | **Planificado** |
| `intermediation-extension` | Ejemplo de extensión side-by-side en BTP | **Planificado** |

Los repositorios se mantienen separados para que cada uno tenga una responsabilidad arquitectónica clara.

## Implementación actual

El repositorio ABAP contiene ya el primer objeto de negocio funcional: **Principal Management**.

Conceptos implementados:

- persistencia ABAP Cloud;
- entidades CDS root y projection;
- comportamiento RAP managed;
- EML;
- Fiori Elements;
- exposición OData para UI;
- UUID y campos de auditoría gestionados por RAP;
- acciones de ciclo de vida;
- validaciones de negocio.

Ciclo de vida de Principal:

```text
REVIEW
 ├─ Approve ─────────► ACTIVE
 └─ Reject ──────────► INACTIVE

ACTIVE
 ├─ Suspend ─────────► SUSPENDED
 └─ Deactivate ──────► INACTIVE

SUSPENDED
 ├─ Reactivate ──────► ACTIVE
 └─ Deactivate ──────► INACTIVE

INACTIVE
 └─ SubmitForReview ─► REVIEW
```

Un Principal debe tener informada una referencia a SAP Business Partner antes de pasar a estado operativo. En el laboratorio actual se comprueba que la referencia exista como dato; la validación real contra S/4HANA queda para una fase de integración posterior.

## Dominio planificado

El escenario completo está diseñado para evolucionar mediante:

- productos del Principal;
- tarifas con vigencia temporal;
- ofertas temporales;
- pricing y snapshots económicos;
- pedidos;
- entregas confirmadas;
- cálculo de comisiones;
- liquidaciones;
- integración con S/4HANA.

Estos módulos describen el dominio objetivo. No todos necesitan estar implementados para demostrar la arquitectura.

## Principios de diseño

- **Clean Core primero** — evitar lógica custom innecesaria dentro de S/4HANA.
- **Una fuente de verdad por capacidad** — CAP no duplica el dominio RAP.
- **Contratos explícitos** — los componentes se comunican mediante servicios y APIs, no mediante supuestos compartidos sobre bases de datos.
- **Integración no es lógica de negocio** — Integration Suite adapta y enruta; las reglas permanecen en el dominio.
- **Nada de tecnología por la tecnología** — se añade un componente sólo si tiene una responsabilidad clara.
- **Separación explícita entre lo implementado y lo planificado**.

## Finalidad

Esta organización es un laboratorio técnico personal y un proyecto de portfolio. Pretende demostrar comprensión práctica del desarrollo y la arquitectura SAP modernos, no representar una implantación productiva real en cliente.

El proyecto se desarrolla de forma incremental: cada repositorio debe seguir siendo comprensible y útil aunque la arquitectura global todavía esté en construcción.
