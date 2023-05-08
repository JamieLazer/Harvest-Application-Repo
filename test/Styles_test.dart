import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartfactory/styles.dart';

void main() {
  test('Test text styles', () {
    expect(welcomePageText.color, Colors.white);
    expect(loginPageText.color, primaryColour);
    expect(signUpPageText.color, Colors.white);
    expect(blackText.color, Colors.black87);
    expect(secondaryColourText.color, secondaryColour);
  });

  test('Test app colors', () {
    expect(primaryColour, const Color(0xFF80A87A));
    expect(secondaryColour, const Color(0xFF4E7449));
    expect(tertiaryColour, const Color(0xFFDCF9D7));
  });

  test('Test form field style', () {
    expect(WhiteInputBorder().borderSide.color, Colors.white);
    expect(WhiteInputBorder().borderSide.width, 1.5);
  });
}
