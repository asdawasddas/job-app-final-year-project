import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget{
  const CustomContainer({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(
              minHeight: 100,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),),
              border: Border.all(
                color: const Color.fromARGB(255, 106, 154, 236),
                width: 1,),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
          child: child 
          ));
  }
}