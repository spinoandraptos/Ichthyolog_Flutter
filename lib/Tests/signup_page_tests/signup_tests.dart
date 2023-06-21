import 'dart:math';
import 'package:test/test.dart';
import '../../Helpers/http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //brand new user sign up with unique username and email
  test('Test user should successfully sign up', () {
    int testerNumber = Random().nextInt(200);
    Future signupFuture = httpHelpers.signupRequest(
        'AutomatedTester$testerNumber',
        'AutomatedTester$testerNumber!!!',
        'automatedTester$testerNumber@gmail.com');
    signupFuture.then(
      (response) {
        expect(response, 'Signup Successful');
      },
    );
    expect(signupFuture, completes);
  });

  //user signs up with existing username
  test('Test user should fail to sign up', () {
    int testerNumber = Random().nextInt(200);
    Future signupFuture = httpHelpers.signupRequest(
        'tester7',
        'AutomatedTester$testerNumber!!!',
        'automatedTester$testerNumber@gmail.com');
    signupFuture.then(
      (response) {
        expect(response, 'Signup Failed');
      },
    );
    expect(signupFuture, completes);
  });

  //user signs up with existing email
  test('Test user should fail to sign up', () {
    int testerNumber = Random().nextInt(200);
    Future signupFuture = httpHelpers.signupRequest(
        'AutomatedTester$testerNumber',
        'AutomatedTester$testerNumber!!!',
        'tester8@gmail.com');
    signupFuture.then(
      (response) {
        expect(response, 'Signup Failed');
      },
    );
    expect(signupFuture, completes);
  });
}
