# Landlord Contracts Property API Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Replace mocked landlord contract data with real contracts loaded from `/api/v1/contracts/property/{propertyId}`.

**Architecture:** Extend the existing `contract` feature through Clean Architecture boundaries and switch the landlord contracts screen to read from `ContractCubit` instead of synthesizing mock rows from `RoomCubit`. Keep create-contract states and behavior intact while adding a separate list-loading path.

**Tech Stack:** Flutter, flutter_bloc, Dio, GoRouter, Equatable, Clean Architecture

---

### Task 1: Extend the contract entity and model for property list payload

**Files:**
- Modify: `lib/features/contract/domain/entities/contract.dart`
- Modify: `lib/features/contract/data/models/contract_model.dart`
- Test: `test/features/contract/data/models/contract_model_test.dart`

**Step 1: Write the failing test**

Create a model test that parses:

- `roomName`
- `tenantName`
- `tenantPhone`
- `depositAmount`
- `startDate`
- `endDate`
- `status`
- `scannedContractUrl`
- `createdAt`

Expected assertions:

- `model.roomName == 'P.101'`
- `model.tenantName == 'Tran Thi Binh'`
- `model.tenantPhone == '0922222222'`
- `model.status == ContractStatus.expired`
- `model.createdAt != null`

**Step 2: Run test to verify it fails**

Run: `rtk flutter test test/features/contract/data/models/contract_model_test.dart`

Expected: FAIL because new fields do not exist yet.

**Step 3: Write minimal implementation**

- Add new fields to `Contract`.
- Add matching constructor params to `ContractModel`.
- Parse new fields from backend JSON.
- Keep safe defaults for missing values.

**Step 4: Run test to verify it passes**

Run: `rtk flutter test test/features/contract/data/models/contract_model_test.dart`

Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/contract/domain/entities/contract.dart lib/features/contract/data/models/contract_model.dart test/features/contract/data/models/contract_model_test.dart
git commit -m "feat: extend contract model for property list payload"
```

### Task 2: Add property-level contract fetch to datasource and repository

**Files:**
- Modify: `lib/features/contract/data/datasources/contract_remote_datasource.dart`
- Modify: `lib/features/contract/domain/repositories/contract_repository.dart`
- Modify: `lib/features/contract/data/repositories/contract_repository_impl.dart`
- Test: `test/features/contract/data/repositories/contract_repository_impl_test.dart`

**Step 1: Write the failing test**

Add a repository test that verifies `getContractsByProperty(propertyId)` delegates to the datasource and returns mapped `Contract` entities.

**Step 2: Run test to verify it fails**

Run: `rtk flutter test test/features/contract/data/repositories/contract_repository_impl_test.dart`

Expected: FAIL because the new repository method does not exist yet.

**Step 3: Write minimal implementation**

- Add `Future<List<ContractModel>> getContractsByProperty(String propertyId)` to the datasource contract.
- Call `GET /api/v1/contracts/property/$propertyId`.
- Add `Future<List<Contract>> getContractsByProperty(String propertyId)` to the repository contract and implementation.

**Step 4: Run test to verify it passes**

Run: `rtk flutter test test/features/contract/data/repositories/contract_repository_impl_test.dart`

Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/contract/data/datasources/contract_remote_datasource.dart lib/features/contract/domain/repositories/contract_repository.dart lib/features/contract/data/repositories/contract_repository_impl.dart test/features/contract/data/repositories/contract_repository_impl_test.dart
git commit -m "feat: add property-level contract fetch"
```

### Task 3: Add contract list-loading states and cubit action

**Files:**
- Modify: `lib/features/contract/presentation/cubit/contract_state.dart`
- Modify: `lib/features/contract/presentation/cubit/contract_cubit.dart`
- Test: `test/features/contract/presentation/cubit/contract_cubit_test.dart`

**Step 1: Write the failing test**

Add cubit tests for:

- `loadContractsByProperty` emits `ContractLoading` then `ContractLoaded`
- errors emit `ContractError`
- create-contract still emits submit states

**Step 2: Run test to verify it fails**

Run: `rtk flutter test test/features/contract/presentation/cubit/contract_cubit_test.dart`

Expected: FAIL because list-loading states and method do not exist yet.

**Step 3: Write minimal implementation**

- Add states:
  - `ContractLoading`
  - `ContractLoaded`
  - `ContractError`
- Add `loadContractsByProperty(String propertyId)` to `ContractCubit`.
- Preserve existing submit flow for create-contract.

**Step 4: Run test to verify it passes**

Run: `rtk flutter test test/features/contract/presentation/cubit/contract_cubit_test.dart`

Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/contract/presentation/cubit/contract_state.dart lib/features/contract/presentation/cubit/contract_cubit.dart test/features/contract/presentation/cubit/contract_cubit_test.dart
git commit -m "feat: add contract list loading states"
```

### Task 4: Replace mocked landlord contracts screen with contract cubit data

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart`
- Modify: `lib/core/routes/app_router.dart`
- Modify: `lib/core/di/injection_container.dart`
- Test: `test/features/landlord_dashboard/presentation/screens/landlord_contracts_screen_test.dart`

**Step 1: Write the failing test**

Add a widget test that covers:

- loading indicator while contracts load
- empty state when list is empty
- loaded state shows room name and tenant name from real contracts
- search filters contracts by room or tenant
- chips filter contracts into `Tat ca`, `Dang hoat dong`, `Sap het han`, `Da het han`

**Step 2: Run test to verify it fails**

Run: `rtk flutter test test/features/landlord_dashboard/presentation/screens/landlord_contracts_screen_test.dart`

Expected: FAIL because the screen still builds `_MockContract` rows from room data.

**Step 3: Write minimal implementation**

- Wrap screen with `BlocProvider(create: (_) => sl<ContractCubit>())` if not already provided above route level.
- Read selected property from `PropertyCubit`.
- Call `loadContractsByProperty(propertyId)` on first load and property changes.
- Remove `_MockContract` and random seeded data.
- Convert metrics and filters to use real `Contract` entities.
- Replace `Giu cho` tab with `Da het han`.
- Keep the floating action button route unchanged.

**Step 4: Run test to verify it passes**

Run: `rtk flutter test test/features/landlord_dashboard/presentation/screens/landlord_contracts_screen_test.dart`

Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart lib/core/routes/app_router.dart lib/core/di/injection_container.dart test/features/landlord_dashboard/presentation/screens/landlord_contracts_screen_test.dart
git commit -m "feat: load landlord contracts from property api"
```

### Task 5: Update operations dashboard contract summary if needed

**Files:**
- Modify: `lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart`
- Test: `test/features/landlord_dashboard/presentation/screens/landlord_operations_screen_test.dart`

**Step 1: Write the failing test**

Add a widget test for the contracts summary section if it is updated to depend on real contract data.

**Step 2: Run test to verify it fails**

Run: `rtk flutter test test/features/landlord_dashboard/presentation/screens/landlord_operations_screen_test.dart`

Expected: FAIL if the section is switched from static mock data to real data.

**Step 3: Write minimal implementation**

- If the contracts summary still stays static for this slice, skip this task.
- If updated, load expiring contract count from real contracts and replace the hardcoded rows.

**Step 4: Run test to verify it passes**

Run: `rtk flutter test test/features/landlord_dashboard/presentation/screens/landlord_operations_screen_test.dart`

Expected: PASS

**Step 5: Commit**

```bash
git add lib/features/landlord_dashboard/presentation/screens/landlord_operations_screen.dart test/features/landlord_dashboard/presentation/screens/landlord_operations_screen_test.dart
git commit -m "feat: sync operations contract summary with real contracts"
```

### Task 6: Update planning docs and changelog after implementation

**Files:**
- Modify: `docs/plans/task.md`
- Modify: `docs/CHANGELOG.md`

**Step 1: Update tracker**

- Mark contract API integration tasks as done in `docs/plans/task.md`.

**Step 2: Update changelog**

- Add a `2026-05-18` entry describing the landlord contracts API integration.

**Step 3: Commit**

```bash
git add docs/plans/task.md docs/CHANGELOG.md
git commit -m "docs: update contract integration tracking"
```

### Task 7: Run focused verification

**Files:**
- No source changes

**Step 1: Run focused tests**

Run:

- `rtk flutter test test/features/contract/data/models/contract_model_test.dart`
- `rtk flutter test test/features/contract/data/repositories/contract_repository_impl_test.dart`
- `rtk flutter test test/features/contract/presentation/cubit/contract_cubit_test.dart`
- `rtk flutter test test/features/landlord_dashboard/presentation/screens/landlord_contracts_screen_test.dart`

Expected: PASS

**Step 2: Run analyze on touched area**

Run: `rtk flutter analyze lib/features/contract lib/features/landlord_dashboard/presentation/screens/landlord_contracts_screen.dart`

Expected: no analyzer errors in touched files

**Step 3: Commit**

```bash
git add .
git commit -m "test: verify landlord contracts property api integration"
```
