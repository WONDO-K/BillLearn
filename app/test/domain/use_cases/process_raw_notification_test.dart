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

    final rawNotifications = await repository.watchRawNotifications().first;
    final expenses = await repository.watchExpenses().first;

    expect(rawNotifications, [raw]);
    expect(expenses, hasLength(1));
    expect(expenses.single.amount, 12300);
    expect(expenses.single.merchantName, '스타벅스');
    expect(expenses.single.confirmationStatus, ConfirmationStatus.confirmed);

    await repository.dispose();
  });
}
