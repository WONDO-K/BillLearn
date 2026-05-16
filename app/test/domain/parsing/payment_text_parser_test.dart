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

  test('parses simple pay payment notification', () {
    final raw = RawNotification(
      id: 'raw-3',
      sourceType: RawNotificationSourceType.push,
      sourceApp: 'com.naverpay',
      sender: null,
      title: '네이버페이',
      body: '네이버페이 결제 39,800원 네이버쇼핑 11:32',
      receivedAt: DateTime(2026, 5, 14, 11, 32),
      sourceHash: 'hash-3',
      createdAt: DateTime(2026, 5, 14, 11, 32),
    );

    final candidate = parser.parse(raw);

    expect(candidate.parseStatus, ParseStatus.parsed);
    expect(candidate.amount, 39800);
    expect(candidate.merchantName, '네이버쇼핑');
    expect(candidate.paymentMethodHint, '네이버페이');
  });

  test(
    'parses local currency payment without treating balance as merchant',
    () {
      final raw = RawNotification(
        id: 'raw-4',
        sourceType: RawNotificationSourceType.push,
        sourceApp: 'com.dongbaek',
        sender: null,
        title: '동백전',
        body: '동백전 결제 3,400원 CU편의점 잔액 16,600원',
        receivedAt: DateTime(2026, 5, 14, 12, 10),
        sourceHash: 'hash-4',
        createdAt: DateTime(2026, 5, 14, 12, 10),
      );

      final candidate = parser.parse(raw);

      expect(candidate.parseStatus, ParseStatus.parsed);
      expect(candidate.amount, 3400);
      expect(candidate.merchantName, 'CU편의점');
      expect(candidate.paymentMethodHint, '동백전');
    },
  );
}
