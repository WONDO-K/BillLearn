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

  test('marks bank app person-to-person transfer phrases as non-expense', () {
    final result = classifier.classify(
      candidates: [
        candidate(
          id: '1',
          amount: 50000,
          merchantName: '홍길동님에게',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
      ],
      rawTexts: const ['토스뱅크 홍길동님에게 50,000원 보냈어요'],
    );

    expect(result.isTransferLike, isTrue);
    expect(result.requiresReview, isTrue);
    expect(result.isExpense, isFalse);
    expect(result.reasonCodes, contains('bank_transfer_phrase'));
  });

  test('marks incoming bank transfer phrases as non-expense', () {
    final result = classifier.classify(
      candidates: [
        candidate(
          id: '1',
          amount: 1000000,
          merchantName: '급여',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
      ],
      rawTexts: const ['카카오뱅크 급여 1,000,000원 받았어요 보낸분 주식회사빌런'],
    );

    expect(result.isTransferLike, isTrue);
    expect(result.requiresReview, isTrue);
    expect(result.isExpense, isFalse);
    expect(result.reasonCodes, contains('bank_transfer_phrase'));
  });

  test('excludes wallet and local currency top-up as non-spending', () {
    final result = classifier.classify(
      candidates: [
        candidate(
          id: '1',
          amount: 5000,
          merchantName: '동백전 충전',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
      ],
      rawTexts: const ['동백전 충전 5,000원'],
    );

    expect(result.isTransferLike, isTrue);
    expect(result.isExpense, isFalse);
    expect(result.reasonCodes, contains('stored_value_top_up'));
  });

  test('keeps charging station payment as real spending', () {
    final result = classifier.classify(
      candidates: [
        candidate(
          id: '1',
          amount: 12000,
          merchantName: '전기차충전소',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
      ],
      rawTexts: const ['[승인] 12,000원 전기차충전소'],
    );

    expect(result.isTransferLike, isFalse);
    expect(result.isExpense, isTrue);
  });
}
