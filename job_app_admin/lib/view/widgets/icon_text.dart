// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class IconText extends StatelessWidget{
  const IconText({super.key, required this.label, required this.icon, required this.value});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                    child: Icon(
                      icon,
                      color: Colors.blue,
                      size: 25,),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: null,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold
                          ),),
                        Text(
                          value,
                          maxLines: null,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),),
                      ] 
                    ),
                  ),
                ],
              ));
  }
}