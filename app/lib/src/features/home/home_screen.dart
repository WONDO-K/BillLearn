import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);

    return expenses.when(
      data: (items) => _HomeContent(expenses: items),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            '이번 달 실제 지출',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text('지출 내역을 불러오지 못했어요'),
              subtitle: Text('잠시 후 다시 확인해주세요.'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.expenses});

  final List<ExpenseTransaction> expenses;

  @override
  Widget build(BuildContext context) {
    final confirmedExpenses = expenses
        .where(
          (expense) =>
              expense.confirmationStatus == ConfirmationStatus.confirmed,
        )
        .toList(growable: false);
    final needsReview = expenses
        .where(
          (expense) =>
              expense.confirmationStatus == ConfirmationStatus.needsReview,
        )
        .toList(growable: false);
    final total = confirmedExpenses.fold<int>(
      0,
      (sum, expense) => sum + expense.amount,
    );
    final recentExpenses = [...confirmedExpenses]
      ..sort((a, b) => b.spentAt.compareTo(a.spentAt));
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '이번 달 실제 지출',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          '${currencyFormat.format(total)}원',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 24),
        const Text(
          '확인 필요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (needsReview.isEmpty)
          const Card(
            child: ListTile(
              title: Text('아직 확인할 거래가 없어요'),
              subtitle: Text('결제 알림과 문자를 수집하면 여기에 표시됩니다.'),
            ),
          )
        else
          ...needsReview.map(
            (expense) => Card(
              child: ListTile(
                title: Text(expense.merchantName),
                subtitle: Text(
                  '${currencyFormat.format(expense.amount)}원 · 실제 지출인지 확인해주세요',
                ),
                trailing: const Text(
                  '검토하러 가기',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                onTap: () => context.push('/transactions/${expense.id}'),
              ),
            ),
          ),
        const SizedBox(height: 24),
        const Text(
          '최근 내역',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (recentExpenses.isEmpty)
          const Card(
            child: ListTile(
              title: Text('정리된 지출이 없습니다'),
              subtitle: Text('실제 지출로 확정된 거래만 표시됩니다.'),
            ),
          )
        else
          ...recentExpenses
              .take(3)
              .map(
                (expense) => Card(
                  child: ListTile(
                    title: Text(expense.merchantName),
                    subtitle: Text(_formatDate(expense.spentAt)),
                    trailing: Text(
                      '${currencyFormat.format(expense.amount)}원',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
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
