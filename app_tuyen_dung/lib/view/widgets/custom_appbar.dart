

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/provider/account_provider.dart';
import '../../viewmodel/provider/enterprise_provider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    return SliverAppBar(
                backgroundColor: Colors.blueGrey.shade900,
                // toolbarHeight: 100.0 + kToolbarHeight,
                toolbarHeight: kToolbarHeight + 20,
                pinned: false,
                centerTitle: true,
                floating: true,
                title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.menu,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () {},
                        // ),
                        // Text('Home'),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.notifications,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () {},
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(25), // Image radius
                                    child: Image(
                                      image:  (accountProvider.model.avatarUrl == '') ?
                                        const AssetImage('assets/images/user_avatar.png') :
                                        NetworkImage(accountProvider.model.avatarUrl) as ImageProvider,
                                      fit: BoxFit.cover, 
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const Image(
                                          image: AssetImage('assets/images/user_avatar.png'),
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      ),
                                  ),),),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(
                                  accountProvider.model.fullName,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  )),
                              ),
                              Text(
                                enterpriseProvider.model.name,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child:Chip(
                      label: Text(accountProvider.model.status, style: TextStyle(fontSize: 7, color: Colors.amber.shade100),),
                      backgroundColor: Colors.blueGrey.shade900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6)), side: BorderSide(width: 0.5, color: Colors.amber.shade200)),
                    )
                  ),
                ],
                
                leading: null,
                // leading: Padding(
                //     padding: const EdgeInsets.only(left: 5),
                //     child: IconButton(
                //       icon: const Icon(
                //         Icons.menu,
                //         color: Colors.white,
                //       ),
                //       tooltip: "Menu",
                //       onPressed: () {},
                //     ),
                //   ),
            );
  }
}