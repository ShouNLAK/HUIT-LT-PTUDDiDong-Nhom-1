import 'package:flutter_test/flutter_test.dart';
import 'package:huit_lt_ptuddidong_nhom_1/main.dart';

void main() {
  testWidgets('Kiem tra khoi chay MainHubScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('JobConnect - Tiến độ các TV'), findsOneWidget);
    expect(find.text('Thành viên 4 (TV4)'), findsOneWidget);
    expect(find.text('Thành viên 5 (TV5)'), findsOneWidget);
  });
}
