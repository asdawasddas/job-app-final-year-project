
import 'package:flutter/material.dart';

import '../../../utils/enums.dart';
import '../expand_btn.dart';

class ConfirmForm extends StatelessWidget {
  const ConfirmForm({super.key, this.isDelete = false, required this.label, required this.buttonLabel, this.onPressFunction});
  final bool isDelete;
  final String label;
  final String buttonLabel;
  final VoidCallback? onPressFunction;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isDelete ? const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Icon(
                  Icons.priority_high_rounded,
                  color: Colors.orange,
                  size: 30,
                ),
              ) : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 11
                ),
                ),
            ),
            Row(
              children: [
                Expanded(child: ExpandButton(label: 'Cancel', type: ButtonType.cancel, onPressFunction: () { Navigator.pop(context);},)),
                Expanded(child: ExpandButton(label: buttonLabel, type: isDelete ? ButtonType.delete : ButtonType.confirm, onPressFunction: onPressFunction,)),
              ],
            )
          ],
        ),
      ),
    );

    // TODO: implement build
    // throw UnimplementedError();
  }
  
}