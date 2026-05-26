import 'package:billlearn/src/features/shared/merchant_visuals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps known merchant aliases through catalog fallback', () {
    expect(MerchantVisual.from('배민라이더스', null).label, '배민');
    expect(MerchantVisual.from('Starbucks Coffee', null).label, '★');
    expect(MerchantVisual.from('NAVER PAY', null).label, 'N');
    expect(MerchantVisual.from('쿠팡이츠', null).label, 'c');
    expect(MerchantVisual.from('동백전 충전', null).label, '동');
  });

  testWidgets('renders merchant mark fallback label before logo assets exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MerchantMark(merchantName: '스타벅스', categoryId: 'cafe'),
        ),
      ),
    );

    expect(find.text('★'), findsOneWidget);
  });
}
