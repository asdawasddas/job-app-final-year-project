import 'package:app_tim_viec_lam/data/model/applicant_model.dart';
import 'package:flutter/material.dart';

import 'camera_icon.dart';


class AccountCard extends StatelessWidget{
  const AccountCard({super.key, required this.model});
  final Applicant model;

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 5.0,
                      minWidth: 200
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(100, 0, 0, 0),
                              blurRadius: 5,
                            ),],
                        ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12), // Border width
                                  decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(65), // Image radius
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
                                  ),),
                                const CameraIcon()
                                ],
                            ),
                          ),
                      
                           Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              model.fullName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                              fontSize: 14.0,
                              ),),
                          ),
                        ]
                      ),
                    ),
                  ),
                );
}}
