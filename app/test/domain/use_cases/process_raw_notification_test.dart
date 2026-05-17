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
    final candidates = await repository.getCandidatesForRawNotification(raw.id);
    final classification = await repository
        .getClassificationResultByCandidateId('candidate-${raw.id}');
    final expenses = await repository.watchExpenses().first;

    expect(rawNotifications, [raw]);
    expect(candidates, hasLength(1));
    expect(candidates.single.merchantName, '스타벅스');
    expect(classification?.isExpense, isTrue);
    expect(classification?.reasonCodes, contains('stable_payment_signal'));
    expect(expenses, hasLength(1));
    expect(expenses.single.amount, 12300);
    expect(expenses.single.merchantName, '스타벅스');
    expect(expenses.single.confirmationStatus, ConfirmationStatus.confirmed);

    await repository.dispose();
  });

  test('keeps repeated same merchant payments as separate expenses', () async {
    final repository = InMemoryExpenseRepository();
    final useCase = ProcessRawNotification(repository: repository);
    final firstRaw = RawNotification(
      id: 'push-1',
      sourceType: RawNotificationSourceType.push,
      sourceApp: 'com.card',
      sender: null,
      title: '카드 승인',
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-push-1',
      createdAt: DateTime(2026, 5, 14, 12, 30),
    );
    final secondRaw = RawNotification(
      id: 'sms-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:31',
      receivedAt: DateTime(2026, 5, 14, 12, 31),
      sourceHash: 'hash-sms-1',
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );

    await useCase(firstRaw);
    await useCase(secondRaw);

    final rawNotifications = await repository.watchRawNotifications().first;
    final expenses = await repository.watchExpenses().first;
    expect(rawNotifications, hasLength(2));
    expect(expenses, hasLength(2));
    expect(expenses.map((expense) => expense.merchantName), ['스타벅스', '스타벅스']);

    await repository.dispose();
  });

  test('ignores exact duplicate raw event with same source hash', () async {
    final repository = InMemoryExpenseRepository();
    final useCase = ProcessRawNotification(repository: repository);
    final firstRaw = RawNotification(
      id: 'raw-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 31),
      sourceHash: 'same-source-hash',
      createdAt: DateTime(2026, 5, 14, 12, 31),
    );
    final redeliveredRaw = RawNotification(
      id: 'raw-2',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 31),
      sourceHash: 'same-source-hash',
      createdAt: DateTime(2026, 5, 14, 12, 32),
    );

    await useCase(firstRaw);
    await useCase(redeliveredRaw);

    final rawNotifications = await repository.watchRawNotifications().first;
    final expenses = await repository.watchExpenses().first;
    expect(rawNotifications, hasLength(1));
    expect(expenses, hasLength(1));
    expect(expenses.single.merchantName, '스타벅스');

    await repository.dispose();
  });

  test('does not store person-to-person bank transfer as expense', () async {
    final repository = InMemoryExpenseRepository();
    final useCase = ProcessRawNotification(repository: repository);
    final raw = RawNotification(
      id: 'bank-transfer-1',
      sourceType: RawNotificationSourceType.push,
      sourceApp: 'viva.republica.toss',
      sender: null,
      title: '토스뱅크',
      body: '토스뱅크 홍길동님에게 50,000원 보냈어요',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-bank-transfer-1',
      createdAt: DateTime(2026, 5, 14, 12, 30),
    );

    await useCase(raw);

    final candidates = await repository.getCandidatesForRawNotification(raw.id);
    final classification = await repository
        .getClassificationResultByCandidateId('candidate-${raw.id}');
    final expenses = await repository.watchExpenses().first;

    expect(candidates, hasLength(1));
    expect(classification?.isTransferLike, isTrue);
    expect(classification?.reasonCodes, contains('bank_transfer_phrase'));
    expect(expenses, isEmpty);

    await repository.dispose();
  });

  test('does not store card approval cancellation as expense', () async {
    final repository = InMemoryExpenseRepository();
    final useCase = ProcessRawNotification(repository: repository);
    final raw = RawNotification(
      id: 'cancel-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인취소] 12,300원 스타벅스',
      receivedAt: DateTime(2026, 5, 14, 12, 45),
      sourceHash: 'hash-cancel-1',
      createdAt: DateTime(2026, 5, 14, 12, 45),
    );

    await useCase(raw);

    final classification = await repository
        .getClassificationResultByCandidateId('candidate-${raw.id}');
    final expenses = await repository.watchExpenses().first;

    expect(classification?.isExpense, isFalse);
    expect(classification?.reasonCodes, contains('cancellation_or_refund'));
    expect(expenses, isEmpty);

    await repository.dispose();
  });

  test(
    'rejects matching original expense when cancellation arrives later',
    () async {
      final repository = InMemoryExpenseRepository();
      final useCase = ProcessRawNotification(repository: repository);
      final approval = RawNotification(
        id: 'approval-1',
        sourceType: RawNotificationSourceType.sms,
        sourceApp: null,
        sender: '1588-0000',
        title: null,
        body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
        receivedAt: DateTime(2026, 5, 14, 12, 30),
        sourceHash: 'hash-approval-1',
        createdAt: DateTime(2026, 5, 14, 12, 30),
      );
      final cancellation = RawNotification(
        id: 'cancel-1',
        sourceType: RawNotificationSourceType.sms,
        sourceApp: null,
        sender: '1588-0000',
        title: null,
        body: '[신한카드 승인취소] 12,300원 스타벅스',
        receivedAt: DateTime(2026, 5, 14, 12, 45),
        sourceHash: 'hash-cancel-1',
        createdAt: DateTime(2026, 5, 14, 12, 45),
      );

      await useCase(approval);
      await useCase(cancellation);

      final expenses = await repository.watchExpenses().first;

      expect(expenses, hasLength(1));
      expect(expenses.single.amount, 12300);
      expect(expenses.single.merchantName, '스타벅스');
      expect(expenses.single.confirmationStatus, ConfirmationStatus.rejected);
      expect(expenses.single.confirmedBy, ConfirmedBy.rule);
      expect(
        expenses.single.candidateIds,
        contains('candidate-${approval.id}'),
      );
      expect(
        expenses.single.candidateIds,
        contains('candidate-${cancellation.id}'),
      );

      await repository.dispose();
    },
  );

  test(
    'does not reject user-confirmed expense when cancellation arrives later',
    () async {
      final repository = InMemoryExpenseRepository();
      final useCase = ProcessRawNotification(repository: repository);
      await repository.saveExpense(
        ExpenseTransaction(
          id: 'expense-user-confirmed',
          amount: 12300,
          merchantName: '스타벅스',
          categoryId: null,
          spentAt: DateTime(2026, 5, 14, 12, 30),
          confirmationStatus: ConfirmationStatus.confirmed,
          confirmedBy: ConfirmedBy.user,
          candidateIds: const ['candidate-manual'],
          createdAt: DateTime(2026, 5, 14, 12, 31),
          updatedAt: DateTime(2026, 5, 14, 12, 31),
          syncStatus: SyncStatus.localOnly,
        ),
      );
      final cancellation = RawNotification(
        id: 'cancel-user-confirmed',
        sourceType: RawNotificationSourceType.sms,
        sourceApp: null,
        sender: '1588-0000',
        title: null,
        body: '[신한카드 승인취소] 12,300원 스타벅스',
        receivedAt: DateTime(2026, 5, 14, 12, 45),
        sourceHash: 'hash-cancel-user-confirmed',
        createdAt: DateTime(2026, 5, 14, 12, 45),
      );

      await useCase(cancellation);

      final expenses = await repository.watchExpenses().first;

      expect(expenses, hasLength(1));
      expect(expenses.single.confirmationStatus, ConfirmationStatus.confirmed);
      expect(expenses.single.confirmedBy, ConfirmedBy.user);
      expect(
        expenses.single.candidateIds,
        isNot(contains('candidate-${cancellation.id}')),
      );

      await repository.dispose();
    },
  );

  test('does not auto-reject when multiple matching expenses exist', () async {
    final repository = InMemoryExpenseRepository();
    final useCase = ProcessRawNotification(repository: repository);
    final firstApproval = RawNotification(
      id: 'approval-1',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-approval-1',
      createdAt: DateTime(2026, 5, 14, 12, 30),
    );
    final secondApproval = RawNotification(
      id: 'approval-2',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인] 12,300원 스타벅스 05/14 12:35',
      receivedAt: DateTime(2026, 5, 14, 12, 35),
      sourceHash: 'hash-approval-2',
      createdAt: DateTime(2026, 5, 14, 12, 35),
    );
    final cancellation = RawNotification(
      id: 'cancel-ambiguous',
      sourceType: RawNotificationSourceType.sms,
      sourceApp: null,
      sender: '1588-0000',
      title: null,
      body: '[신한카드 승인취소] 12,300원 스타벅스',
      receivedAt: DateTime(2026, 5, 14, 12, 45),
      sourceHash: 'hash-cancel-ambiguous',
      createdAt: DateTime(2026, 5, 14, 12, 45),
    );

    await useCase(firstApproval);
    await useCase(secondApproval);
    await useCase(cancellation);

    final expenses = await repository.watchExpenses().first;

    expect(expenses, hasLength(2));
    expect(
      expenses.map((expense) => expense.confirmationStatus),
      everyElement(ConfirmationStatus.confirmed),
    );
    expect(
      expenses.expand((expense) => expense.candidateIds),
      isNot(contains('candidate-${cancellation.id}')),
    );

    await repository.dispose();
  });

  test(
    'excludes local currency top-up and stores only final spending',
    () async {
      final repository = InMemoryExpenseRepository();
      final useCase = ProcessRawNotification(repository: repository);
      final bankWithdrawal = RawNotification(
        id: 'bank-1',
        sourceType: RawNotificationSourceType.push,
        sourceApp: 'com.kakaobank',
        sender: null,
        title: '출금',
        body: '카카오뱅크 출금 5,000원 동백전 충전',
        receivedAt: DateTime(2026, 5, 14, 12),
        sourceHash: 'hash-bank-1',
        createdAt: DateTime(2026, 5, 14, 12),
      );
      final localCurrencyTopUp = RawNotification(
        id: 'dongbaek-1',
        sourceType: RawNotificationSourceType.push,
        sourceApp: 'com.dongbaek',
        sender: null,
        title: '동백전 충전',
        body: '동백전 충전 5,000원',
        receivedAt: DateTime(2026, 5, 14, 12, 1),
        sourceHash: 'hash-dongbaek-1',
        createdAt: DateTime(2026, 5, 14, 12, 1),
      );
      final convenienceStorePayment = RawNotification(
        id: 'payment-1',
        sourceType: RawNotificationSourceType.push,
        sourceApp: 'com.dongbaek',
        sender: null,
        title: '동백전 결제',
        body: '동백전 결제 3,400원 CU편의점 05/14 12:10',
        receivedAt: DateTime(2026, 5, 14, 12, 10),
        sourceHash: 'hash-payment-1',
        createdAt: DateTime(2026, 5, 14, 12, 10),
      );

      await useCase(bankWithdrawal);
      await useCase(localCurrencyTopUp);
      await useCase(convenienceStorePayment);

      final rawNotifications = await repository.watchRawNotifications().first;
      final expenses = await repository.watchExpenses().first;
      expect(rawNotifications, hasLength(3));
      expect(expenses, hasLength(1));
      expect(expenses.single.amount, 3400);
      expect(expenses.single.merchantName, 'CU편의점');

      await repository.dispose();
    },
  );

  test('keeps charging station payment despite charging keyword', () async {
    final repository = InMemoryExpenseRepository();
    final useCase = ProcessRawNotification(repository: repository);
    final raw = RawNotification(
      id: 'ev-1',
      sourceType: RawNotificationSourceType.push,
      sourceApp: 'com.card',
      sender: null,
      title: '카드 승인',
      body: '[신한카드 승인] 12,000원 전기차충전소 05/14 12:30',
      receivedAt: DateTime(2026, 5, 14, 12, 30),
      sourceHash: 'hash-ev-1',
      createdAt: DateTime(2026, 5, 14, 12, 30),
    );

    await useCase(raw);

    final expenses = await repository.watchExpenses().first;
    expect(expenses, hasLength(1));
    expect(expenses.single.merchantName, '전기차충전소');
    expect(expenses.single.amount, 12000);

    await repository.dispose();
  });
}
