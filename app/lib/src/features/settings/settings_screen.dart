import 'package:billlearn/src/app/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAccess = ref.watch(notificationAccessEnabledProvider);
    final smsPermission = ref.watch(smsPermissionGrantedProvider);

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
