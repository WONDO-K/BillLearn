import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:billlearn/src/domain/models/expense_transaction.dart';
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
    // 예산 관리 기능은 아직 없으므로, 시안의 홈 카드 구조를 검증하기 위한 임시 월 예산값이다.
    const monthlyBudget = 1800000;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        _HomeHeroCard(
          total: total,
          monthlyBudget: monthlyBudget,
          confirmedCount: confirmedExpenses.length,
          needsReviewCount: needsReview.length,
          currencyFormat: currencyFormat,
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: '빌런의 인사이트',
          subtitle: '실제 지출인지 애매한 알림을 먼저 확인해요',
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
        const SizedBox(height: 18),
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
      borderRadius: BorderRadius.circular(22),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [BillLearnColors.mainPurple, Color(0xFF8C73FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: BillLearnColors.mainPurple.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: 18,
              bottom: 8,
              child: Opacity(
                opacity: 0.92,
                child: SizedBox(
                  width: 134,
                  child: Transform.scale(
                    scale: 1.28,
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
              padding: const EdgeInsets.fromLTRB(18, 18, 118, 18),
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
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '예산 ${currencyFormat.format(monthlyBudget)}원',
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
                  Text(
                    confirmedCount == 0 ? '전월 데이터 수집 전' : '전월 대비 집계 준비 중',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _HeroReviewLine(needsReviewCount: needsReviewCount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroReviewLine extends StatelessWidget {
  const _HeroReviewLine({required this.needsReviewCount});

  final int needsReviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          needsReviewCount == 0 ? '검토할 알림 없음' : '검토할 알림 $needsReviewCount건',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 3),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white.withValues(alpha: 0.88),
          size: 17,
        ),
      ],
    );
  }
}

class _MerchantMark extends StatelessWidget {
  const _MerchantMark({
    required this.merchantName,
    required this.categoryId,
    this.large = false,
  });

  final String merchantName;
  final String? categoryId;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final visual = _MerchantVisual.from(merchantName, categoryId);

    return Container(
      width: large ? 42 : 34,
      height: large ? 42 : 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: visual.background,
        shape: visual.circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: visual.circular
            ? null
            : BorderRadius.circular(large ? 14 : 12),
      ),
      child: Text(
        visual.label,
        style: TextStyle(
          color: visual.foreground,
          fontSize: large ? visual.largeFontSize : visual.smallFontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: visual.letterSpacing,
        ),
      ),
    );
  }
}

class _MerchantVisual {
  const _MerchantVisual({
    required this.label,
    required this.background,
    required this.foreground,
    this.circular = false,
    this.largeFontSize = 17,
    this.smallFontSize = 14,
    this.letterSpacing = -0.2,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool circular;
  final double largeFontSize;
  final double smallFontSize;
  final double letterSpacing;

  factory _MerchantVisual.from(String merchantName, String? categoryId) {
    final normalized = merchantName.replaceAll(' ', '').toLowerCase();

    // 정식 로고 asset이 없는 MVP 단계에서는 가맹점별 색/라벨 fallback으로 시안의 로고 밀도를 맞춘다.
    if (normalized.contains('배달의민족') || normalized.contains('배민')) {
      return const _MerchantVisual(
        label: '배민',
        background: Color(0xFF48C7C2),
        foreground: Colors.white,
        circular: true,
        largeFontSize: 12,
        smallFontSize: 10,
        letterSpacing: -1.0,
      );
    }
    if (normalized.contains('스타벅스')) {
      return const _MerchantVisual(
        label: '★',
        background: Color(0xFF006241),
        foreground: Colors.white,
        circular: true,
        largeFontSize: 18,
        smallFontSize: 15,
      );
    }
    if (normalized.contains('네이버') || normalized.contains('naver')) {
      return const _MerchantVisual(
        label: 'N',
        background: Color(0xFF03C75A),
        foreground: Colors.white,
        largeFontSize: 18,
        smallFontSize: 15,
      );
    }
    if (normalized.contains('쿠팡') || normalized.contains('coupang')) {
      return const _MerchantVisual(
        label: 'c',
        background: Color(0xFFD22F27),
        foreground: Colors.white,
        circular: true,
        largeFontSize: 19,
        smallFontSize: 15,
      );
    }
    if (normalized.contains('동백전')) {
      return const _MerchantVisual(
        label: '동',
        background: BillLearnColors.lightPurple,
        foreground: BillLearnColors.mainPurple,
        largeFontSize: 16,
        smallFontSize: 13,
      );
    }

    final initial = merchantName.characters.isEmpty
        ? '?'
        : merchantName.characters.first;
    final background = switch (categoryId) {
      'food' => const Color(0xFFE8F7EF),
      'cafe' => const Color(0xFFEAF4F1),
      'shopping' => const Color(0xFFF2EEFF),
      _ => BillLearnColors.lightPurple,
    };
    final foreground = switch (categoryId) {
      'food' => const Color(0xFF1F8F5B),
      'cafe' => const Color(0xFF26745D),
      'shopping' => BillLearnColors.mainPurple,
      _ => BillLearnColors.mainPurple,
    };

    return _MerchantVisual(
      label: initial,
      background: background,
      foreground: foreground,
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
      leading: _MerchantMark(
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 4),
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
          _MerchantMark(
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
                      _CategoryChip(categoryId: expense.categoryId!),
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final label = switch (categoryId) {
      'food' => '배달/음식',
      'cafe' => '카페',
      'shopping' => '쇼핑',
      _ => '기타',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.lightPurple.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: const TextStyle(
            color: BillLearnColors.mainPurple,
            fontSize: 9,
            fontWeight: FontWeight.w800,
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
