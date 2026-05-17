import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
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
    final confirmedCount = expenses
        .where(
          (expense) =>
              expense.confirmationStatus == ConfirmationStatus.confirmed,
        )
        .length;
    final reviewCount = expenses
        .where(
          (expense) =>
              expense.confirmationStatus == ConfirmationStatus.needsReview,
        )
        .length;
    final rejectedCount = expenses
        .where(
          (expense) =>
              expense.confirmationStatus == ConfirmationStatus.rejected,
        )
        .length;
    final confirmedTotal = expenses
        .where(
          (expense) =>
              expense.confirmationStatus == ConfirmationStatus.confirmed,
        )
        .fold<int>(0, (sum, expense) => sum + expense.amount);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        _HistorySummaryCard(
          confirmedTotal: confirmedTotal,
          confirmedCount: confirmedCount,
          reviewCount: reviewCount,
          rejectedCount: rejectedCount,
          currencyFormat: currencyFormat,
        ),
        const SizedBox(height: 22),
        const _SectionHeader(title: '정리된 지출 흐름'),
        const SizedBox(height: 8),
        if (sortedExpenses.isEmpty)
          const _EmptyStateTile(
            title: '저장된 지출이 없습니다',
            subtitle: '결제 알림과 문자를 수집하면 내역이 표시됩니다.',
          )
        else
          ...sortedExpenses.map(
            (expense) => _HistoryTransactionTile(
              expense: expense,
              subtitle: _formatDate(expense.spentAt),
              currencyFormat: currencyFormat,
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

class _HistorySummaryCard extends StatelessWidget {
  const _HistorySummaryCard({
    required this.confirmedTotal,
    required this.confirmedCount,
    required this.reviewCount,
    required this.rejectedCount,
    required this.currencyFormat,
  });

  final int confirmedTotal;
  final int confirmedCount;
  final int reviewCount;
  final int rejectedCount;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, BillLearnColors.lightPurple],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: BillLearnColors.mainPurple.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '내역',
              style: TextStyle(
                color: BillLearnColors.ink,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '수집된 알림을 실제 지출, 확인 필요, 제외 거래로 나눠 보여드려요.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '확정 지출',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${currencyFormat.format(confirmedTotal)}원',
              style: const TextStyle(
                color: BillLearnColors.ink,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryPill(label: '확정', value: '$confirmedCount건'),
                _SummaryPill(label: '검토', value: '$reviewCount건'),
                _SummaryPill(label: '제외', value: '$rejectedCount건'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          '$label $value',
          style: const TextStyle(
            color: BillLearnColors.mainPurple,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
    );
  }
}

class _HistoryTransactionTile extends StatelessWidget {
  const _HistoryTransactionTile({
    required this.expense,
    required this.subtitle,
    required this.currencyFormat,
  });

  final ExpenseTransaction expense;
  final String subtitle;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isRejected =
        expense.confirmationStatus == ConfirmationStatus.rejected;
    final needsReview =
        expense.confirmationStatus == ConfirmationStatus.needsReview;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => context.push('/transactions/${expense.id}'),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              expense.merchantName,
                              style: TextStyle(
                                color: isRejected
                                    ? Colors.black45
                                    : BillLearnColors.ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (expense.confirmationStatus !=
                              ConfirmationStatus.confirmed)
                            _StatusChip(expense: expense),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (needsReview)
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '실제 지출인지 확인해주세요',
                            style: TextStyle(
                              color: BillLearnColors.mainPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${currencyFormat.format(expense.amount)}원',
                  style: TextStyle(
                    color: isRejected ? Colors.black45 : BillLearnColors.ink,
                    decoration: isRejected ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyStateTile extends StatelessWidget {
  const _EmptyStateTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: BillLearnColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
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
    final color = switch (expense.confirmationStatus) {
      ConfirmationStatus.confirmed => BillLearnColors.mainPurple,
      ConfirmationStatus.needsReview => BillLearnColors.mainPurple,
      ConfirmationStatus.rejected => Colors.black45,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
