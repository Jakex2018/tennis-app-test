import 'package:com.tennis.arshh/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Courts Model Tests', () {
    test('Constructor Test', testUserConstructor);
  });
}

void testUserConstructor() {
  var user = UserProfile(
      uid: '12312',
      name: 'jose',
      phone: '312312321',
      email: 'pusugu00@gmail.com');

  expect(user.uid, '12312');
  expect(user.name, 'jose');
  expect(user.email, 'pusugu00@gmail.com');
  expect(user.phone, '312312321');
}
