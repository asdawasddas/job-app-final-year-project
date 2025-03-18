import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget{
  const CustomPasswordField({super.key, required this.controller, required this.label, this.validator});
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context){
    return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                  child: TextFormField(
                    controller: widget.controller,
                    validator: widget.validator,
                    obscureText: isObscured,
                    style: const TextStyle(fontSize: 25),
                    decoration:  InputDecoration(
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      prefixIcon: const Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: Icon(
                          Icons.lock,
                          color: Colors.green,
                      )),
                      suffixIcon: GestureDetector(
                        onTap: () => {
                          setState(() {
                            isObscured = !isObscured;
                          })
                        },
                        child: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(
                            isObscured ? Icons.visibility_off : Icons.visibility,
                            color: Colors.green,
                        )),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 25,
                        color: Colors.green,
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontSize: 25,
                        color: Colors.green,
                        fontWeight: FontWeight.bold
                      ),
                      errorStyle: TextStyle(color: Colors.red.shade200, fontSize: 20),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))), 
                      labelText: widget.label),
                    onTapOutside: (event) => {
                      FocusScope.of(context).unfocus()
                    },
                  ),
                );
  }
}