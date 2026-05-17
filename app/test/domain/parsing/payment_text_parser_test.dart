import 'dart:convert';
import 'dart:io';

import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:billlearn/src/domain/parsing/payment_text_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = PaymentTextParser();

  // 실제 알림 샘플은 test/fixtures/payment_parser_cases.json에 추가합니다.
  // 테스트 코드는 고정하고 샘플 파일만 늘려 파서 정확도를 추적하기 위한 구조입니다.
  final cases = _loadParserCases();

  for (final testCase in cases) {
    test('parses fixture: ${testCase.name}', () {
      final candidate = parser.parse(testCase.rawNotification);

      expect(candidate.parseStatus, testCase.expectedStatus);
      expect(candidate.amount, testCase.expectedAmount);
      expect(candidate.merchantName, testCase.expectedMerchantName);
      expect(candidate.paymentMethodHint, testCase.expectedPaymentMethodHint);
    });
  }
}

List<_ParserFixtureCase> _loadParserCases() {
  final file = File('test/fixtures/payment_parser_cases.json');
  final items = jsonDecode(file.readAsStringSync()) as List<dynamic>;
  return items
      .cast<Map<String, dynamic>>()
      .map(_ParserFixtureCase.fromJson)
      .toList(growable: false);
}

class _ParserFixtureCase {
  const _ParserFixtureCase({
    required this.name,
    required this.rawNotification,
    required this.expectedStatus,
    required this.expectedAmount,
    required this.expectedMerchantName,
    required this.expectedPaymentMethodHint,
  });

  final String name;
  final RawNotification rawNotification;
  final ParseStatus expectedStatus;
  final int expectedAmount;
  final String expectedMerchantName;
  final String? expectedPaymentMethodHint;

  factory _ParserFixtureCase.fromJson(Map<String, dynamic> json) {
    return _ParserFixtureCase(
      name: json['name'] as String,
      rawNotification: RawNotification(
        id: 'raw-${json['name']}',
        sourceType: RawNotificationSourceType.values.byName(
          json['sourceType'] as String,
        ),
        sourceApp: json['sourceApp'] as String?,
        sender: json['sender'] as String?,
        title: json['title'] as String?,
        body: json['body'] as String,
        receivedAt: DateTime(2026, 5, 14, 12, 31),
        sourceHash: 'hash-${json['name']}',
        createdAt: DateTime(2026, 5, 14, 12, 31),
      ),
      expectedStatus: ParseStatus.values.byName(
        json['expectedStatus'] as String,
      ),
      expectedAmount: json['expectedAmount'] as int,
      expectedMerchantName: json['expectedMerchantName'] as String,
      expectedPaymentMethodHint: json['expectedPaymentMethodHint'] as String?,
    );
  }
}
