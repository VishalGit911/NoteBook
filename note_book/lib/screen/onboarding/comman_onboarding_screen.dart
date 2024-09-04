import 'package:flutter/material.dart';

Widget onBoardingCommonScreen(
    String imageurl, String title, String decsrption) {
  return Padding(
    padding: const EdgeInsets.all(30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image(
            image: AssetImage(imageurl),
            height: 250,
            width: 250,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                fontFamily: "Platypi",
                color: Color(0xff2e86c1)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            decsrption,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "JosefinSans",
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}
