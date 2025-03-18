import 'package:flutter/material.dart';

class CustomTextSpan extends StatelessWidget {
  const CustomTextSpan({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context){
    return 
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,),
        child: RichText(
          maxLines: null,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$title ',
                style: const TextStyle(color: Colors.black, fontSize: 16),),
              TextSpan(
                text: value,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ]
          ))
      );
  }
}