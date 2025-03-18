import 'package:app_tuyen_dung/data/models/enterprise_model.dart';
import 'package:flutter/material.dart';

import 'camera_icon.dart';



class LogoCard extends StatelessWidget{
  const LogoCard({super.key, required this.model});
  final EnterpriseModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(25), // Border width
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.0),),
              color: Colors.blue.shade50, 
              shape: BoxShape.rectangle,
              ),
            child: SizedBox.fromSize(
              size: const Size.fromRadius(75), // Image radius
              child: Image(
                image:  (model.logoUrl == '') ?
                  const AssetImage('assets/images/enterprise_logo.png') :
                  NetworkImage(model.logoUrl) as ImageProvider,
                fit: BoxFit.cover, 
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const Image(
                    image: AssetImage('assets/images/enterprise_logo.png'),
                    fit: BoxFit.cover,
                  );
                },
                ),
            ),),
            const CameraIcon()
          ],
      ),
    );
}}
