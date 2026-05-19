| Task | Status | Note |
|---|---|---|
| Task 1: Add delete announcement cubit states | Done | Added delete in-progress and delete error loaded states |
| Task 2: Wire confirmed delete flow in landlord board screen | Done | Added confirm dialog, card-level spinner, and delete feedback |
| Task 3: Verify touched files | Not run | Per user request, verification commands were skipped |
| Task 4: Plan fix for room delete refresh | In progress | Root cause traced to room detail pop without result, rooms list not reloading |
| Task 5: Implement tenant ticket create flow | Done | Added create payload, cubit action states, router args, and a functional tenant report screen |
| Task 6: Implement landlord and tenant resolve/cancel flow | Done | Reworked ticket statuses, landlord issue flows, tenant issue detail, and issue list filtering |
| Task 7: Fix Listings UI & Image Handling | Done | Auto-format image storage URLs and fix FloatingActionButton list overlap |
| Task 8: Load dynamic landlord issues in Operations Screen | Done | Use BlocBuilder with TicketCubit to load and format active landlord issues |
| Task 9: Implement dynamic Landlord Contracts Screen | Done | Add LandlordContractsScreen, configure route, and update Quick Action |
| Task 10: Plan landlord contracts property API integration | Done | Wrote approved design and implementation plan for loading real contracts by property |
| Task 11: Extend contract entity and model for property payload | Done | Added room and tenant metadata fields plus scanned contract and createdAt mapping |
| Task 12: Add property-level contract fetch to datasource and repository | Done | Added `/api/v1/contracts/property/{propertyId}` through datasource and repository |
| Task 13: Add contract list-loading states and cubit action | Done | Added ContractLoading, ContractLoaded, ContractError and loadContractsByProperty |
| Task 14: Replace mocked landlord contracts screen with contract cubit data | Done | Removed seeded mock contracts and loaded real contracts from selected property |
| Task 15: Update operations dashboard contract summary if needed | Skipped | Kept operations contract summary unchanged in this slice |
| Task 16: Update planning docs and changelog after implementation | Done | Tracker and changelog updated for contract API integration |
| Task 17: Run focused verification | Not run | Skipped per user request to implement without running tests |
