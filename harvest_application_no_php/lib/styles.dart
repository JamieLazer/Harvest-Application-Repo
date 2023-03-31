import 'package:flutter/material.dart';

//some text styles
const TextStyle welcomePageText = TextStyle(
  fontSize: 20,
  color: Colors.white,
  decoration: TextDecoration.none,
  fontFamily: 'AbeeZee',
  fontWeight: FontWeight.normal,
);

const TextStyle loginPageText = TextStyle(
  fontSize: 18,
  color: Color(0xFF80A87A), //primary colour
  decoration: TextDecoration.none,
  fontFamily: 'AbeeZee',
  fontWeight: FontWeight.normal,
);

const TextStyle signUpPageText = TextStyle(
  fontSize: 18,
  color: Colors.white, //primary colour
  decoration: TextDecoration.none,
  fontFamily: 'AbeeZee',
  fontWeight: FontWeight.normal,
);

const TextStyle blackText = TextStyle(
  fontSize: 14,
  color: Colors.black87, //primary colour
  decoration: TextDecoration.none,
  fontFamily: 'AbeeZee',
  fontWeight: FontWeight.normal,
);

//app colours
Color primaryColour = const Color(0xFF80A87A);
Color secondaryColour = const Color(0xFF4E7449);
Color tertiaryColour = const Color(0xFFDCF9D7);

//formfield styles
class WhiteInputBorder extends OutlineInputBorder {
  WhiteInputBorder()
      : super(
          borderSide: BorderSide(
            color: Colors.white,
          width: 1.5),
        );
}
