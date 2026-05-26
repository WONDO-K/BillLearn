import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/features/shared/merchant_visuals.dart';
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
    final groupedExpenses = _groupByDate(sortedExpenses);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      children: [
        const _HistoryFilterRow(),
        const SizedBox(height: 14),
        _HistorySummaryCard(
          confirmedTotal: confirmedTotal,
          confirmedCount: confirmedCount,
          reviewCount: reviewCount,
          rejectedCount: rejectedCount,
          totalCount: expenses.length,
          currencyFormat: currencyFormat,
        ),
        const SizedBox(height: 20),
        if (sortedExpenses.isEmpty)
          const _EmptyStateTile(
            title: '저장된 지출이 없습니다',
            subtitle: '결제 알림과 문자를 수집하면 내역이 표시됩니다.',
          )
        else
          for (final group in groupedExpenses.entries) ...[
            _DateHeader(date: group.key),
            const SizedBox(height: 8),
            _HistoryDateCard(
              expenses: group.value,
              currencyFormat: currencyFormat,
              formatTime: _formatTime,
            ),
            const SizedBox(height: 18),
          ],
      ],
    );
  }

  Map<DateTime, List<ExpenseTransaction>> _groupByDate(
    List<ExpenseTransaction> values,
  ) {
    final grouped = <DateTime, List<ExpenseTransaction>>{};
    for (final expense in values) {
      final key = DateTime(
        expense.spentAt.year,
        expense.spentAt.month,
        expense.spentAt.day,
      );
      grouped.putIfAbsent(key, () => []).add(expense);
    }
    return grouped;
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _HistoryFilterRow extends StatelessWidget {
  const _HistoryFilterRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _FilterPill(label: '잔여 기간'),
        const SizedBox(width: 8),
        const _FilterPill(label: '전체 카테고리'),
        const Spacer(),
        IconButton(
          tooltip: '검색',
          onPressed: () {},
          icon: const Icon(Icons.search_rounded, color: BillLearnColors.ink),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7E3F5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: BillLearnColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistorySummaryCard extends StatelessWidget {
  const _HistorySummaryCard({
    required this.confirmedTotal,
    required this.confirmedCount,
    required this.reviewCount,
    required this.rejectedCount,
    required this.totalCount,
    required this.currencyFormat,
  });

  final int confirmedTotal;
  final int confirmedCount;
  final int reviewCount;
  final int rejectedCount;
  final int totalCount;
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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: BillLearnColors.mainPurple.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '전체 지출',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '${currencyFormat.format(confirmedTotal)}원',
                    style: const TextStyle(
                      color: BillLearnColors.ink,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                Text(
                  '$totalCount건',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return Text(
      '${date.month}월 ${date.day}일 (${weekdays[date.weekday - 1]})',
      style: const TextStyle(
        color: BillLearnColors.ink,
        fontSize: 15,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _HistoryDateCard extends StatelessWidget {
  const _HistoryDateCard({
    required this.expenses,
    required this.currencyFormat,
    required this.formatTime,
  });

  final List<ExpenseTransaction> expenses;
  final NumberFormat currencyFormat;
  final String Function(DateTime value) formatTime;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 2),
        child: Column(
          children: [
            for (final expense in expenses)
              _HistoryTransactionRow(
                expense: expense,
                subtitle: formatTime(expense.spentAt),
                currencyFormat: currencyFormat,
              ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTransactionRow extends StatelessWidget {
  const _HistoryTransactionRow({
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

    return InkWell(
      onTap: () => context.push('/transactions/${expense.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          children: [
            MerchantMark(
              merchantName: expense.merchantName,
              categoryId: expense.categoryId,
              large: true,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Opacity(
                opacity: isRejected ? 0.58 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            expense.merchantName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: BillLearnColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (expense.categoryId != null) ...[
                          const SizedBox(width: 7),
                          CategoryChip(categoryId: expense.categoryId!),
                        ],
                        if (expense.confirmationStatus !=
                            ConfirmationStatus.confirmed) ...[
                          const SizedBox(width: 7),
                          _StatusChip(expense: expense),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      needsReview ? '$subtitle · 실제 지출 확인 필요' : subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: needsReview
                            ? BillLearnColors.mainPurple
                            : Colors.black54,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${currencyFormat.format(expense.amount)}원',
              style: TextStyle(
                color: isRejected ? Colors.black45 : BillLearnColors.ink,
                decoration: isRejected ? TextDecoration.lineThrough : null,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
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
