import 'package:billlearn/src/app/billlearn_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows BillLearn home shell', (tester) async {
    await tester.pumpWidget(const BillLearnApp());

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('이번 달 실제 지출'), findsOneWidget);
    expect(find.text('최근 내역'), findsOneWidget);
  });
}
