
import 'package:flutter/material.dart';
import 'package:job_app_admin/data/model/hirer_model.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.model});
  final HirerModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5), // Border width
      decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
      child: ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(50), // Image radius
          child: Image(
            image:  (model.avatarUrl == '') ?
              const AssetImage('assets/images/user_avatar.png') :
              NetworkImage(model.avatarUrl) as ImageProvider,
            fit: BoxFit.cover, 
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return const Image(
                image: AssetImage('assets/images/user_avatar.png'),
                fit: BoxFit.cover,
              );
            },
            ),
        ),
      ),);
  }
  
}