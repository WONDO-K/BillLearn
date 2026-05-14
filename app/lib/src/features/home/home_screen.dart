import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text(
          '이번 달 실제 지출',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Text('0원', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
        SizedBox(height: 24),
        Text(
          '확인 필요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text('아직 확인할 거래가 없어요'),
            subtitle: Text('결제 알림과 문자를 수집하면 여기에 표시됩니다.'),
          ),
        ),
        SizedBox(height: 24),
        Text(
          '최근 내역',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text('정리된 지출이 없습니다'),
            subtitle: Text('실제 지출로 확정된 거래만 표시됩니다.'),
          ),
        ),
      ],
    );
  }
}
