# BillLearn MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first BillLearn Flutter MVP skeleton that collects Android notification/SMS raw events, parses them into candidates, classifies real expenses, stores them locally, and shows cleaned expenses in core screens.

**Architecture:** The app uses Flutter for shared UI, domain models, parsing, classification, and local persistence. Android-specific notification and SMS collection live behind a stable platform bridge so future iOS or server-based sources can feed the same domain pipeline. Raw inputs, parsed candidates, classification results, and final expenses are stored separately.

**Tech Stack:** Flutter, Dart 3, Riverpod, go_router, drift, sqlite3_flutter_libs, Android Kotlin, MethodChannel, EventChannel, flutter_test.

---

## File Structure

Create the Flutter app under `app/` so planning documents remain separate from product code.

- `app/pubspec.yaml`: Flutter dependencies and asset declarations.
- `app/lib/main.dart`: App entry point and provider scope.
- `app/lib/src/app/billlearn_app.dart`: App shell, router, theme.
- `app/lib/src/app/app_router.dart`: Route definitions.
- `app/lib/src/app/app_theme.dart`: Brand colors and Material theme.
- `app/lib/src/domain/models/raw_notification.dart`: Raw Android notification/SMS input model.
- `app/lib/src/domain/models/transaction_candidate.dart`: Parsed payment-like event model.
- `app/lib/src/domain/models/expense_transaction.dart`: Final user-facing expense model.
- `app/lib/src/domain/models/classification_result.dart`: Rule result model.
- `app/lib/src/domain/parsing/payment_text_parser.dart`: Rule-based parser for Korean payment text.
- `app/lib/src/domain/classification/expense_classifier.dart`: Duplicate, transfer, and expense decision logic.
- `app/lib/src/domain/repositories/expense_repository.dart`: Repository interface used by UI/use cases.
- `app/lib/src/data/local/app_database.dart`: Drift database and tables.
- `app/lib/src/data/repositories/local_expense_repository.dart`: Local repository implementation.
- `app/lib/src/platform/android/android_event_bridge.dart`: Flutter bridge for Android raw events and permission status.
- `app/lib/src/features/home/home_screen.dart`: Home screen.
- `app/lib/src/features/history/history_screen.dart`: History screen.
- `app/lib/src/features/transaction_detail/transaction_detail_screen.dart`: Detail screen.
- `app/lib/src/features/settings/settings_screen.dart`: Permission/settings screen.
- `app/lib/src/features/shared/bottom_nav_scaffold.dart`: Bottom navigation shell.
- `app/android/app/src/main/kotlin/com/billlearn/app/MainActivity.kt`: Flutter channel setup.
- `app/android/app/src/main/kotlin/com/billlearn/app/BilllearnNotificationListenerService.kt`: Notification listener.
- `app/android/app/src/main/kotlin/com/billlearn/app/BilllearnSmsReceiver.kt`: SMS receiver.
- `app/android/app/src/main/AndroidManifest.xml`: Android permissions and services.
- `app/test/domain/parsing/payment_text_parser_test.dart`: Parser tests.
- `app/test/domain/classification/expense_classifier_test.dart`: Classification tests.
- `app/test/data/local_expense_repository_test.dart`: Repository tests.
- `app/test/features/home/home_screen_test.dart`: UI smoke test.

---

## Task 1: Create Flutter Project And Baseline Dependencies

**Files:**
- Create: `app/`
- Modify: `app/pubspec.yaml`
- Modify: `app/analysis_options.yaml`

- [ ] **Step 1: Create the Flutter project**

Run:

```powershell
flutter create --org com.billlearn --platforms android,ios app
```

Expected: `app/lib/main.dart`, `app/pubspec.yaml`, `app/android/`, and `app/ios/` are created.

- [ ] **Step 2: Add dependencies**

Modify `app/pubspec.yaml` dependencies to include:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  collection: ^1.19.0
  drift: ^2.22.1
  drift_flutter: ^0.2.2
  flutter_riverpod: ^2.6.1
  go_router: ^14.6.2
  intl: ^0.19.0
  path_provider: ^2.1.5
  sqlite3_flutter_libs: ^0.5.26

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.13
  drift_dev: ^2.22.1
  flutter_lints: ^5.0.0
```

- [ ] **Step 3: Install packages**

Run:

```powershell
Set-Location app
flutter pub get
```

Expected: command exits successfully and `app/pubspec.lock` is created.

- [ ] **Step 4: Tighten lint settings**

Set `app/analysis_options.yaml` to:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_single_quotes: true
    require_trailing_commas: true
    sort_child_properties_last: true
```

- [ ] **Step 5: Verify baseline app**

Run:

```powershell
Set-Location app
flutter test
```

Expected: baseline Flutter widget test passes.

- [ ] **Step 6: Commit**

Run:

```powershell
git add app
git commit -m "chore: create flutter app scaffold"
```

Expected: commit succeeds. If the workspace is not a git repository, first run `git init`, then repeat the commit commands.

---

## Task 2: Add App Shell, Routing, Theme, And Navigation

**Files:**
- Modify: `app/lib/main.dart`
- Create: `app/lib/src/app/billlearn_app.dart`
- Create: `app/lib/src/app/app_router.dart`
- Create: `app/lib/src/app/app_theme.dart`
- Create: `app/lib/src/features/shared/bottom_nav_scaffold.dart`
- Create: `app/lib/src/features/home/home_screen.dart`
- Create: `app/lib/src/features/history/history_screen.dart`
- Create: `app/lib/src/features/transaction_detail/transaction_detail_screen.dart`
- Create: `app/lib/src/features/settings/settings_screen.dart`
- Test: `app/test/features/home/home_screen_test.dart`

- [ ] **Step 1: Replace the generated widget test with a home smoke test**

Create `app/test/features/home/home_screen_test.dart`:

```dart
import 'package:billlearn/src/app/billlearn_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows BillLearn home shell', (tester) async {
    await tester.pumpWidget(const BillLearnApp());

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('이번 달 실제 지출'), findsOneWidget);
    expect(find.text('최근 내역'), findsOneWidget);
  });
}
```

Delete the generated `app/test/widget_test.dart` after this test exists.

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
Set-Location app
flutter test test/features/home/home_screen_test.dart
```

Expected: FAIL because `BillLearnApp` does not exist.

- [ ] **Step 3: Create brand theme**

Create `app/lib/src/app/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class BillLearnColors {
  static const mainPurple = Color(0xFF6C4EFF);
  static const lightPurple = Color(0xFFEDE9FF);
  static const softGray = Color(0xFFF6F7FB);
  static const ink = Color(0xFF171335);
}

ThemeData buildBillLearnTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: BillLearnColors.mainPurple,
    brightness: Brightness.light,
    primary: BillLearnColors.mainPurple,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: BillLearnColors.softGray,
    fontFamily: 'Pretendard',
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.white,
      foregroundColor: BillLearnColors.ink,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
```

- [ ] **Step 4: Create screens**

Create `app/lib/src/features/home/home_screen.dart`:

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text(
          '이번 달 실제 지출',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Text(
          '0원',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 24),
        Text(
          '확인 필요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text('아직 확인할 거래가 없어요'),
            subtitle: Text('결제 알림과 문자를 수집하면 여기에 표시됩니다.'),
          ),
        ),
        SizedBox(height: 24),
        Text(
          '최근 내역',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text('정리된 지출이 없습니다'),
            subtitle: Text('실제 지출로 확정된 거래만 표시됩니다.'),
          ),
        ),
      ],
    );
  }
}
```

Create `app/lib/src/features/history/history_screen.dart`:

```dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('내역'));
  }
}
```

Create `app/lib/src/features/transaction_detail/transaction_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상세')),
      body: Center(child: Text('거래 ID: $transactionId')),
    );
  }
}
```

Create `app/lib/src/features/settings/settings_screen.dart`:

```dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('설정'));
  }
}
```

- [ ] **Step 5: Create bottom navigation shell and router**

Create `app/lib/src/features/shared/bottom_nav_scaffold.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavScaffold extends StatelessWidget {
  const BottomNavScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titleForIndex(navigationShell.currentIndex))),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: '내역'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: '설정'),
        ],
      ),
    );
  }

  String _titleForIndex(int index) {
    return switch (index) {
      0 => '홈',
      1 => '내역',
      2 => '설정',
      _ => 'BillLearn',
    };
  }
}
```

Create `app/lib/src/app/app_router.dart`:

```dart
import 'package:billlearn/src/features/history/history_screen.dart';
import 'package:billlearn/src/features/home/home_screen.dart';
import 'package:billlearn/src/features/settings/settings_screen.dart';
import 'package:billlearn/src/features/shared/bottom_nav_scaffold.dart';
import 'package:billlearn/src/features/transaction_detail/transaction_detail_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/transactions/:id',
      builder: (context, state) {
        return TransactionDetailScreen(
          transactionId: state.pathParameters['id']!,
        );
      },
    ),
  ],
);
```

- [ ] **Step 6: Wire app entry point**

Replace `app/lib/main.dart`:

```dart
import 'package:billlearn/src/app/billlearn_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: BillLearnApp()));
}
```

Create `app/lib/src/app/billlearn_app.dart`:

```dart
import 'package:billlearn/src/app/app_router.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:flutter/material.dart';

class BillLearnApp extends StatelessWidget {
  const BillLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BillLearn',
      theme: buildBillLearnTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

- [ ] **Step 7: Run test to verify it passes**

Run:

```powershell
Set-Location app
flutter test test/features/home/home_screen_test.dart
```

Expected: PASS.

- [ ] **Step 8: Commit**

Run:

```powershell
git add app/lib app/test
git commit -m "feat: add app shell and core navigation"
```

Expected: commit succeeds.

---

## Task 3: Add Domain Models

**Files:**
- Create: `app/lib/src/domain/models/raw_notification.dart`
- Create: `app/lib/src/domain/models/transaction_candidate.dart`
- Create: `app/lib/src/domain/models/expense_transaction.dart`
- Create: `app/lib/src/domain/models/classification_result.dart`
- Test: `app/test/domain/models/domain_model_test.dart`

- [ ] **Step 1: Write model tests**

Create `app/test/domain/models/domain_model_test.dart`:

```dart
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('raw notification computes stable source hash input fields', () {
    final raw = RawNotification(
      id: 'raw-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-1',
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    expect(raw.sourceType, RawNotificationSourceType.sms);
    expect(raw.body, contains('스타벅스'));
  });

  test('candidate remains separate from final expense', () {
    final candidate = TransactionCandidate(
      id: 'candidate-1',
      rawNotificationId: 'raw-1',
      amount: 12300,
      merchantName: '스타벅스',
      paymentMethodHint: '신한카드',
      occurredAt: DateTime(2026, 5, 14, 12, 30),
      sourceType: RawNotificationSourceType.sms,
      parseConfidence: 0.92,
      parseStatus: ParseStatus.parsed,
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    final expense = ExpenseTransaction(
      id: 'expense-1',
      amount: candidate.amount,
      merchantName: candidate.merchantName,
      categoryId: 'cafe',
      spentAt: candidate.occurredAt,
      confirmationStatus: ConfirmationStatus.confirmed,
      confirmedBy: ConfirmedBy.rule,
      candidateIds: const ['candidate-1'],
      createdAt: DateTime(2026, 5, 14, 12, 31),
      updatedAt: DateTime(2026, 5, 14, 12, 31),
      syncStatus: SyncStatus.localOnly,
    );

    expect(expense.candidateIds, contains(candidate.id));
    expect(expense.syncStatus, SyncStatus.localOnly);
  });

  test('classification result can require review', () {
    final result = ClassificationResult(
      id: 'classification-1',
      candidateIds: const ['candidate-1'],
      isDuplicate: false,
      isTransferLike: true,
      isExpense: false,
      requiresReview: true,
      reasonCodes: const ['transfer_like_keyword'],
      confidence: 0.7,
      createdAt: DateTime(2026, 5, 14, 12, 31),
      userFeedback: null,
    );

    expect(result.requiresReview, isTrue);
    expect(result.reasonCodes, contains('transfer_like_keyword'));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
Set-Location app
flutter test test/domain/models/domain_model_test.dart
```

Expected: FAIL because model classes do not exist.

- [ ] **Step 3: Create raw notification model**

Create `app/lib/src/domain/models/raw_notification.dart`:

```dart
enum RawNotificationSourceType { push, sms }

class RawNotification {
  const RawNotification({
    required this.id,
    required this.sourceType,
    required this.sourceApp,
    required this.sender,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.sourceHash,
    required this.createdAt,
  });

  final String id;
  final RawNotificationSourceType sourceType;
  final String? sourceApp;
  final String? sender;
  final String? title;
  final String body;
  final DateTime receivedAt;
  final String sourceHash;
  final DateTime createdAt;
}
```

- [ ] **Step 4: Create candidate model**

Create `app/lib/src/domain/models/transaction_candidate.dart`:

```dart
import 'package:billlearn/src/domain/models/raw_notification.dart';

enum ParseStatus { parsed, unsupported, failed }

class TransactionCandidate {
  const TransactionCandidate({
    required this.id,
    required this.rawNotificationId,
    required this.amount,
    required this.merchantName,
    required this.paymentMethodHint,
    required this.occurredAt,
    required this.sourceType,
    required this.parseConfidence,
    required this.parseStatus,
    required this.createdAt,
  });

  final String id;
  final String rawNotificationId;
  final int amount;
  final String merchantName;
  final String? paymentMethodHint;
  final DateTime occurredAt;
  final RawNotificationSourceType sourceType;
  final double parseConfidence;
  final ParseStatus parseStatus;
  final DateTime createdAt;
}
```

- [ ] **Step 5: Create expense model**

Create `app/lib/src/domain/models/expense_transaction.dart`:

```dart
enum ConfirmationStatus { confirmed, needsReview, rejected }

enum ConfirmedBy { rule, user, import }

enum SyncStatus { localOnly, pendingUpload, synced, conflict }

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.amount,
    required this.merchantName,
    required this.categoryId,
    required this.spentAt,
    required this.confirmationStatus,
    required this.confirmedBy,
    required this.candidateIds,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });

  final String id;
  final int amount;
  final String merchantName;
  final String? categoryId;
  final DateTime spentAt;
  final ConfirmationStatus confirmationStatus;
  final ConfirmedBy confirmedBy;
  final List<String> candidateIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
}
```

- [ ] **Step 6: Create classification model**

Create `app/lib/src/domain/models/classification_result.dart`:

```dart
class ClassificationResult {
  const ClassificationResult({
    required this.id,
    required this.candidateIds,
    required this.isDuplicate,
    required this.isTransferLike,
    required this.isExpense,
    required this.requiresReview,
    required this.reasonCodes,
    required this.confidence,
    required this.createdAt,
    required this.userFeedback,
  });

  final String id;
  final List<String> candidateIds;
  final bool isDuplicate;
  final bool isTransferLike;
  final bool isExpense;
  final bool requiresReview;
  final List<String> reasonCodes;
  final double confidence;
  final DateTime createdAt;
  final bool? userFeedback;
}
```

- [ ] **Step 7: Run tests**

Run:

```powershell
Set-Location app
flutter test test/domain/models/domain_model_test.dart
```

Expected: PASS.

- [ ] **Step 8: Commit**

Run:

```powershell
git add app/lib/src/domain/models app/test/domain/models
git commit -m "feat: add expense domain models"
```

Expected: commit succeeds.

---

## Task 4: Add Payment Text Parser

**Files:**
- Create: `app/lib/src/domain/parsing/payment_text_parser.dart`
- Test: `app/test/domain/parsing/payment_text_parser_test.dart`

- [ ] **Step 1: Write parser tests**

Create `app/test/domain/parsing/payment_text_parser_test.dart`:

```dart
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/domain/parsing/payment_text_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = PaymentTextParser();

  test('parses Korean card approval SMS', () {
    final raw = RawNotification(
      id: 'raw-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 31),
      sourceHash: 'hash-1',
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    final candidate = parser.parse(raw);

    expect(candidate.parseStatus, ParseStatus.parsed);
    expect(candidate.amount, 12300);
    expect(candidate.merchantName, '스타벅스');
    expect(candidate.paymentMethodHint, '신한카드');
  });

  test('marks unsupported text without amount as unsupported', () {
    final raw = RawNotification(
      id: 'raw-2',
      sourceType: RawNotificationSourceType.push,
      sourceApp: 'com.example',
      sender: null,
      title: '공지',
      body: '이번 주 새로운 혜택을 확인하세요',
      receivedAt: DateTime(2026, 5, 14, 12, 31),
      sourceHash: 'hash-2',
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    final candidate = parser.parse(raw);

    expect(candidate.parseStatus, ParseStatus.unsupported);
    expect(candidate.amount, 0);
    expect(candidate.merchantName, '');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
Set-Location app
flutter test test/domain/parsing/payment_text_parser_test.dart
```

Expected: FAIL because `PaymentTextParser` does not exist.

- [ ] **Step 3: Implement parser**

Create `app/lib/src/domain/parsing/payment_text_parser.dart`:

```dart
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';

class PaymentTextParser {
  static final _amountPattern = RegExp(r'([\d,]+)\s*원');
  static final _paymentMethodPattern = RegExp(r'\[?([가-힣A-Za-z]+카드)');
  static final _merchantAfterAmountPattern = RegExp(r'[\d,]+\s*원\s+([가-힣A-Za-z0-9&._ -]+)');

  TransactionCandidate parse(RawNotification raw) {
    final amountMatch = _amountPattern.firstMatch(raw.body);
    if (amountMatch == null) {
      return _unsupported(raw);
    }

    final amountText = amountMatch.group(1)!.replaceAll(',', '');
    final amount = int.tryParse(amountText);
    if (amount == null) {
      return _unsupported(raw);
    }

    final merchant = _merchantAfterAmountPattern.firstMatch(raw.body)?.group(1)?.trim() ?? '';
    final method = _paymentMethodPattern.firstMatch(raw.body)?.group(1);

    return TransactionCandidate(
      id: 'candidate-${raw.id}',
      rawNotificationId: raw.id,
      amount: amount,
      merchantName: _cleanMerchantName(merchant),
      paymentMethodHint: method,
      occurredAt: raw.receivedAt,
      sourceType: raw.sourceType,
      parseConfidence: merchant.isEmpty ? 0.65 : 0.9,
      parseStatus: ParseStatus.parsed,
      createdAt: DateTime.now(),
    );
  }

  TransactionCandidate _unsupported(RawNotification raw) {
    return TransactionCandidate(
      id: 'candidate-${raw.id}',
      rawNotificationId: raw.id,
      amount: 0,
      merchantName: '',
      paymentMethodHint: null,
      occurredAt: raw.receivedAt,
      sourceType: raw.sourceType,
      parseConfidence: 0,
      parseStatus: ParseStatus.unsupported,
      createdAt: DateTime.now(),
    );
  }

  String _cleanMerchantName(String value) {
    return value
        .replaceAll(RegExp(r'\s+\d{1,2}/\d{1,2}.*$'), '')
        .replaceAll(RegExp(r'\s+\d{1,2}:\d{2}.*$'), '')
        .trim();
  }
}
```

- [ ] **Step 4: Run parser tests**

Run:

```powershell
Set-Location app
flutter test test/domain/parsing/payment_text_parser_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

Run:

```powershell
git add app/lib/src/domain/parsing app/test/domain/parsing
git commit -m "feat: parse payment notification text"
```

Expected: commit succeeds.

---

## Task 5: Add Expense Classifier

**Files:**
- Create: `app/lib/src/domain/classification/expense_classifier.dart`
- Test: `app/test/domain/classification/expense_classifier_test.dart`

- [ ] **Step 1: Write classifier tests**

Create `app/test/domain/classification/expense_classifier_test.dart`:

```dart
import 'package:billlearn/src/domain/classification/expense_classifier.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final classifier = ExpenseClassifier();

  TransactionCandidate candidate({
    required String id,
    required int amount,
    required String merchantName,
    required DateTime occurredAt,
  }) {
    return TransactionCandidate(
      id: id,
      rawNotificationId: 'raw-$id',
      amount: amount,
      merchantName: merchantName,
      paymentMethodHint: '신한카드',
      occurredAt: occurredAt,
      sourceType: RawNotificationSourceType.sms,
      parseConfidence: 0.9,
      parseStatus: ParseStatus.parsed,
      createdAt: occurredAt,
    );
  }

  test('classifies stable payment candidate as expense', () {
    final result = classifier.classify(
      candidates: [
        candidate(
          id: '1',
          amount: 12300,
          merchantName: '스타벅스',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
      ],
      rawTexts: const ['[승인] 12,300원 스타벅스'],
    );

    expect(result.isExpense, isTrue);
    expect(result.requiresReview, isFalse);
  });

  test('detects duplicate candidates', () {
    final result = classifier.classify(
      candidates: [
        candidate(
          id: '1',
          amount: 12300,
          merchantName: '스타벅스',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
        candidate(
          id: '2',
          amount: 12300,
          merchantName: '스타벅스',
          occurredAt: DateTime(2026, 5, 14, 12, 31),
        ),
      ],
      rawTexts: const ['[승인] 12,300원 스타벅스', '[체크카드] 12,300원 스타벅스'],
    );

    expect(result.isDuplicate, isTrue);
    expect(result.isExpense, isTrue);
  });

  test('marks transfer-like text as review required', () {
    final result = classifier.classify(
      candidates: [
        candidate(
          id: '1',
          amount: 50000,
          merchantName: '내 계좌',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
      ],
      rawTexts: const ['내 계좌로 50,000원 이체 완료'],
    );

    expect(result.isTransferLike, isTrue);
    expect(result.requiresReview, isTrue);
    expect(result.isExpense, isFalse);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
Set-Location app
flutter test test/domain/classification/expense_classifier_test.dart
```

Expected: FAIL because `ExpenseClassifier` does not exist.

- [ ] **Step 3: Implement classifier**

Create `app/lib/src/domain/classification/expense_classifier.dart`:

```dart
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';

class ExpenseClassifier {
  static const _transferKeywords = [
    '이체',
    '입금',
    '출금',
    '송금',
    '충전',
    '자동이체',
    '계좌간',
    '내 계좌',
  ];

  ClassificationResult classify({
    required List<TransactionCandidate> candidates,
    required List<String> rawTexts,
  }) {
    final joinedText = rawTexts.join(' ');
    final isTransferLike = _transferKeywords.any(joinedText.contains);
    final isDuplicate = _hasDuplicateSignal(candidates);
    final hasStableCandidate = candidates.any(
      (candidate) =>
          candidate.parseStatus == ParseStatus.parsed &&
          candidate.amount > 0 &&
          candidate.merchantName.isNotEmpty,
    );
    final isExpense = hasStableCandidate && !isTransferLike;
    final requiresReview = isTransferLike || !hasStableCandidate;

    return ClassificationResult(
      id: 'classification-${candidates.map((candidate) => candidate.id).join('-')}',
      candidateIds: candidates.map((candidate) => candidate.id).toList(),
      isDuplicate: isDuplicate,
      isTransferLike: isTransferLike,
      isExpense: isExpense,
      requiresReview: requiresReview,
      reasonCodes: [
        if (isDuplicate) 'duplicate_candidate_group',
        if (isTransferLike) 'transfer_like_keyword',
        if (isExpense) 'stable_payment_signal',
        if (!hasStableCandidate) 'weak_parse_signal',
      ],
      confidence: isExpense ? 0.9 : 0.7,
      createdAt: DateTime.now(),
      userFeedback: null,
    );
  }

  bool _hasDuplicateSignal(List<TransactionCandidate> candidates) {
    if (candidates.length < 2) {
      return false;
    }

    for (var i = 0; i < candidates.length; i += 1) {
      for (var j = i + 1; j < candidates.length; j += 1) {
        final left = candidates[i];
        final right = candidates[j];
        final sameAmount = left.amount == right.amount;
        final sameMerchant = left.merchantName == right.merchantName;
        final closeTime = left.occurredAt.difference(right.occurredAt).abs().inMinutes <= 5;
        if (sameAmount && sameMerchant && closeTime) {
          return true;
        }
      }
    }

    return false;
  }
}
```

- [ ] **Step 4: Run classifier tests**

Run:

```powershell
Set-Location app
flutter test test/domain/classification/expense_classifier_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

Run:

```powershell
git add app/lib/src/domain/classification app/test/domain/classification
git commit -m "feat: classify expense candidates"
```

Expected: commit succeeds.

---

## Task 6: Add Repository Interface And In-Memory First Implementation

**Files:**
- Create: `app/lib/src/domain/repositories/expense_repository.dart`
- Create: `app/lib/src/data/repositories/in_memory_expense_repository.dart`
- Test: `app/test/data/in_memory_expense_repository_test.dart`

- [ ] **Step 1: Write repository tests**

Create `app/test/data/in_memory_expense_repository_test.dart`:

```dart
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stores raw notifications separately from expenses', () async {
    final repository = InMemoryExpenseRepository();
    final raw = RawNotification(
      id: 'raw-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[승인] 12,300원 스타벅스',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-1',
      createdAt: DateTime(2026, 5, 14, 12, 30),
    );
    final expense = ExpenseTransaction(
      id: 'expense-1',
      amount: 12300,
      merchantName: '스타벅스',
      categoryId: 'cafe',
      spentAt: DateTime(2026, 5, 14, 12, 30),
      confirmationStatus: ConfirmationStatus.confirmed,
      confirmedBy: ConfirmedBy.rule,
      candidateIds: const ['candidate-1'],
      createdAt: DateTime(2026, 5, 14, 12, 31),
      updatedAt: DateTime(2026, 5, 14, 12, 31),
      syncStatus: SyncStatus.localOnly,
    );

    await repository.saveRawNotification(raw);
    await repository.saveExpense(expense);

    expect(await repository.watchRawNotifications().first, [raw]);
    expect(await repository.watchExpenses().first, [expense]);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
Set-Location app
flutter test test/data/in_memory_expense_repository_test.dart
```

Expected: FAIL because repository files do not exist.

- [ ] **Step 3: Create repository interface**

Create `app/lib/src/domain/repositories/expense_repository.dart`:

```dart
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';

abstract interface class ExpenseRepository {
  Stream<List<RawNotification>> watchRawNotifications();

  Stream<List<ExpenseTransaction>> watchExpenses();

  Future<void> saveRawNotification(RawNotification rawNotification);

  Future<void> saveExpense(ExpenseTransaction expense);
}
```

- [ ] **Step 4: Create in-memory implementation**

Create `app/lib/src/data/repositories/in_memory_expense_repository.dart`:

```dart
import 'dart:async';

import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';

class InMemoryExpenseRepository implements ExpenseRepository {
  final List<RawNotification> _rawNotifications = [];
  final List<ExpenseTransaction> _expenses = [];

  final _rawController = StreamController<List<RawNotification>>.broadcast();
  final _expenseController = StreamController<List<ExpenseTransaction>>.broadcast();

  @override
  Stream<List<RawNotification>> watchRawNotifications() async* {
    yield List.unmodifiable(_rawNotifications);
    yield* _rawController.stream;
  }

  @override
  Stream<List<ExpenseTransaction>> watchExpenses() async* {
    yield List.unmodifiable(_expenses);
    yield* _expenseController.stream;
  }

  @override
  Future<void> saveRawNotification(RawNotification rawNotification) async {
    _rawNotifications.add(rawNotification);
    _rawController.add(List.unmodifiable(_rawNotifications));
  }

  @override
  Future<void> saveExpense(ExpenseTransaction expense) async {
    _expenses.add(expense);
    _expenseController.add(List.unmodifiable(_expenses));
  }

  Future<void> dispose() async {
    await _rawController.close();
    await _expenseController.close();
  }
}
```

- [ ] **Step 5: Run repository test**

Run:

```powershell
Set-Location app
flutter test test/data/in_memory_expense_repository_test.dart
```

Expected: PASS.

- [ ] **Step 6: Commit**

Run:

```powershell
git add app/lib/src/domain/repositories app/lib/src/data/repositories app/test/data
git commit -m "feat: add expense repository contract"
```

Expected: commit succeeds.

---

## Task 7: Add Android Event Bridge Contract

**Files:**
- Create: `app/lib/src/platform/android/android_event_bridge.dart`
- Modify: `app/android/app/src/main/kotlin/com/billlearn/app/MainActivity.kt`
- Test: `app/test/platform/android_event_bridge_test.dart`

- [ ] **Step 1: Write bridge parsing test**

Create `app/test/platform/android_event_bridge_test.dart`:

```dart
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/platform/android/android_event_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps Android event payload into raw notification', () {
    final raw = AndroidEventBridge.rawNotificationFromPayload({
      'id': 'raw-1',
      'sourceType': 'sms',
      'sourceApp': null,
      'sender': '1588-0000',
      'title': null,
      'body': '[승인] 12,300원 스타벅스',
      'receivedAtMillis': DateTime(2026, 5, 14, 12, 30).millisecondsSinceEpoch,
      'sourceHash': 'hash-1',
    });

    expect(raw.sourceType, RawNotificationSourceType.sms);
    expect(raw.body, contains('스타벅스'));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
Set-Location app
flutter test test/platform/android_event_bridge_test.dart
```

Expected: FAIL because `AndroidEventBridge` does not exist.

- [ ] **Step 3: Create Flutter bridge contract**

Create `app/lib/src/platform/android/android_event_bridge.dart`:

```dart
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:flutter/services.dart';

class AndroidEventBridge {
  static const methodChannel = MethodChannel('billlearn.android/methods');
  static const eventChannel = EventChannel('billlearn.android/raw_events');

  Stream<RawNotification> watchRawNotifications() {
    return eventChannel.receiveBroadcastStream().map((event) {
      return rawNotificationFromPayload(Map<String, Object?>.from(event as Map));
    });
  }

  Future<bool> isNotificationAccessEnabled() async {
    return await methodChannel.invokeMethod<bool>('isNotificationAccessEnabled') ?? false;
  }

  Future<void> openNotificationAccessSettings() async {
    await methodChannel.invokeMethod<void>('openNotificationAccessSettings');
  }

  static RawNotification rawNotificationFromPayload(Map<String, Object?> payload) {
    final sourceTypeText = payload['sourceType'] as String;
    return RawNotification(
      id: payload['id'] as String,
      sourceType: sourceTypeText == 'sms'
          ? RawNotificationSourceType.sms
          : RawNotificationSourceType.push,
      sourceApp: payload['sourceApp'] as String?,
      sender: payload['sender'] as String?,
      title: payload['title'] as String?,
      body: payload['body'] as String,
      receivedAt: DateTime.fromMillisecondsSinceEpoch(
        payload['receivedAtMillis'] as int,
      ),
      sourceHash: payload['sourceHash'] as String,
      createdAt: DateTime.now(),
    );
  }
}
```

- [ ] **Step 4: Wire Android method and event channel**

Replace `app/android/app/src/main/kotlin/com/billlearn/app/MainActivity.kt`:

```kotlin
package com.billlearn.app

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "billlearn.android/methods"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isNotificationAccessEnabled" -> result.success(isNotificationAccessEnabled())
                "openNotificationAccessSettings" -> {
                    startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "billlearn.android/raw_events"
        ).setStreamHandler(AndroidRawEventStream)
    }

    private fun isNotificationAccessEnabled(): Boolean {
        val enabledListeners = Settings.Secure.getString(
            contentResolver,
            "enabled_notification_listeners"
        ) ?: return false

        return enabledListeners.contains(packageName)
    }
}
```

- [ ] **Step 5: Create Android stream holder**

Create `app/android/app/src/main/kotlin/com/billlearn/app/AndroidRawEventStream.kt`:

```kotlin
package com.billlearn.app

import io.flutter.plugin.common.EventChannel

object AndroidRawEventStream : EventChannel.StreamHandler {
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    fun emit(payload: Map<String, Any?>) {
        sink?.success(payload)
    }
}
```

- [ ] **Step 6: Run bridge test**

Run:

```powershell
Set-Location app
flutter test test/platform/android_event_bridge_test.dart
```

Expected: PASS.

- [ ] **Step 7: Commit**

Run:

```powershell
git add app/lib/src/platform app/test/platform app/android/app/src/main/kotlin
git commit -m "feat: add android raw event bridge"
```

Expected: commit succeeds.

---

## Task 8: Add Android Notification And SMS Collectors

**Files:**
- Create: `app/android/app/src/main/kotlin/com/billlearn/app/BilllearnNotificationListenerService.kt`
- Create: `app/android/app/src/main/kotlin/com/billlearn/app/BilllearnSmsReceiver.kt`
- Modify: `app/android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Add notification listener service**

Create `app/android/app/src/main/kotlin/com/billlearn/app/BilllearnNotificationListenerService.kt`:

```kotlin
package com.billlearn.app

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import java.security.MessageDigest

class BilllearnNotificationListenerService : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val extras = sbn.notification.extras
        val title = extras.getCharSequence("android.title")?.toString()
        val text = extras.getCharSequence("android.text")?.toString() ?: return
        val body = listOfNotNull(title, text).joinToString(" ")

        AndroidRawEventStream.emit(
            mapOf(
                "id" to "push-${sbn.postTime}-${sbn.packageName}",
                "sourceType" to "push",
                "sourceApp" to sbn.packageName,
                "sender" to null,
                "title" to title,
                "body" to body,
                "receivedAtMillis" to sbn.postTime,
                "sourceHash" to sha256("${sbn.packageName}|$body|${sbn.postTime}")
            )
        )
    }

    private fun sha256(value: String): String {
        val digest = MessageDigest.getInstance("SHA-256").digest(value.toByteArray())
        return digest.joinToString("") { "%02x".format(it) }
    }
}
```

- [ ] **Step 2: Add SMS receiver**

Create `app/android/app/src/main/kotlin/com/billlearn/app/BilllearnSmsReceiver.kt`:

```kotlin
package com.billlearn.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import java.security.MessageDigest

class BilllearnSmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            return
        }

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        for (message in messages) {
            val body = message.messageBody ?: continue
            val timestamp = message.timestampMillis
            val sender = message.originatingAddress

            AndroidRawEventStream.emit(
                mapOf(
                    "id" to "sms-$timestamp-$sender",
                    "sourceType" to "sms",
                    "sourceApp" to null,
                    "sender" to sender,
                    "title" to null,
                    "body" to body,
                    "receivedAtMillis" to timestamp,
                    "sourceHash" to sha256("$sender|$body|$timestamp")
                )
            )
        }
    }

    private fun sha256(value: String): String {
        val digest = MessageDigest.getInstance("SHA-256").digest(value.toByteArray())
        return digest.joinToString("") { "%02x".format(it) }
    }
}
```

- [ ] **Step 3: Add Android manifest permissions and components**

Modify `app/android/app/src/main/AndroidManifest.xml` so the manifest includes:

```xml
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_SMS" />
```

Inside `<application>`, add:

```xml
<service
    android:name=".BilllearnNotificationListenerService"
    android:exported="false"
    android:label="BillLearn"
    android:permission="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE">
    <intent-filter>
        <action android:name="android.service.notification.NotificationListenerService" />
    </intent-filter>
</service>

<receiver
    android:name=".BilllearnSmsReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.provider.Telephony.SMS_RECEIVED" />
    </intent-filter>
</receiver>
```

- [ ] **Step 4: Run Android build**

Run:

```powershell
Set-Location app
flutter build apk --debug
```

Expected: debug APK builds successfully.

- [ ] **Step 5: Commit**

Run:

```powershell
git add app/android/app/src/main
git commit -m "feat: collect android notification and sms events"
```

Expected: commit succeeds.

---

## Task 9: Connect Raw Event Pipeline To Repository

**Files:**
- Create: `app/lib/src/domain/use_cases/process_raw_notification.dart`
- Modify: `app/lib/src/app/billlearn_app.dart`
- Modify: `app/lib/src/features/home/home_screen.dart`
- Test: `app/test/domain/use_cases/process_raw_notification_test.dart`

- [ ] **Step 1: Write use case test**

Create `app/test/domain/use_cases/process_raw_notification_test.dart`:

```dart
import 'package:billlearn/src/data/repositories/in_memory_expense_repository.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/use_cases/process_raw_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('processes stable payment into confirmed expense', () async {
    final repository = InMemoryExpenseRepository();
    final useCase = ProcessRawNotification(repository: repository);
    final raw = RawNotification(
      id: 'raw-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 31),
      sourceHash: 'hash-1',
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    await useCase(raw);

    final expenses = await repository.watchExpenses().first;
    expect(expenses, hasLength(1));
    expect(expenses.single.merchantName, '스타벅스');
    expect(expenses.single.confirmationStatus, ConfirmationStatus.confirmed);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:

```powershell
Set-Location app
flutter test test/domain/use_cases/process_raw_notification_test.dart
```

Expected: FAIL because `ProcessRawNotification` does not exist.

- [ ] **Step 3: Implement use case**

Create `app/lib/src/domain/use_cases/process_raw_notification.dart`:

```dart
import 'package:billlearn/src/domain/classification/expense_classifier.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/parsing/payment_text_parser.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';

class ProcessRawNotification {
  ProcessRawNotification({
    required this.repository,
    PaymentTextParser? parser,
    ExpenseClassifier? classifier,
  })  : _parser = parser ?? PaymentTextParser(),
        _classifier = classifier ?? ExpenseClassifier();

  final ExpenseRepository repository;
  final PaymentTextParser _parser;
  final ExpenseClassifier _classifier;

  Future<void> call(RawNotification raw) async {
    await repository.saveRawNotification(raw);

    final candidate = _parser.parse(raw);
    final classification = _classifier.classify(
      candidates: [candidate],
      rawTexts: [raw.body],
    );

    if (!classification.isExpense) {
      return;
    }

    final now = DateTime.now();
    await repository.saveExpense(
      ExpenseTransaction(
        id: 'expense-${candidate.id}',
        amount: candidate.amount,
        merchantName: candidate.merchantName,
        categoryId: null,
        spentAt: candidate.occurredAt,
        confirmationStatus: classification.requiresReview
            ? ConfirmationStatus.needsReview
            : ConfirmationStatus.confirmed,
        confirmedBy: ConfirmedBy.rule,
        candidateIds: [candidate.id],
        createdAt: now,
        updatedAt: now,
        syncStatus: SyncStatus.localOnly,
      ),
    );
  }
}
```

- [ ] **Step 4: Run use case test**

Run:

```powershell
Set-Location app
flutter test test/domain/use_cases/process_raw_notification_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

Run:

```powershell
git add app/lib/src/domain/use_cases app/test/domain/use_cases
git commit -m "feat: process raw events into expenses"
```

Expected: commit succeeds.

---

## Task 10: Final Verification

**Files:**
- Modify: files changed by previous tasks only when verification finds concrete issues.

- [ ] **Step 1: Format Dart code**

Run:

```powershell
Set-Location app
dart format lib test
```

Expected: formatter completes successfully.

- [ ] **Step 2: Analyze Flutter code**

Run:

```powershell
Set-Location app
flutter analyze
```

Expected: no errors.

- [ ] **Step 3: Run all tests**

Run:

```powershell
Set-Location app
flutter test
```

Expected: all tests pass.

- [ ] **Step 4: Build Android debug APK**

Run:

```powershell
Set-Location app
flutter build apk --debug
```

Expected: debug APK builds successfully.

- [ ] **Step 5: Commit verification fixes**

Run:

```powershell
git status --short
git add app
git commit -m "chore: verify billlearn mvp scaffold"
```

Expected: commit succeeds when formatting or verification changed files. If `git status --short` is empty, do not create an empty commit.

---

## Self-Review

- Spec coverage: This plan covers Flutter shared UI, Android native collection, raw/candidate/classification/expense separation, local-first repository boundaries, parser tests, classifier tests, and Android build verification.
- Deferred by design: cloud sync, MyData integration, advanced AI insights, budget management, and full iOS automatic collection remain outside the MVP.
- Type consistency: Domain model names and fields match across parser, classifier, repository, bridge, and use case tasks.
- Red-flag scan: The plan contains concrete file paths, commands, expected results, and code blocks for implementation steps.
