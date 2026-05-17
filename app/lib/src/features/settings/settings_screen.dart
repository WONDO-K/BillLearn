import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/domain/models/raw_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        _CollectionDiagnosticsCard(rawNotifications: rawNotifications),
      ],
    );
  }
}

class _CollectionDiagnosticsCard extends StatelessWidget {
  const _CollectionDiagnosticsCard({required this.rawNotifications});

  final AsyncValue<List<RawNotification>> rawNotifications;

  @override
  Widget build(BuildContext context) {
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
