# modern-sap-lab

[Versión en español](README_es.md)

`modern-sap-lab` is a hands-on SAP architecture lab built around a commercial intermediation scenario.

The goal is not to recreate an ERP outside SAP or to maximize the number of technologies used. The goal is to show how **ABAP Cloud, RAP, CAP, SAP BTP, Integration Suite and S/4HANA** can work together while keeping the ERP core clean.

## Clean Core approach

The project follows one guiding rule:

> Keep standard ERP responsibilities in S/4HANA and implement business-specific intermediation capabilities as decoupled extensions using released APIs and explicit contracts.

Responsibilities are intentionally separated:

| Component | Responsibility |
|---|---|
| **S/4HANA** | Business Partner, billing, taxes, payment terms, accounting and other standard ERP capabilities |
| **ABAP Cloud / RAP** | Core intermediation domain and transactional business objects |
| **CAP** | External-facing service facade and consumer-oriented APIs |
| **SAP Integration Suite** | Connectivity, routing, transformation and protocol adaptation |
| **SAP BTP / side-by-side extensions** | Extension runtime and decoupled application capabilities |

Business rules such as intermediation pricing, lifecycle management, delivery reconciliation and commission calculation belong to the extension domain, not to custom logic embedded unnecessarily in S/4HANA.

## Business scenario

The company acts as a commercial intermediary.

A **Principal** is a company whose products are intermediated — for example a manufacturer, wholesaler or distributor.

The intermediary does not purchase or stock the goods:

1. a customer orders products;
2. the Principal sells and ships directly to the customer;
3. the intermediary applies the commercial conditions valid for the order;
4. delivered quantities are reconciled;
5. commission is calculated on confirmed delivered business;
6. the intermediary later invoices its service to the Principal.

From the intermediary's SAP perspective, the Principal is expected to map primarily to a **Business Partner with Customer role**, because the Principal purchases the intermediation service.

## Architecture

```text
External consumers / channels
            |
            v
           CAP
            |
            v
     RAP service contract
            |
            v
 ABAP Cloud / Intermediation domain
            |
      +-----+------+
      |            |
      v            v
Integration     ABAP/BTP
  Suite         persistence
      |
      v
   S/4HANA
```

The diagram represents responsibility boundaries. Not every integration flow is required to pass through every component.

## Repositories

| Repository | Role | Status |
|---|---|---|
| [`intermediation-abap`](https://github.com/modern-sap-lab/intermediation-abap) | ABAP Cloud / RAP domain implementation | **Functional / in progress** |
| `intermediation-cap` | CAP facade for external consumers | **Planned** |
| `intermediation-integration` | Integration Suite contracts and integration flows | **Planned** |
| `intermediation-extension` | BTP side-by-side extension example | **Planned** |

The repositories are intentionally separated so that each one has a clear architectural responsibility.

## Current implementation

The ABAP repository already contains the first functional business object: **Principal Management**.

Implemented concepts include:

- ABAP Cloud persistence;
- CDS root and projection entities;
- managed RAP behavior;
- EML;
- Fiori Elements;
- OData UI exposure;
- RAP-managed UUID and audit fields;
- lifecycle actions;
- business validation.

Principal lifecycle:

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

A Principal must have an SAP Business Partner reference before becoming operational. In the current lab this checks that the reference is present; live validation against S/4HANA is a future integration step.

## Planned domain

The full business scenario is designed to evolve through:

- Principal products;
- dated tariffs;
- temporary offers;
- pricing and economic snapshots;
- orders;
- confirmed deliveries;
- commission calculation;
- settlements;
- S/4HANA integration.

These modules describe the target domain. They are not all required to be implemented for the architecture to be demonstrated.

## Design principles

- **Clean Core first** — no unnecessary custom logic inside S/4HANA.
- **One source of truth per business capability** — CAP does not duplicate the RAP domain.
- **Explicit contracts** — components communicate through services and APIs, not shared database assumptions.
- **Integration is not business logic** — Integration Suite adapts and routes; domain rules stay in the domain.
- **No technology for technology's sake** — additional services are introduced only when they have a clear responsibility.
- **Implemented and planned scope are clearly separated**.

## Purpose

This organization is a personal technical lab and portfolio project. It is intended to demonstrate practical understanding of modern SAP development and architecture, not to represent a production customer implementation.

The project is being developed incrementally: each repository should remain understandable and useful even while the wider architecture is still being completed.
