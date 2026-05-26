import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
import 'package:billlearn/src/features/shared/merchant_visuals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    // 예산 관리는 아직 없으므로, 현재는 사용자가 정할 월 지출 한도 개념으로만 표시한다.
    const monthlyBudget = 1800000;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      children: [
        _HomeHeroCard(
          total: total,
          monthlyBudget: monthlyBudget,
          confirmedCount: confirmedExpenses.length,
          needsReviewCount: needsReview.length,
          currencyFormat: currencyFormat,
        ),
        const SizedBox(height: 16),
        _ReviewInsightPanel(
          needsReview: needsReview,
          currencyFormat: currencyFormat,
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          title: '최근 거래',
          actionLabel: recentExpenses.isEmpty ? null : '더보기 >',
          onActionTap: recentExpenses.isEmpty
              ? null
              : () => context.go('/history'),
        ),
        const SizedBox(height: 8),
        if (recentExpenses.isEmpty)
          const _EmptyStateTile(
            title: '정리된 지출이 없습니다',
            subtitle: '실제 지출로 확정된 거래만 최근 내역에 표시됩니다.',
          )
        else
          _RecentTransactionsCard(
            expenses: recentExpenses.take(3).toList(growable: false),
            currencyFormat: currencyFormat,
            formatDate: _formatDate,
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
    required this.monthlyBudget,
    required this.confirmedCount,
    required this.needsReviewCount,
    required this.currencyFormat,
  });

  final int total;
  final int monthlyBudget;
  final int confirmedCount;
  final int needsReviewCount;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final budgetProgress = monthlyBudget == 0
        ? 0.0
        : (total / monthlyBudget).clamp(0.0, 1.0);
    final budgetPercent = (budgetProgress * 100).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5B3FFF),
              BillLearnColors.mainPurple,
              Color(0xFF9C84FF),
            ],
            stops: [0.0, 0.54, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: BillLearnColors.mainPurple.withValues(alpha: 0.28),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              right: -44,
              top: -38,
              child: _HeroGlowCircle(size: 158, opacity: 0.18),
            ),
            const Positioned(
              left: -62,
              bottom: -78,
              child: _HeroGlowCircle(size: 180, opacity: 0.12),
            ),
            Positioned(
              right: -10,
              top: 20,
              bottom: 6,
              child: Opacity(
                opacity: 0.94,
                child: SizedBox(
                  width: 142,
                  child: Transform.scale(
                    scale: 1.34,
                    child: SvgPicture.asset(
                      'assets/brand/brand_mascot.svg',
                      fit: BoxFit.contain,
                      semanticsLabel: 'BillLearn hero mascot',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 122, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이번 달 총 지출',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${currencyFormat.format(total)}원',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '월 지출 한도 ${currencyFormat.format(monthlyBudget)}원',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.84),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 7,
                            value: budgetProgress,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.34,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$budgetPercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _HeroFooterLine(
                    confirmedCount: confirmedCount,
                    needsReviewCount: needsReviewCount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroGlowCircle extends StatelessWidget {
  const _HeroGlowCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _HeroFooterLine extends StatelessWidget {
  const _HeroFooterLine({
    required this.confirmedCount,
    required this.needsReviewCount,
  });

  final int confirmedCount;
  final int needsReviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            confirmedCount == 0
                ? '전월 데이터 수집 전'
                : '확정 거래 $confirmedCount건 · 전월 대비 집계 준비 중',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              needsReviewCount == 0 ? '검토 없음' : '검토 $needsReviewCount건',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: BillLearnColors.mainPurple,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ReviewInsightPanel extends StatelessWidget {
  const _ReviewInsightPanel({
    required this.needsReview,
    required this.currencyFormat,
  });

  final List<ExpenseTransaction> needsReview;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final visibleItems = needsReview.take(3).toList(growable: false);

    // AI 고도화 전까지는 "인사이트"를 확정 판단이 필요한 알림 묶음으로 제한한다.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: BillLearnColors.lightPurple),
        boxShadow: [
          BoxShadow(
            color: BillLearnColors.mainPurple.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            _SectionHeader(
              title: '검토가 필요한 알림',
              subtitle: '이체, 충전, 취소처럼 애매한 알림을 먼저 확인해요',
              actionLabel: needsReview.isEmpty
                  ? null
                  : '${needsReview.length}건',
            ),
            const SizedBox(height: 12),
            if (visibleItems.isEmpty)
              const _InsightStatusRow(
                icon: Icons.check_circle_outline_rounded,
                title: '중복 계산 의심 없음',
                subtitle: '현재는 실제 지출로 확정된 거래만 홈에 반영 중입니다.',
              )
            else
              for (final expense in visibleItems)
                _ReviewTransactionTile(
                  expense: expense,
                  currencyFormat: currencyFormat,
                ),
          ],
        ),
      ),
    );
  }
}

class _InsightStatusRow extends StatelessWidget {
  const _InsightStatusRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _SoftTile(
      title: title,
      subtitle: subtitle,
      leading: _InsightIcon(icon: icon),
    );
  }
}

class _InsightIcon extends StatelessWidget {
  const _InsightIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.lightPurple,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Icon(icon, color: BillLearnColors.mainPurple, size: 21),
      ),
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
      leading: MerchantMark(
        merchantName: expense.merchantName,
        categoryId: expense.categoryId,
      ),
      trailing: const Text(
        '확인하기 >',
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
    return _RecentTransactionRow(
      expense: expense,
      subtitle: subtitle,
      currencyFormat: currencyFormat,
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({
    required this.expenses,
    required this.currencyFormat,
    required this.formatDate,
  });

  final List<ExpenseTransaction> expenses;
  final NumberFormat currencyFormat;
  final String Function(DateTime value) formatDate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 2),
        child: Column(
          children: [
            for (final expense in expenses)
              _RecentTransactionTile(
                expense: expense,
                subtitle: formatDate(expense.spentAt),
                currencyFormat: currencyFormat,
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactionRow extends StatelessWidget {
  const _RecentTransactionRow({
    required this.expense,
    required this.subtitle,
    required this.currencyFormat,
  });

  final ExpenseTransaction expense;
  final String subtitle;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (expense.categoryId != null) ...[
                      const SizedBox(width: 8),
                      CategoryChip(categoryId: expense.categoryId!),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${currencyFormat.format(expense.amount)}원',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
        ],
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
    return _SoftTile(
      title: title,
      subtitle: subtitle,
      leading: const _MascotBadge(),
    );
  }
}

class _MascotBadge extends StatelessWidget {
  const _MascotBadge();

  @override
  Widget build(BuildContext context) {
    // 홈 빈 상태에서 브랜드 캐릭터를 작은 상태 아이콘처럼 사용한다.
    // SVG 렌더링을 이 위젯 안에 모아두면 이후 안내 카드에도 재사용하기 쉽다.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.lightPurple,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: BillLearnColors.mainPurple.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox.square(
          dimension: 52,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Transform.scale(
              scale: 1.65,
              child: SvgPicture.asset(
                'assets/brand/brand_mascot.svg',
                fit: BoxFit.cover,
                semanticsLabel: 'BillLearn mascot',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoftTile extends StatelessWidget {
  const _SoftTile({
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
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
                if (leading != null) ...[leading!, const SizedBox(width: 12)],
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
