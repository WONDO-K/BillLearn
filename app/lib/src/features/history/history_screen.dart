import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);

    return expenses.when(
      data: (items) => _HistoryContent(expenses: items),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text('내역을 불러오지 못했어요')),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({required this.expenses});

  final List<ExpenseTransaction> expenses;

  @override
  Widget build(BuildContext context) {
    final sortedExpenses = [...expenses]
      ..sort((a, b) => b.spentAt.compareTo(a.spentAt));
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '내역',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        if (sortedExpenses.isEmpty)
          const Card(
            child: ListTile(
              title: Text('저장된 지출이 없습니다'),
              subtitle: Text('결제 알림과 문자를 수집하면 내역이 표시됩니다.'),
            ),
          )
        else
          ...sortedExpenses.map(
            (expense) => Card(
              child: ListTile(
                title: Text(expense.merchantName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(_formatDate(expense.spentAt)),
                        if (expense.confirmationStatus !=
                            ConfirmationStatus.confirmed) ...[
                          const SizedBox(width: 8),
                          _StatusChip(expense: expense),
                        ],
                      ],
                    ),
                    if (expense.confirmationStatus ==
                        ConfirmationStatus.needsReview)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text('실제 지출인지 확인해주세요'),
                      ),
                  ],
                ),
                trailing: Text(
                  '${currencyFormat.format(expense.amount)}원',
                  style: TextStyle(
                    color:
                        expense.confirmationStatus ==
                            ConfirmationStatus.rejected
                        ? Colors.black45
                        : null,
                    decoration:
                        expense.confirmationStatus ==
                            ConfirmationStatus.rejected
                        ? TextDecoration.lineThrough
                        : null,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () => context.push('/transactions/${expense.id}'),
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.month}월 ${value.day}일 $hour:$minute';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.expense});

  final ExpenseTransaction expense;

  @override
  Widget build(BuildContext context) {
    final label = switch (expense.confirmationStatus) {
      ConfirmationStatus.confirmed => '확정됨',
      ConfirmationStatus.needsReview => '확인 필요',
      ConfirmationStatus.rejected => '제외됨',
    };

    return Text(
      label,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
