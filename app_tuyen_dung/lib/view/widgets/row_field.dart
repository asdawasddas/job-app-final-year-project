import 'package:flutter/material.dart';

class RowField extends StatelessWidget{
  const RowField({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  
  @override
  Widget build(BuildContext context){
    return 
      Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
                )),
        
              WidgetSpan(
                child: IntrinsicWidth(
                  child: child
                )
                )
            ]
          )),
      );
  }
}