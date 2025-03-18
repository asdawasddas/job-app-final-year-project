// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomText extends StatelessWidget{
  const CustomText({super.key, required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
              child: Text(
                value,
                textAlign: TextAlign.start,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 8.5,
                  color: Colors.black,
                ),),
              );
  }
}