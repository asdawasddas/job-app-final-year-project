import 'package:flutter/material.dart';

import '../../utils/enums.dart';

class ExpandButton extends StatelessWidget {
  const ExpandButton({super.key, this.onPressFunction, required this.label, required this.type, this.isPadding = true});
  final VoidCallback? onPressFunction;
  final String label;
  final ButtonType type;
  final bool isPadding;


  @override
  Widget build(BuildContext context){
    return Padding(
      padding: isPadding ? const EdgeInsets.fromLTRB(5, 10, 5, 10) : const EdgeInsets.all(0),
      child: ElevatedButton(
        onPressed: onPressFunction,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          backgroundColor: type.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),)
        ), 
        child: Text(
          label, 
          maxLines: 1,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            ),),
        ),
    );
  }
}