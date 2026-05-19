import 'package:billlearn/src/app/app_theme.dart';
import 'package:flutter/material.dart';

class MerchantMark extends StatelessWidget {
  const MerchantMark({
    super.key,
    required this.merchantName,
    required this.categoryId,
    this.large = false,
  });

  final String merchantName;
  final String? categoryId;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final visual = MerchantVisual.from(merchantName, categoryId);

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

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.categoryId});

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

class MerchantVisual {
  const MerchantVisual({
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

  factory MerchantVisual.from(String merchantName, String? categoryId) {
    final normalized = merchantName.replaceAll(' ', '').toLowerCase();

    // 정식 로고 asset이 없는 MVP 단계에서는 가맹점별 색/라벨 fallback으로 시안의 로고 밀도를 맞춘다.
    if (normalized.contains('배달의민족') || normalized.contains('배민')) {
      return const MerchantVisual(
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
      return const MerchantVisual(
        label: '★',
        background: Color(0xFF006241),
        foreground: Colors.white,
        circular: true,
        largeFontSize: 18,
        smallFontSize: 15,
      );
    }
    if (normalized.contains('네이버') || normalized.contains('naver')) {
      return const MerchantVisual(
        label: 'N',
        background: Color(0xFF03C75A),
        foreground: Colors.white,
        largeFontSize: 18,
        smallFontSize: 15,
      );
    }
    if (normalized.contains('쿠팡') || normalized.contains('coupang')) {
      return const MerchantVisual(
        label: 'c',
        background: Color(0xFFD22F27),
        foreground: Colors.white,
        circular: true,
        largeFontSize: 19,
        smallFontSize: 15,
      );
    }
    if (normalized.contains('동백전')) {
      return const MerchantVisual(
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

    return MerchantVisual(
      label: initial,
      background: background,
      foreground: foreground,
    );
  }
}
