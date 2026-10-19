import 'package:flutter_test/flutter_test.dart';
import 'package:subiz_app/main.dart';

void main() {
  testWidgets('Subiz login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SubizApp());

    expect(find.text('subiz'), findsOneWidget);
    expect(find.text('CHÀO MỪNG ĐẾN VỚI SUBIZ'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
    expect(find.text('ĐĂNG NHẬP'), findsOneWidget);
    expect(find.text('Quên mật khẩu?'), findsOneWidget);
    expect(find.text('ĐĂNG KÝ TÀI KHOẢN'), findsOneWidget);
    expect(find.text('Đăng ký ngay'), findsOneWidget);
  });
}
