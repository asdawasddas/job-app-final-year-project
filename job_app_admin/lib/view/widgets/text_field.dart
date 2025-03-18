import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key, required this.controller, 
    this.label, this.validator, 
    this.icon, this.editable = true, 
    this.isNumKeyboard = false, 
    this.onChangedFunction, this.hintText,
    this.onTapFunction
  });

  final TextEditingController? controller;
  final String? label;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool editable;
  final bool isNumKeyboard;
  final Function(String)? onChangedFunction;
  final String? hintText;
  final Function()? onTapFunction;

  @override
  Widget build(BuildContext context){
    return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 25),
                    scrollPadding: const EdgeInsets.all(30),
                    readOnly: !editable,
                    onChanged: onChangedFunction,
                    keyboardType: isNumKeyboard ? TextInputType.number : null,
                    validator: validator,
                    maxLines: null,
                    controller: controller,
                    onTap: onTapFunction,
                    decoration:  InputDecoration(
                      labelText: label,
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                      errorStyle: TextStyle(color: Colors.red.shade200, fontSize: 20),
                      errorMaxLines: null,

                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),

                      prefixIcon: (icon != null) ? Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          icon,
                          color: Colors.green,
                        )) : null,
                      labelStyle: const TextStyle(
                        fontSize: 25,
                        // color: Colors.black87,
                        color: Colors.green,
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontSize: 25,
                        // color: Colors.black87,
                        color: Colors.green,
                        fontWeight: FontWeight.bold
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))), 
                      ),
                    onTapOutside: (event) => {
                      FocusScope.of(context).unfocus()
                    },
                  ),
                );
  }
}