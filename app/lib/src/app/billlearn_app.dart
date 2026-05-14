import 'package:billlearn/src/app/app_router.dart';
import 'package:billlearn/src/app/app_theme.dart';
import 'package:flutter/material.dart';

class BillLearnApp extends StatelessWidget {
  const BillLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BillLearn',
      theme: buildBillLearnTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
