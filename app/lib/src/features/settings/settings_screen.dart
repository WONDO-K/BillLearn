import 'package:billlearn/src/app/app_providers.dart';
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
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '설정',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '알림 접근 권한',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _PermissionStatusChip(access: notificationAccess),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('카드 앱, 간편결제 앱의 결제 알림을 자동으로 읽기 위해 필요합니다.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    await ref
                        .read(androidEventBridgeProvider)
                        .openNotificationAccessSettings();
                    ref.invalidate(notificationAccessEnabledProvider);
                  },
                  child: const Text('설정 열기'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'SMS 권한',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _PermissionStatusChip(access: smsPermission),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('카드 승인 문자와 결제 문자를 자동 수집하기 위해 필요합니다.'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    await ref
                        .read(androidEventBridgeProvider)
                        .requestSmsPermission();
                    ref.invalidate(smsPermissionGrantedProvider);
                  },
                  child: const Text('SMS 권한 요청'),
                ),
              ],
            ),
          ),
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

class _DebugToolsCard extends ConsumerWidget {
  const _DebugToolsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '개발자 도구',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text('에뮬레이터 UI 확인용 샘플 거래를 생성합니다.'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await ref.read(seedDebugSampleDataProvider).call();
                ref.invalidate(expensesProvider);
                ref.invalidate(rawNotificationsProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('샘플 거래를 생성했습니다')),
                  );
                }
              },
              child: const Text('샘플 거래 생성'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionDiagnosticsCard extends ConsumerWidget {
  const _CollectionDiagnosticsCard({required this.rawNotifications});

  final AsyncValue<List<RawNotification>> rawNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: rawNotifications.when(
          data: (items) {
            final latest = [...items]
              ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '수집 진단',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text('최근 수집 ${items.length}건'),
                const SizedBox(height: 12),
                if (latest.isEmpty)
                  const Text('아직 수집된 원천 알림이 없습니다.')
                else ...[
                  const Text(
                    '마지막 수집',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(latest.first.body),
                  const SizedBox(height: 12),
                  _LatestProcessingDiagnostics(raw: latest.first),
                ],
              ],
            );
          },
          loading: () => const ListTile(
            title: Text('수집 진단'),
            subtitle: Text('원천 알림 상태를 불러오는 중입니다.'),
          ),
          error: (error, stackTrace) => const ListTile(
            title: Text('수집 진단'),
            subtitle: Text('원천 알림 상태를 불러오지 못했어요.'),
          ),
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
            const SizedBox(height: 12),
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
        const Text('파싱 결과', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          '${candidate.merchantName} · ${currencyFormat.format(candidate.amount)}원',
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
        const Text('판별 결과', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          '${classification.isExpense ? '실제 지출' : '지출 제외'} · '
          '신뢰도 ${(classification.confidence * 100).round()}%',
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final reasonCode in classification.reasonCodes)
              Text(reasonCode),
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
      data: (enabled) => Chip(
        label: Text(enabled ? '켜짐' : '꺼짐'),
        visualDensity: VisualDensity.compact,
      ),
      loading: () => const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stackTrace) => const Chip(
        label: Text('확인 실패'),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
