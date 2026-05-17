import 'dart:convert';
import 'dart:io';

import 'package:billlearn/src/domain/classification/expense_classifier.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final classifier = ExpenseClassifier();

  // 분류 정책 샘플은 test/fixtures/expense_classifier_cases.json에 추가합니다.
  // 샘플 파일이 분류 정책의 회귀 테스트 목록 역할을 합니다.
  final cases = _loadClassifierCases();

  for (final testCase in cases) {
    test('classifies fixture: ${testCase.name}', () {
      final result = classifier.classify(
        candidates: [testCase.candidate],
        rawTexts: testCase.rawTexts,
      );

      expect(result.isExpense, testCase.expectedIsExpense);
      expect(result.requiresReview, testCase.expectedRequiresReview);
      expect(result.isTransferLike, testCase.expectedIsTransferLike);
      for (final reasonCode in testCase.expectedReasonCodes) {
        expect(result.reasonCodes, contains(reasonCode));
      }
    });
  }

  test('detects duplicate candidates', () {
    final result = classifier.classify(
      candidates: [
        _candidate(
          id: '1',
          amount: 12300,
          merchantName: '스타벅스',
          occurredAt: DateTime(2026, 5, 14, 12, 30),
        ),
        _candidate(
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
}

List<_ClassifierFixtureCase> _loadClassifierCases() {
  final file = File('test/fixtures/expense_classifier_cases.json');
  final items = jsonDecode(file.readAsStringSync()) as List<dynamic>;
  return items
      .cast<Map<String, dynamic>>()
      .map(_ClassifierFixtureCase.fromJson)
      .toList(growable: false);
}

TransactionCandidate _candidate({
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

class _ClassifierFixtureCase {
  const _ClassifierFixtureCase({
    required this.name,
    required this.candidate,
    required this.rawTexts,
    required this.expectedIsExpense,
    required this.expectedRequiresReview,
    required this.expectedIsTransferLike,
    required this.expectedReasonCodes,
  });

  final String name;
  final TransactionCandidate candidate;
  final List<String> rawTexts;
  final bool expectedIsExpense;
  final bool expectedRequiresReview;
  final bool expectedIsTransferLike;
  final List<String> expectedReasonCodes;

  factory _ClassifierFixtureCase.fromJson(Map<String, dynamic> json) {
    return _ClassifierFixtureCase(
      name: json['name'] as String,
      candidate: _candidate(
        id: json['name'] as String,
        amount: json['amount'] as int,
        merchantName: json['merchantName'] as String,
        occurredAt: DateTime(2026, 5, 14, 12, 30),
      ),
      rawTexts: (json['rawTexts'] as List<dynamic>).cast<String>(),
      expectedIsExpense: json['expectedIsExpense'] as bool,
      expectedRequiresReview: json['expectedRequiresReview'] as bool,
      expectedIsTransferLike: json['expectedIsTransferLike'] as bool,
      expectedReasonCodes: (json['expectedReasonCodes'] as List<dynamic>)
          .cast<String>(),
    );
  }
}
