import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget{
  const CustomTitle({super.key, required this.label , this.isCenter = false});
  final String label;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.only(left: 8,right: 8, top: 13, bottom: 6),
              child: Align(
                alignment: isCenter ? Alignment.center : Alignment.centerLeft , 
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),);
  }
}