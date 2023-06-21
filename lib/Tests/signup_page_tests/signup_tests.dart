import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import '../../Helpers/http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test('Test user should successfully sign up', () {
    int testerNumber = Random().nextInt(20);
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
}
