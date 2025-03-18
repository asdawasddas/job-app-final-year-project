import 'package:flutter/material.dart';


class CustomDropdownBtn extends StatelessWidget {
  const CustomDropdownBtn({super.key, required this.onChangeF, required this.label, required this.value, required this.values, required this.icon});
  final Function(String?)? onChangeF;
  final String label;
  final value;
  final values;
  final IconData? icon;


  @override
  Widget build(BuildContext context){
    return 
      Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      value: value,
                      items: values,
                      isExpanded: true,
                      menuMaxHeight: 300,

                      // validator: Validator.notNull,
                      style: const TextStyle(fontSize: 10, color: Colors.black),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red.shade200, fontSize: 7),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(icon, color: Colors.green,)),
                        labelStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                        floatingLabelStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))), 
                        labelText: label),
                      onChanged: onChangeF),
                  ),
                );
  }
}
