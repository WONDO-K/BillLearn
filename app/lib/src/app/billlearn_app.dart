import 'package:billlearn/src/app/app_router.dart';
import 'package:billlearn/src/app/app_providers.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillLearnApp extends ConsumerWidget {
  const BillLearnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(rawNotificationPipelineProvider);

    return MaterialApp.router(
      title: 'BillLearn',
      theme: buildBillLearnTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
