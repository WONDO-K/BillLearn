import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expense = ref.watch(expenseByIdProvider(transactionId));

    return Scaffold(
      appBar: AppBar(title: const Text('상세')),
      body: expense.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('거래를 찾을 수 없습니다'));
          }
          return _TransactionDetailContent(expense: item);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('거래 정보를 불러오지 못했어요')),
      ),
    );
  }
}

class _TransactionDetailContent extends StatelessWidget {
  const _TransactionDetailContent({required this.expense});

  final ExpenseTransaction expense;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          expense.merchantName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          '${currencyFormat.format(expense.amount)}원',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              _DetailRow(label: '결제 시간', value: _formatDate(expense.spentAt)),
              _DetailRow(label: '상태', value: _statusText(expense)),
              _DetailRow(label: '확인 방식', value: _confirmedByText(expense)),
              _DetailRow(label: '동기화', value: _syncStatusText(expense)),
              if (expense.categoryId != null)
                _DetailRow(label: '카테고리', value: expense.categoryId!),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _FeedbackActions(expense: expense),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '연결된 후보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                for (final candidateId in expense.candidateIds)
                  Text(candidateId),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.year}.${value.month}.${value.day} $hour:$minute';
  }

  String _statusText(ExpenseTransaction expense) {
    return switch (expense.confirmationStatus) {
      ConfirmationStatus.confirmed => '확정됨',
      ConfirmationStatus.needsReview => '확인 필요',
      ConfirmationStatus.rejected => '제외됨',
    };
  }

  String _confirmedByText(ExpenseTransaction expense) {
    return switch (expense.confirmedBy) {
      ConfirmedBy.rule => '자동 규칙',
      ConfirmedBy.user => '사용자',
      ConfirmedBy.import => '가져오기',
    };
  }

  String _syncStatusText(ExpenseTransaction expense) {
    return switch (expense.syncStatus) {
      SyncStatus.localOnly => '로컬 저장',
      SyncStatus.pendingUpload => '업로드 대기',
      SyncStatus.synced => '동기화됨',
      SyncStatus.conflict => '충돌',
    };
  }
}

class _FeedbackActions extends ConsumerWidget {
  const _FeedbackActions({required this.expense});

  final ExpenseTransaction expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _updateStatus(ref, ConfirmationStatus.rejected),
            child: const Text('아니요'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () => _updateStatus(ref, ConfirmationStatus.confirmed),
            child: const Text('맞아요'),
          ),
        ),
      ],
    );
  }

  Future<void> _updateStatus(WidgetRef ref, ConfirmationStatus status) async {
    final updated = expense.copyWith(
      confirmationStatus: status,
      confirmedBy: ConfirmedBy.user,
      updatedAt: DateTime.now(),
    );
    await ref.read(expenseRepositoryProvider).updateExpense(updated);
    ref.invalidate(expenseByIdProvider(expense.id));
    ref.invalidate(expensesProvider);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
