import 'package:flutter/material.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({super.key, this.onPressFunction, required this.label, required this.loading});
  final VoidCallback? onPressFunction;
  final String label;
  final bool loading;


  @override
  Widget build(BuildContext context){
    return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40.0),
                  backgroundColor: Colors.green,
                ),
                onPressed: loading ? null : onPressFunction,
                child: loading ? const CircularProgressIndicator() : 
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
  }
}