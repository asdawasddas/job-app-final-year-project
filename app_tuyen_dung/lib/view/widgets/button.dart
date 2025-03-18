import 'package:flutter/material.dart';

import '../../utils/enums.dart';



class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onPressFunction, required this.label, required this.type});
  final VoidCallback? onPressFunction;
  final String label;
  final ButtonType type;


  @override
  Widget build(BuildContext context){
    return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300,40),
                  backgroundColor: type.color,
                ),
                onPressed: onPressFunction,
                child:  Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
  }
}
