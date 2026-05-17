import 'dart:convert';

import 'package:billlearn/src/data/local/app_database.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';
import 'package:drift/drift.dart';

class LocalExpenseRepository implements ExpenseRepository {
  const LocalExpenseRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<RawNotification>> watchRawNotifications() {
    return _database.watchRawNotificationRows().map(
      (rows) => rows.map(_rawNotificationFromRow).toList(growable: false),
    );
  }

  @override
  Stream<List<ExpenseTransaction>> watchExpenses() {
    return _database.watchExpenseTransactionRows().map(
      (rows) => rows.map(_expenseTransactionFromRow).toList(growable: false),
    );
  }

  @override
  Future<RawNotification?> getRawNotificationBySourceHash(
    String sourceHash,
  ) async {
    final row = await _database.getRawNotificationRowBySourceHash(sourceHash);
    if (row == null) {
      return null;
    }
    return _rawNotificationFromRow(row);
  }

  @override
  Future<List<ExpenseTransaction>> getExpenses() async {
    final rows = await _database.getExpenseTransactionRows();
    return rows.map(_expenseTransactionFromRow).toList(growable: false);
  }

  @override
  Future<ExpenseTransaction?> getExpenseById(String id) async {
    final row = await _database.getExpenseTransactionRowById(id);
    if (row == null) {
      return null;
    }
    return _expenseTransactionFromRow(row);
  }

  @override
  Future<List<TransactionCandidate>> getCandidatesForRawNotification(
    String rawNotificationId,
  ) async {
    final rows = await _database.getTransactionCandidateRowsForRaw(
      rawNotificationId,
    );
    return rows.map(_transactionCandidateFromRow).toList(growable: false);
  }

  @override
  Future<ClassificationResult?> getClassificationResultByCandidateId(
    String candidateId,
  ) async {
    final row = await _database.getClassificationResultRowByCandidateId(
      candidateId,
    );
    if (row == null) {
      return null;
    }
    return _classificationResultFromRow(row);
  }

  @override
  Future<void> saveRawNotification(RawNotification rawNotification) {
    return _database.saveRawNotificationRow(
      RawNotificationsCompanion.insert(
        id: rawNotification.id,
        sourceType: rawNotification.sourceType.name,
        sourceApp: Value(rawNotification.sourceApp),
        sender: Value(rawNotification.sender),
        title: Value(rawNotification.title),
        body: rawNotification.body,
        receivedAt: rawNotification.receivedAt,
        sourceHash: rawNotification.sourceHash,
        createdAt: rawNotification.createdAt,
      ),
    );
  }

  @override
  Future<void> saveTransactionCandidate(TransactionCandidate candidate) {
    return _database.saveTransactionCandidateRow(
      TransactionCandidatesCompanion.insert(
        id: candidate.id,
        rawNotificationId: candidate.rawNotificationId,
        amount: candidate.amount,
        merchantName: candidate.merchantName,
        paymentMethodHint: Value(candidate.paymentMethodHint),
        occurredAt: candidate.occurredAt,
        sourceType: candidate.sourceType.name,
        parseConfidence: candidate.parseConfidence,
        parseStatus: candidate.parseStatus.name,
        createdAt: candidate.createdAt,
      ),
    );
  }

  @override
  Future<void> saveClassificationResult(ClassificationResult classification) {
    return _database.saveClassificationResultRow(
      ClassificationResultsCompanion.insert(
        id: classification.id,
        candidateIdsJson: jsonEncode(classification.candidateIds),
        isDuplicate: classification.isDuplicate,
        isTransferLike: classification.isTransferLike,
        isExpense: classification.isExpense,
        requiresReview: classification.requiresReview,
        reasonCodesJson: jsonEncode(classification.reasonCodes),
        confidence: classification.confidence,
        createdAt: classification.createdAt,
        userFeedback: Value(classification.userFeedback),
      ),
    );
  }

  @override
  Future<void> saveExpense(ExpenseTransaction expense) {
    return _database.saveExpenseTransactionRow(
      _expenseTransactionCompanion(expense),
    );
  }

  @override
  Future<void> updateExpense(ExpenseTransaction expense) {
    return _database.saveExpenseTransactionRow(
      _expenseTransactionCompanion(expense),
    );
  }

  RawNotification _rawNotificationFromRow(RawNotificationRow row) {
    return RawNotification(
      id: row.id,
      sourceType: RawNotificationSourceType.values.byName(row.sourceType),
      sourceApp: row.sourceApp,
      sender: row.sender,
      title: row.title,
      body: row.body,
      receivedAt: row.receivedAt,
      sourceHash: row.sourceHash,
      createdAt: row.createdAt,
    );
  }

  ExpenseTransaction _expenseTransactionFromRow(ExpenseTransactionRow row) {
    return ExpenseTransaction(
      id: row.id,
      amount: row.amount,
      merchantName: row.merchantName,
      categoryId: row.categoryId,
      spentAt: row.spentAt,
      confirmationStatus: ConfirmationStatus.values.byName(
        row.confirmationStatus,
      ),
      confirmedBy: ConfirmedBy.values.byName(row.confirmedBy),
      candidateIds: (jsonDecode(row.candidateIdsJson) as List<dynamic>)
          .cast<String>(),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      syncStatus: SyncStatus.values.byName(row.syncStatus),
    );
  }

  TransactionCandidate _transactionCandidateFromRow(
    TransactionCandidateRow row,
  ) {
    return TransactionCandidate(
      id: row.id,
      rawNotificationId: row.rawNotificationId,
      amount: row.amount,
      merchantName: row.merchantName,
      paymentMethodHint: row.paymentMethodHint,
      occurredAt: row.occurredAt,
      sourceType: RawNotificationSourceType.values.byName(row.sourceType),
      parseConfidence: row.parseConfidence,
      parseStatus: ParseStatus.values.byName(row.parseStatus),
      createdAt: row.createdAt,
    );
  }

  ClassificationResult _classificationResultFromRow(
    ClassificationResultRow row,
  ) {
    return ClassificationResult(
      id: row.id,
      candidateIds: (jsonDecode(row.candidateIdsJson) as List<dynamic>)
          .cast<String>(),
      isDuplicate: row.isDuplicate,
      isTransferLike: row.isTransferLike,
      isExpense: row.isExpense,
      requiresReview: row.requiresReview,
      reasonCodes: (jsonDecode(row.reasonCodesJson) as List<dynamic>)
          .cast<String>(),
      confidence: row.confidence,
      createdAt: row.createdAt,
      userFeedback: row.userFeedback,
    );
  }

  ExpenseTransactionsCompanion _expenseTransactionCompanion(
    ExpenseTransaction expense,
  ) {
    return ExpenseTransactionsCompanion.insert(
      id: expense.id,
      amount: expense.amount,
      merchantName: expense.merchantName,
      categoryId: Value(expense.categoryId),
      spentAt: expense.spentAt,
      confirmationStatus: expense.confirmationStatus.name,
      confirmedBy: expense.confirmedBy.name,
      candidateIdsJson: jsonEncode(expense.candidateIds),
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
      syncStatus: expense.syncStatus.name,
    );
  }
}
