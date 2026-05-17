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
    final existingRaw = await repository.getRawNotificationBySourceHash(
      raw.sourceHash,
    );
    if (existingRaw != null) {
      return;
    }

    await repository.saveRawNotification(raw);

    final candidate = _parser.parse(raw);
    await repository.saveTransactionCandidate(candidate);

    final classification = _classifier.classify(
      candidates: [candidate],
      rawTexts: [raw.body],
    );
    await repository.saveClassificationResult(classification);

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
