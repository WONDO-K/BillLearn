import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavScaffold extends StatelessWidget {
  const BottomNavScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final title = switch (navigationShell.currentIndex) {
      0 => '홈',
      1 => '내역',
      2 => '설정',
      _ => 'BillLearn',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (navigationShell.currentIndex == 0)
            IconButton(
              tooltip: '알림',
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: '내역'),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
