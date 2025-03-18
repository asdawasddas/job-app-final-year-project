import 'package:flutter/material.dart';

class TitleButton extends StatelessWidget{
  const TitleButton({super.key, required this.label, this.function, required this.icon});
  final String label;
  final VoidCallback? function;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
      child: ElevatedButton(
        onPressed: function ?? (){},
        style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(icon)),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),)),
            const Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
      );
  }
}