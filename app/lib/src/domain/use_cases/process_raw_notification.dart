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
  }) : _parser = parser ?? PaymentTextParser(),
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

    final existingExpenses = await repository.getExpenses();
    final hasDuplicate = existingExpenses.any((expense) {
      final sameAmount = expense.amount == candidate.amount;
      final sameMerchant = expense.merchantName == candidate.merchantName;
      final closeTime =
          expense.spentAt.difference(candidate.occurredAt).abs().inMinutes <= 5;
      return sameAmount && sameMerchant && closeTime;
    });
    if (hasDuplicate) {
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
