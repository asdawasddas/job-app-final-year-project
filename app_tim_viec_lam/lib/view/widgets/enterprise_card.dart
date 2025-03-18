

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/enterprise_model.dart';
import '../../viewmodel/providers/account_provider.dart';
import '../Enterprise/enterprise_detail_view.dart';
import 'function/alert_dialog.dart';
import 'icon_button.dart';
import 'text_span.dart';

class EnterpriseCard extends StatelessWidget {
  const EnterpriseCard({ super.key, required this.model});
  final EnterpriseModel model;
  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterpriseDetailView(enterpriseId: model.id,)));
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints(
            minHeight: 100
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),),
            border: Border.all(
              color: Color.fromARGB(255, 250, 250, 250),
              width: 2,),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(100, 0, 0, 0),
                blurRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:  [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        padding: const EdgeInsets.all(2), // Border width
                        decoration: BoxDecoration(color: Colors.blue.shade100),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(35), // Image radius
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
                            },),)
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CardTitle(title: model.name, ),
                          CustomTextSpan(title: 'Lĩnh vực: ', value: model.industry),
                        ],
                      ))
                  ],
                ),
                Center(
                  child: Row(
                    children: [Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CustomIconButton(
                          label: (accountProvider.isFavEnterprise(model.id)) ? 'Đang theo dõi' : 'Theo dõi ngay', 
                          icon: Icon(
                            (accountProvider.isFavEnterprise(model.id)) ? Icons.check : Icons.add,
                            color: (accountProvider.isFavEnterprise(model.id)) ? Colors.blue : Colors.green
                          ),
                          onPressFunction: () {
                            if (accountProvider.applicantId == '') {
                              showAlertDialog(AlertType.alert, 'Vui lòng đăng nhập để tiếp tục', context);
                            } else {
                              accountProvider.toggleAddEnterPrise(model.id);
                            }
                          },
                        ),
                      ),
                    )],
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({super.key, required this.title,});
  final String title;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: 
        Text(
              textAlign: TextAlign.left,
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 8.5,fontWeight: FontWeight.bold,),
            ),
    );
  }
}



                        