# BillLearn MVP Design

## Overview

BillLearn is an automatic personal expense ledger that learns from payment receipts, push notifications, and SMS messages. The first product target is Android because Android allows the app to collect payment-related notifications and SMS messages with user permission. The product should still be structured for future iOS support and server-based data sources such as MyData or financial APIs.

The MVP focuses on one core workflow:

1. Collect payment notifications and SMS messages.
2. Parse them into transaction candidates.
3. Detect duplicates, transfers, and non-expense events.
4. Save confirmed real expenses.
5. Show cleaned expense data on the home and history screens.

Budgeting, advanced analytics, and AI insight features are explicitly out of scope for the MVP. They can be added after the automatic collection and expense-cleaning workflow is reliable.

## Product Principles

- BillLearn should behave like an expense-cleaning system, not a simple notification collector.
- Raw notification data and final expense data must be separate.
- The home and history screens must show only cleaned real expenses.
- Ambiguous cases should be visible and easy to correct.
- The app should start without mandatory signup.
- Local-first storage is the MVP default, but the model must leave room for later server sync.

## Platform Strategy

The MVP will use Flutter for shared app UI and domain logic, with Android-native modules for platform-specific collection.

Flutter is responsible for:

- App screens and navigation.
- Shared domain models.
- Expense classification result presentation.
- Local repository interfaces.
- Home, history, detail, and settings workflows.

Android native code is responsible for:

- Notification access through `NotificationListenerService`.
- SMS permission and SMS collection.
- Android permission-state checks.
- Flutter bridge integration through method or event channels.

iOS is not a first-class automatic collection target in the MVP because iOS does not expose the same broad notification and SMS access model. Future iOS support should reuse Flutter UI and domain concepts, but receive data through other sources such as MyData, card issuer integrations, financial APIs, server sync, or manual input.

## MVP Screens

### Home

The home screen shows the current month's real expenses, recent cleaned transactions, and a compact summary of items that need user confirmation. It should reflect the white and purple BillLearn brand direction and use the mascot selectively to reinforce trust without making the screen feel decorative.

### History

The history screen lists real expenses grouped by date. It supports simple filtering by period and category. It reads from confirmed `ExpenseTransaction` records, not raw notifications.

### Transaction Detail

The detail screen shows the final transaction, linked source information, classification reason, category, and user feedback actions such as "correct" or "incorrect". This is where the user can confirm whether the app interpreted a transaction properly.

### Settings and Permissions

The settings screen shows notification access status, SMS permission status, local data controls, and future account/sync entry points. Permission recovery should be clear because Android notification access requires the user to visit a system settings screen.

## Onboarding

The first-run experience should explain the app in a direct, privacy-aware way:

> BillLearn reads amount, merchant, and time from payment notifications and SMS messages to organize only your real expenses. Raw data is stored on this device first.

The onboarding should not request every permission at once. It should explain notification access and SMS access separately:

- Notification access: used to analyze card, bank, and payment app push notifications.
- SMS access: used to analyze card and bank payment messages.

The user can start without signing up. If permissions are not granted, the app can show sample data or a limited empty state, but it should make clear that automatic collection requires Android permissions.

## Domain Model

### RawNotification

`RawNotification` stores the original input from Android push notifications or SMS messages.

Fields:

- `id`
- `sourceType`
- `sourceApp`
- `sender`
- `title`
- `body`
- `receivedAt`
- `sourceHash`
- `createdAt`

Raw data is retained as evidence for parsing, duplicate detection, and user correction.

### TransactionCandidate

`TransactionCandidate` is a parsed payment-like event extracted from raw input. It is not yet a confirmed expense.

Fields:

- `id`
- `rawNotificationId`
- `amount`
- `merchantName`
- `paymentMethodHint`
- `occurredAt`
- `sourceType`
- `parseConfidence`
- `parseStatus`
- `createdAt`

### ExpenseTransaction

`ExpenseTransaction` is the final transaction shown in user-facing expense views.

Fields:

- `id`
- `amount`
- `merchantName`
- `categoryId`
- `spentAt`
- `confirmationStatus`
- `confirmedBy`
- `candidateIds`
- `createdAt`
- `updatedAt`
- `syncStatus`

### ClassificationResult

`ClassificationResult` stores the decision made for a candidate or candidate group.

Fields:

- `id`
- `candidateIds`
- `isDuplicate`
- `isTransferLike`
- `isExpense`
- `requiresReview`
- `reasonCodes`
- `confidence`
- `createdAt`
- `userFeedback`

## Classification Rules

The MVP should start with explainable rule-based classification. AI can be added later after enough examples and correction data exist.

### Duplicate Detection

Candidates should be grouped when they have:

- Same or very similar amount.
- Similar merchant name.
- Close timestamps.
- Matching payment method or account/card hints.

This handles common cases where a card push notification and SMS message describe the same payment.

### Transfer and Non-Expense Detection

Events should be deprioritized or sent to review when the text contains transfer-like patterns such as:

- `이체`
- `입금`
- `출금`
- `송금`
- `충전`
- `자동이체`
- `계좌간`
- `내 계좌`

Automatic transfers are not always excluded because telecom bills, insurance, subscriptions, and utilities can appear as automatic transfer events. Ambiguous cases should become review items instead of being silently removed.

### Real Expense Confirmation

Candidates can be confirmed as expenses when they contain stable payment language, amount, merchant, and time signals. Examples include card approval, check-card payment, and payment-app approval messages.

### Review Required

A candidate should require review when:

- Amount exists but merchant parsing is weak.
- Transfer and expense signals both exist.
- Duplicate probability is high but not decisive.
- Source text is unsupported or unfamiliar.

### Feedback Learning

User corrections should be stored as structured feedback. Repeated feedback can create local rules, such as excluding a sender pattern or applying a category to a known merchant.

## Data and Sync Strategy

The MVP is local-first. Data is stored on the device without mandatory account creation.

The app must still prepare for future sync by:

- Using repository interfaces instead of direct UI-to-database access.
- Keeping stable IDs and timestamps.
- Storing `syncStatus` on user-facing records.
- Avoiding database-specific logic inside domain classification rules.
- Separating raw input, candidates, classification results, and final expenses.

Future server sync can be added as another repository implementation or as a sync layer behind the existing repository interfaces.

## Architecture

The Flutter project should be organized into four main areas.

### Presentation

Contains screens, navigation, state management, and visual components. Presentation code asks use cases or repositories for data and does not know Android notification or SMS details.

### Domain

Contains core models, classification logic, duplicate grouping, transfer detection, and use case interfaces. This layer should be testable without Flutter UI or Android runtime dependencies.

### Data

Contains local database implementation, parsers, repository implementations, and sync-ready persistence fields. MVP storage can use a local database such as SQLite through a Flutter-friendly persistence library.

### Platform Android

Contains Android-specific collectors and bridge code. It emits raw notification and SMS events into Flutter through a stable contract.

## Testing Strategy

### Parser Tests

Verify that representative payment notifications and SMS messages produce correct amount, merchant, time, and source fields.

### Classification Tests

Cover duplicate push-plus-SMS cases, transfer-like cases, automatic transfer ambiguity, payment-app approval, and unsupported text.

### Repository Tests

Verify that raw input, candidates, classification results, and final expenses are stored separately and can be linked.

### UI Tests

Verify that home and history screens show only `ExpenseTransaction` data and that review-required items remain clearly separated.

## Initial Non-Goals

- Mandatory signup.
- Cloud sync.
- Full iOS automatic collection.
- Budget management.
- Advanced AI insights.
- Bank scraping.
- MyData integration.
- Complex spending analytics.

## Open Decisions For Implementation Planning

- Flutter state management choice.
- Local database library.
- Exact Android bridge contract.
- Initial list of supported banks, card issuers, and payment apps.
- Sample notification and SMS fixtures for parser tests.

