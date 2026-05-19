# Landlord Contracts Property API Design

**Phase:** Phase 4 - Billing & Contracts

**Goal**

Replace the mocked landlord contracts list with real contract data loaded from `/api/v1/contracts/property/{propertyId}`.

**Why**

The current landlord contracts screen builds fake contract cards from `RoomCubit`. That makes the screen inconsistent with backend state and prevents contract status, tenant info, and scanned contract metadata from reflecting real data.

## Scope

- Add property-level contract fetching to the `contract` feature.
- Extend the contract entity/model to map the API payload fields already returned by backend.
- Update the landlord contracts screen to load and render real contracts.
- Keep create-contract flow working as-is.

## API Contract

Endpoint:

- `GET /api/v1/contracts/property/{propertyId}`

Expected item shape:

```json
{
  "id": "c0000001-0000-0000-0000-000000000001",
  "roomId": "a0000001-0000-0000-0000-000000000001",
  "tenantId": "22222222-2222-2222-2222-222222222222",
  "roomName": "P.101",
  "tenantName": "Tran Thi Binh",
  "tenantPhone": "0922222222",
  "depositAmount": 5000000,
  "startDate": "2025-05-31T17:00:00Z",
  "endDate": "2026-12-30T17:00:00Z",
  "status": "Expired",
  "scannedContractUrl": "https://storage.smartstay.vn/contracts/hd001.jpg",
  "createdAt": "2025-05-25T03:00:00Z"
}
```

## Chosen Approach

Use the existing `contract` feature end-to-end:

- datasource -> repository -> cubit -> screen

This is the cleanest option because the API already returns the exact fields needed for the list screen. There is no need to join with `RoomCubit` or keep fake fallback data.

## Data Model Changes

Extend `Contract` and `ContractModel` with these optional or required fields:

- `roomName`
- `tenantName`
- `tenantPhone`
- `scannedContractUrl`
- `createdAt`

Status mapping remains based on backend strings:

- `Draft`
- `Active`
- `Expired`
- `Terminated`

UI-only derived groupings for the landlord contracts screen:

- `Dang hoat dong`: `status == Active` and not expiring soon
- `Sap het han`: `status == Active` and `endDate` is within the warning threshold
- `Da het han`: `status == Expired`

`Giu cho` is removed from this screen because it is a room state, not a contract state.

## State Management Changes

`ContractCubit` currently only supports submit states for create-contract. It needs list-loading states as well:

- `ContractLoading`
- `ContractLoaded`
- `ContractError`

Create-contract submit states should remain intact so [landlord_create_contract_screen.dart](/f:/Documents/Flutter/smart_stay_client/lib/features/landlord_dashboard/presentation/screens/landlord_create_contract_screen.dart:1) does not regress.

## Screen Behavior

For [landlord_contracts_screen.dart](/f:/Documents/Flutter/smart_stay_client/lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart:1):

- Resolve the selected `propertyId` from `PropertyCubit`.
- Trigger `ContractCubit.loadContractsByProperty(propertyId)` on first load and when selected property changes.
- Render loading, error, empty, and loaded states.
- Search on `roomName` and `tenantName`.
- Filter chips become:
  - `Tat ca`
  - `Dang hoat dong`
  - `Sap het han`
  - `Da het han`
- Cards use real values from the contract entity.
- Tapping a card can keep its current behavior for now if there is no dedicated contract detail route yet.

## Error Handling

- If no property is selected, show an empty-state hint instead of trying to fetch.
- If API fails, show the existing friendly error block.
- If response fields are missing, map to safe defaults without crashing.

## Testing Strategy

Planned verification after implementation:

- model mapping for the new contract payload
- repository passthrough for property-level fetch
- cubit list loading states
- landlord contracts screen rendering for loading, empty, loaded, and filtered states

## Non-Goals

- No contract detail screen in this slice
- No tenant contract screen refactor in this slice
- No scanned contract download/open action in this slice
