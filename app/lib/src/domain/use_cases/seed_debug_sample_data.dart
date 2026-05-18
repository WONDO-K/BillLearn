import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/domain/repositories/expense_repository.dart';

class SeedDebugSampleData {
  const SeedDebugSampleData({required ExpenseRepository repository})
    : _repository = repository;

  final ExpenseRepository _repository;

  Future<void> call() async {
    final samples = _debugSamples();

    for (final sample in samples) {
      final existingRaw = await _repository.getRawNotificationBySourceHash(
        sample.raw.sourceHash,
      );
      if (existingRaw == null) {
        await _repository.saveRawNotification(sample.raw);
      }

      await _repository.saveTransactionCandidate(sample.candidate);
      await _repository.saveClassificationResult(sample.classification);
      await _repository.updateExpense(sample.expense);
    }
  }

  List<_DebugSample> _debugSamples() {
    final base = DateTime(2026, 5, 18, 12);

    return [
      _sample(
        id: 'baemin',
        body: '[배달의민족] 결제완료\n배달의민족\n23,400원',
        amount: 23400,
        merchantName: '배달의민족',
        paymentMethodHint: '배달/음식',
        spentAt: base.subtract(const Duration(minutes: 20)),
        categoryId: 'food',
        status: ConfirmationStatus.confirmed,
        confirmedBy: ConfirmedBy.rule,
        classification: _ClassificationSeed(
          isExpense: true,
          isDuplicate: false,
          isTransferLike: false,
          requiresReview: false,
          reasonCodes: const ['debug_sample', 'stable_payment_signal'],
          confidence: 0.94,
        ),
      ),
      _sample(
        id: 'dongbaek-topup',
        body: '[동백전] 충전완료 5,000원',
        amount: 5000,
        merchantName: '동백전 충전',
        paymentMethodHint: '지역화폐',
        spentAt: base.subtract(const Duration(minutes: 12)),
        categoryId: null,
        status: ConfirmationStatus.needsReview,
        confirmedBy: ConfirmedBy.rule,
        classification: _ClassificationSeed(
          isExpense: false,
          isDuplicate: false,
          isTransferLike: true,
          requiresReview: true,
          reasonCodes: const ['debug_sample', 'stored_value_top_up'],
          confidence: 0.82,
        ),
      ),
      _sample(
        id: 'starbucks',
        body: '[신한카드 승인] 5,600원/스타벅스',
        amount: 5600,
        merchantName: '스타벅스',
        paymentMethodHint: '신한카드',
        spentAt: base.subtract(const Duration(minutes: 5)),
        categoryId: 'cafe',
        status: ConfirmationStatus.confirmed,
        confirmedBy: ConfirmedBy.rule,
        classification: _ClassificationSeed(
          isExpense: true,
          isDuplicate: false,
          isTransferLike: false,
          requiresReview: false,
          reasonCodes: const ['debug_sample', 'card_payment_signal'],
          confidence: 0.9,
        ),
      ),
    ];
  }

  _DebugSample _sample({
    required String id,
    required String body,
    required int amount,
    required String merchantName,
    required String paymentMethodHint,
    required DateTime spentAt,
    required String? categoryId,
    required ConfirmationStatus status,
    required ConfirmedBy confirmedBy,
    required _ClassificationSeed classification,
  }) {
    final rawId = 'debug-sample-raw-$id';
    final candidateId = 'debug-sample-candidate-$id';
    final classificationId = 'debug-sample-classification-$id';
    final expenseId = 'debug-sample-expense-$id';
    final createdAt = spentAt.add(const Duration(seconds: 10));

    return _DebugSample(
      raw: RawNotification(
        id: rawId,
        sourceType: RawNotificationSourceType.push,
        sourceApp: 'BillLearn Debug',
        sender: null,
        title: '샘플 결제 알림',
        body: body,
        receivedAt: spentAt,
        sourceHash: 'debug-sample-hash-$id',
        createdAt: createdAt,
      ),
      candidate: TransactionCandidate(
        id: candidateId,
        rawNotificationId: rawId,
        amount: amount,
        merchantName: merchantName,
        paymentMethodHint: paymentMethodHint,
        occurredAt: spentAt,
        sourceType: RawNotificationSourceType.push,
        parseConfidence: 0.9,
        parseStatus: ParseStatus.parsed,
        createdAt: createdAt,
      ),
      classification: ClassificationResult(
        id: classificationId,
        candidateIds: [candidateId],
        isDuplicate: classification.isDuplicate,
        isTransferLike: classification.isTransferLike,
        isExpense: classification.isExpense,
        requiresReview: classification.requiresReview,
        reasonCodes: classification.reasonCodes,
        confidence: classification.confidence,
        createdAt: createdAt,
        userFeedback: null,
      ),
      expense: ExpenseTransaction(
        id: expenseId,
        amount: amount,
        merchantName: merchantName,
        categoryId: categoryId,
        spentAt: spentAt,
        confirmationStatus: status,
        confirmedBy: confirmedBy,
        candidateIds: [candidateId],
        createdAt: createdAt,
        updatedAt: createdAt,
        syncStatus: SyncStatus.localOnly,
      ),
    );
  }
}

class _DebugSample {
  const _DebugSample({
    required this.raw,
    required this.candidate,
    required this.classification,
    required this.expense,
  });

  final RawNotification raw;
  final TransactionCandidate candidate;
  final ClassificationResult classification;
  final ExpenseTransaction expense;
}

class _ClassificationSeed {
  const _ClassificationSeed({
    required this.isDuplicate,
    required this.isTransferLike,
    required this.isExpense,
    required this.requiresReview,
    required this.reasonCodes,
    required this.confidence,
  });

  final bool isDuplicate;
  final bool isTransferLike;
  final bool isExpense;
  final bool requiresReview;
  final List<String> reasonCodes;
  final double confidence;
}
