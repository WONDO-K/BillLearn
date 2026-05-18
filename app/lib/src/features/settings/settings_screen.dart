import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:billlearn/src/domain/models/classification_result.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:billlearn/src/domain/models/transaction_candidate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAccess = ref.watch(notificationAccessEnabledProvider);
    final smsPermission = ref.watch(smsPermissionGrantedProvider);
    final rawNotifications = ref.watch(rawNotificationsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        const _SettingsHeroCard(),
        const SizedBox(height: 16),
        _PermissionCard(
          title: '알림 접근 권한',
          description: '카드 앱, 간편결제 앱의 결제 알림을 자동으로 읽기 위해 필요합니다.',
          access: notificationAccess,
          actionLabel: '설정 열기',
          actionStyle: _PermissionActionStyle.filled,
          onPressed: () async {
            await ref
                .read(androidEventBridgeProvider)
                .openNotificationAccessSettings();
            ref.invalidate(notificationAccessEnabledProvider);
          },
        ),
        const SizedBox(height: 12),
        _PermissionCard(
          title: 'SMS 권한',
          description: '카드 승인 문자와 결제 문자를 자동 수집하기 위해 필요합니다.',
          access: smsPermission,
          actionLabel: 'SMS 권한 요청',
          actionStyle: _PermissionActionStyle.outlined,
          onPressed: () async {
            await ref.read(androidEventBridgeProvider).requestSmsPermission();
            ref.invalidate(smsPermissionGrantedProvider);
          },
        ),
        const SizedBox(height: 12),
        if (kDebugMode) ...[
          const _DebugToolsCard(),
          const SizedBox(height: 12),
        ],
        _CollectionDiagnosticsCard(rawNotifications: rawNotifications),
      ],
    );
  }
}

class _SettingsHeroCard extends StatelessWidget {
  const _SettingsHeroCard();

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
      child: const Padding(
        padding: EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '설정',
              style: TextStyle(
                color: BillLearnColors.ink,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '결제 알림 수집 권한과 파이프라인 상태를 확인합니다.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _PermissionActionStyle { filled, outlined }

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.title,
    required this.description,
    required this.access,
    required this.actionLabel,
    required this.actionStyle,
    required this.onPressed,
  });

  final String title;
  final String description;
  final AsyncValue<bool> access;
  final String actionLabel;
  final _PermissionActionStyle actionStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final action = switch (actionStyle) {
      _PermissionActionStyle.filled => FilledButton(
        onPressed: onPressed,
        child: Text(actionLabel),
      ),
      _PermissionActionStyle.outlined => OutlinedButton(
        onPressed: onPressed,
        child: Text(actionLabel),
      ),
    };

    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _CardTitle(title)),
              _PermissionStatusChip(access: access),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          action,
        ],
      ),
    );
  }
}

class _DebugToolsCard extends ConsumerWidget {
  const _DebugToolsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle('개발자 도구'),
          const SizedBox(height: 8),
          const Text(
            '에뮬레이터 UI 확인용 샘플 거래를 생성합니다.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () async {
              await ref.read(seedDebugSampleDataProvider).call();
              ref.invalidate(expensesProvider);
              ref.invalidate(rawNotificationsProvider);

              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('샘플 거래를 생성했습니다')));
              }
            },
            child: const Text('샘플 거래 생성'),
          ),
        ],
      ),
    );
  }
}

class _CollectionDiagnosticsCard extends ConsumerWidget {
  const _CollectionDiagnosticsCard({required this.rawNotifications});

  final AsyncValue<List<RawNotification>> rawNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SoftCard(
      child: rawNotifications.when(
        data: (items) {
          final latest = [...items]
            ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle('수집 진단'),
              const SizedBox(height: 8),
              _MetricPill(label: '최근 수집', value: '${items.length}건'),
              const SizedBox(height: 14),
              if (latest.isEmpty)
                const Text(
                  '아직 수집된 원천 알림이 없습니다.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else ...[
                const _SubTitle('마지막 수집'),
                const SizedBox(height: 6),
                _RawBodyPreview(body: latest.first.body),
                const SizedBox(height: 14),
                _LatestProcessingDiagnostics(raw: latest.first),
              ],
            ],
          );
        },
        loading: () => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardTitle('수집 진단'),
            SizedBox(height: 8),
            Text('원천 알림 상태를 불러오는 중입니다.'),
          ],
        ),
        error: (error, stackTrace) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardTitle('수집 진단'),
            SizedBox(height: 8),
            Text('원천 알림 상태를 불러오지 못했어요.'),
          ],
        ),
      ),
    );
  }
}

class _LatestProcessingDiagnostics extends ConsumerWidget {
  const _LatestProcessingDiagnostics({required this.raw});

  final RawNotification raw;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates = ref.watch(
      transactionCandidatesForRawNotificationProvider(raw.id),
    );

    return candidates.when(
      data: (items) {
        if (items.isEmpty) {
          return const Text('아직 파싱 후보가 없습니다.');
        }
        final candidate = items.first;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CandidateDiagnostic(candidate: candidate),
            const SizedBox(height: 14),
            _ClassificationDiagnostic(candidateId: candidate.id),
          ],
        );
      },
      loading: () => const Text('파싱 결과를 불러오는 중입니다.'),
      error: (error, stackTrace) => const Text('파싱 결과를 불러오지 못했어요.'),
    );
  }
}

class _CandidateDiagnostic extends StatelessWidget {
  const _CandidateDiagnostic({required this.candidate});

  final TransactionCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('ko_KR');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SubTitle('파싱 결과'),
        const SizedBox(height: 6),
        Text(
          '${candidate.merchantName} · ${currencyFormat.format(candidate.amount)}원',
          style: const TextStyle(
            color: BillLearnColors.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ClassificationDiagnostic extends ConsumerWidget {
  const _ClassificationDiagnostic({required this.candidateId});

  final String candidateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classification = ref.watch(
      classificationResultByCandidateIdProvider(candidateId),
    );

    return classification.when(
      data: (item) {
        if (item == null) {
          return const Text('아직 판별 결과가 없습니다.');
        }
        return _ClassificationDiagnosticContent(classification: item);
      },
      loading: () => const Text('판별 결과를 불러오는 중입니다.'),
      error: (error, stackTrace) => const Text('판별 결과를 불러오지 못했어요.'),
    );
  }
}

class _ClassificationDiagnosticContent extends StatelessWidget {
  const _ClassificationDiagnosticContent({required this.classification});

  final ClassificationResult classification;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SubTitle('판별 결과'),
        const SizedBox(height: 6),
        Text(
          '${classification.isExpense ? '실제 지출' : '지출 제외'} · '
          '신뢰도 ${(classification.confidence * 100).round()}%',
          style: const TextStyle(
            color: BillLearnColors.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final reasonCode in classification.reasonCodes)
              _ReasonCode(label: reasonCode),
          ],
        ),
      ],
    );
  }
}

class _PermissionStatusChip extends StatelessWidget {
  const _PermissionStatusChip({required this.access});

  final AsyncValue<bool> access;

  @override
  Widget build(BuildContext context) {
    return access.when(
      data: (enabled) =>
          _StatusPill(label: enabled ? '켜짐' : '꺼짐', active: enabled),
      loading: () => const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stackTrace) =>
          const _StatusPill(label: '확인 실패', active: false),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: BillLearnColors.ink,
        fontSize: 17,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? BillLearnColors.mainPurple : Colors.black45;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.lightPurple,
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

class _RawBodyPreview extends StatelessWidget {
  const _RawBodyPreview({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.softGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          body,
          style: const TextStyle(
            color: BillLearnColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ReasonCode extends StatelessWidget {
  const _ReasonCode({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BillLearnColors.softGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            color: BillLearnColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
