import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        _HomeHeroCard(
          total: total,
          confirmedCount: confirmedExpenses.length,
          needsReviewCount: needsReview.length,
          currencyFormat: currencyFormat,
        ),
        const SizedBox(height: 22),
        _SectionHeader(
          title: 'AI가 헷갈린 거래',
          actionLabel: needsReview.isEmpty ? null : '${needsReview.length}건',
        ),
        const SizedBox(height: 8),
        if (needsReview.isEmpty)
          const _EmptyStateTile(
            title: '아직 확인할 거래가 없어요',
            subtitle: '이체, 충전, 취소처럼 애매한 알림이 생기면 여기에 모아둘게요.',
          )
        else
          ...needsReview.map(
            (expense) => _ReviewTransactionTile(
              expense: expense,
              currencyFormat: currencyFormat,
            ),
          ),
        const SizedBox(height: 22),
        const _SectionHeader(title: '최근 내역'),
        const SizedBox(height: 8),
        if (recentExpenses.isEmpty)
          const _EmptyStateTile(
            title: '정리된 지출이 없습니다',
            subtitle: '실제 지출로 확정된 거래만 최근 내역에 표시됩니다.',
          )
        else
          ...recentExpenses
              .take(3)
              .map(
                (expense) => _RecentTransactionTile(
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

class _HomeHeroCard extends StatelessWidget {
  const _HomeHeroCard({
    required this.total,
    required this.confirmedCount,
    required this.needsReviewCount,
    required this.currencyFormat,
  });

  final int total;
  final int confirmedCount;
  final int needsReviewCount;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BillLearnColors.mainPurple, Color(0xFF8C73FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: BillLearnColors.mainPurple.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '영수증으로부터 배운 지출',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '자동 수집된 결제 알림에서 실제 소비만 남겼어요.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              '이번 달 실제 지출',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${currencyFormat.format(total)}원',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _HeroMetric(label: '확정', value: '$confirmedCount건'),
                const SizedBox(width: 10),
                _HeroMetric(label: '검토', value: '$needsReviewCount건'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          '$label $value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: const TextStyle(
              color: BillLearnColors.mainPurple,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}

class _ReviewTransactionTile extends StatelessWidget {
  const _ReviewTransactionTile({
    required this.expense,
    required this.currencyFormat,
  });

  final ExpenseTransaction expense;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return _SoftTile(
      title: expense.merchantName,
      subtitle: '${currencyFormat.format(expense.amount)}원 · 실제 지출인지 확인해주세요',
      trailing: const Text(
        '검토하러 가기',
        style: TextStyle(
          color: BillLearnColors.mainPurple,
          fontWeight: FontWeight.w900,
        ),
      ),
      onTap: () => context.push('/transactions/${expense.id}'),
    );
  }
}

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({
    required this.expense,
    required this.subtitle,
    required this.currencyFormat,
  });

  final ExpenseTransaction expense;
  final String subtitle;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return _SoftTile(
      title: expense.merchantName,
      subtitle: subtitle,
      trailing: Text(
        '${currencyFormat.format(expense.amount)}원',
        style: const TextStyle(fontWeight: FontWeight.w900),
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
    return _SoftTile(title: title, subtitle: subtitle);
  }
}

class _SoftTile extends StatelessWidget {
  const _SoftTile({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                if (trailing != null) ...[const SizedBox(width: 12), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
