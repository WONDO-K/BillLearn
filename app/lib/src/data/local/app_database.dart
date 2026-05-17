import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('RawNotificationRow')
class RawNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get sourceType => text()();
  TextColumn get sourceApp => text().nullable()();
  TextColumn get sender => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text()();
  DateTimeColumn get receivedAt => dateTime()();
  TextColumn get sourceHash => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ExpenseTransactionRow')
class ExpenseTransactions extends Table {
  TextColumn get id => text()();
  IntColumn get amount => integer()();
  TextColumn get merchantName => text()();
  TextColumn get categoryId => text().nullable()();
  DateTimeColumn get spentAt => dateTime()();
  TextColumn get confirmationStatus => text()();
  TextColumn get confirmedBy => text()();
  TextColumn get candidateIdsJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TransactionCandidateRow')
class TransactionCandidates extends Table {
  TextColumn get id => text()();
  TextColumn get rawNotificationId => text()();
  IntColumn get amount => integer()();
  TextColumn get merchantName => text()();
  TextColumn get paymentMethodHint => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get sourceType => text()();
  RealColumn get parseConfidence => real()();
  TextColumn get parseStatus => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ClassificationResultRow')
class ClassificationResults extends Table {
  TextColumn get id => text()();
  TextColumn get candidateIdsJson => text()();
  BoolColumn get isDuplicate => boolean()();
  BoolColumn get isTransferLike => boolean()();
  BoolColumn get isExpense => boolean()();
  BoolColumn get requiresReview => boolean()();
  TextColumn get reasonCodesJson => text()();
  RealColumn get confidence => real()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get userFeedback => boolean().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    RawNotifications,
    ExpenseTransactions,
    TransactionCandidates,
    ClassificationResults,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.memory() : super(NativeDatabase.memory());

  AppDatabase.open() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<RawNotificationRow>> watchRawNotificationRows() {
    return select(rawNotifications).watch();
  }

  Future<RawNotificationRow?> getRawNotificationRowBySourceHash(
    String sourceHash,
  ) {
    return (select(
      rawNotifications,
    )..where((row) => row.sourceHash.equals(sourceHash))).getSingleOrNull();
  }

  Stream<List<ExpenseTransactionRow>> watchExpenseTransactionRows() {
    return select(expenseTransactions).watch();
  }

  Future<List<ExpenseTransactionRow>> getExpenseTransactionRows() {
    return select(expenseTransactions).get();
  }

  Future<ExpenseTransactionRow?> getExpenseTransactionRowById(String id) {
    return (select(
      expenseTransactions,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<TransactionCandidateRow>> getTransactionCandidateRowsForRaw(
    String rawNotificationId,
  ) {
    return (select(
      transactionCandidates,
    )..where((row) => row.rawNotificationId.equals(rawNotificationId))).get();
  }

  Future<ClassificationResultRow?> getClassificationResultRowByCandidateId(
    String candidateId,
  ) {
    return (select(classificationResults)
          ..where((row) => row.candidateIdsJson.contains(candidateId)))
        .getSingleOrNull();
  }

  Future<void> saveRawNotificationRow(
    RawNotificationsCompanion rawNotification,
  ) {
    return into(rawNotifications).insertOnConflictUpdate(rawNotification);
  }

  Future<void> saveExpenseTransactionRow(
    ExpenseTransactionsCompanion expenseTransaction,
  ) {
    return into(expenseTransactions).insertOnConflictUpdate(expenseTransaction);
  }

  Future<void> saveTransactionCandidateRow(
    TransactionCandidatesCompanion transactionCandidate,
  ) {
    return into(
      transactionCandidates,
    ).insertOnConflictUpdate(transactionCandidate);
  }

  Future<void> saveClassificationResultRow(
    ClassificationResultsCompanion classificationResult,
  ) {
    return into(
      classificationResults,
    ).insertOnConflictUpdate(classificationResult);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}billlearn.sqlite',
    );
    return NativeDatabase.createInBackground(file);
  });
}
