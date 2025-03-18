
import 'package:flutter/material.dart';

class LogoCard extends StatelessWidget{
  const LogoCard({super.key, required this.logoUrl});
  final String logoUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(3), // Border width
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0),),
          color: Colors.blue.shade200, 
          shape: BoxShape.rectangle,
          ),
        child: SizedBox.fromSize(
          size: const Size.fromRadius(75), // Image radius
          child: Image(
            image:  (logoUrl == '') ?
              const AssetImage('assets/images/enterprise_logo.png') :
              NetworkImage(logoUrl) as ImageProvider,
            fit: BoxFit.cover, 
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Image(
                image: AssetImage('assets/images/enterprise_logo.png'),
                fit: BoxFit.cover,
              );
            },
            ),
        ),),
    );
}}
