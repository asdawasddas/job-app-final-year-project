import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key, required this.label, required this.icon, this.onPressFunction});
  final String label;
  final Icon icon;
  final VoidCallback? onPressFunction;

  @override
  Widget build(BuildContext context){
    return 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,),
        child: TextButton.icon(
          label: Text(label, style: const TextStyle(color: Colors.black, fontSize: 20),), 
          onPressed: onPressFunction, 
          icon: icon,
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),)
            ),
          )
      );
  }
}