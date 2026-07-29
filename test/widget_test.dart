import 'package:flutter_test/flutter_test.dart';

import 'package:colette/main.dart';
import 'package:colette/services/auth_service.dart';
import 'package:colette/services/post_service.dart';

void main() {
  testWidgets('Memorial home renders', (tester) async {
    final auth = AuthService();
    final posts = PostService(auth);
    await tester.pumpWidget(ColetteApp(auth: auth, posts: posts));
    await tester.pumpAndSettle();

    expect(find.textContaining('Collete Marie Williams'), findsWidgets);
  });
}
