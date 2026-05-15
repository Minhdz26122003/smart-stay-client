# Ticket Model Enums Refactoring Design

## Overview
Refactor the `Ticket` model to use native Dart Enums with `json_serializable` annotations (`@JsonValue`) instead of using custom `int` mapping via converters. This reduces boilerplate code and improves type safety while communicating with the backend.

## Approach
- **Enums**: We will introduce `TicketCategory` and `TicketPriority` enums in the entity domain file (`ticket.dart`).
- **Annotations**: 
  - We will use `@JsonValue('Water')`, `@JsonValue('Medium')`, etc. for accurate mapping.
  - We will annotate the enums with `@JsonEnum(alwaysCreate: true, unknownEnumValue: ...)` to prevent crashes if the backend introduces a new category/priority not yet handled by the app.
- **Model Clean up**: Remove the manual `JsonConverter` implementations from `ticket_model.dart` since `json_serializable` will handle it natively.
- **UI Update**: Replace usages of `.categoryName` (from previous custom extension) with the new enum's getter for display names.

## Data Flow
API Payload (String) -> json_serializable -> Dart Enum (TicketCategory, TicketPriority) -> UI (Enum.displayName).

## Fallback / Error Handling
If an unknown string is sent from the backend (e.g. `category: "Internet"`), the parsing will safely fallback to the `unknownEnumValue` (e.g. `TicketCategory.other`), ensuring no app crashes.
