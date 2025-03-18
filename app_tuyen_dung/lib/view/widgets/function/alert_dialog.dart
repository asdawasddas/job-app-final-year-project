
import 'package:flutter/material.dart';

enum AlertType {
  success(Icons.check_circle,Colors.green),
  error(Icons.error_rounded, Colors.red),
  alert(Icons.priority_high_rounded, Colors.orange);

  final MaterialColor color;
  final IconData icon;

  const AlertType(this.icon, this.color);
}
showAlertDialog(AlertType type, String msg, BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Icon(
                  type.icon,
                  color: type.color,
                  size: 30,
                ),
              ),
              Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11),),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}