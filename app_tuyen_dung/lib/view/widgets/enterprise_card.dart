
import 'package:app_tuyen_dung/data/models/enterprise_model.dart';
import 'package:app_tuyen_dung/view/widgets/icon_button.dart';
import 'package:app_tuyen_dung/viewmodel/provider/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/base/status_model.dart';
import 'forms/confirm_form.dart';
import 'function/alert_dialog.dart';
import 'text_span.dart';

class EnterpriseCard extends StatelessWidget {
  const EnterpriseCard({ super.key, required this.model});
  final EnterpriseModel model;
  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        CustomTextSpan(title: 'Mã số thuế: ', value: model.taxCode),
                      ],
                    ))
                ],
              ),
              Center(
                child: CustomIconButton(
                  label: (accountProvider.model.enterpriseId == model.id) ? 'Bỏ chọn doanh nghiệp' : 'Chọn doanh nghiệp', 
                  icon: Icon(
                    (accountProvider.model.enterpriseId == model.id) ? Icons.delete : Icons.business_center_outlined,
                    color: (accountProvider.model.enterpriseId == model.id) ? Colors.red.shade300 : Colors.green
                  ),
                  onPressFunction: () {
                    if (accountProvider.model.isBlocked) {
                      showAlertDialog(AlertType.alert, 'Bạn đã bị chặn, vui lòng liên hệ với bộ phận hỗ trợ', context);
                    } else {
                      showDialog(context: context, builder: (context) => 
                        Dialog(
                          child: ConfirmForm(
                            label: (accountProvider.model.enterpriseId == '') ?
                              'Chọn doanh nghiệp này làm doanh nghiệp hoạt động?' : ((accountProvider.model.enterpriseId == model.id)) ?
                              'Loại bỏ thông tin doanh nghiệp đang hoạt động sẽ đóng tất cả các tin tuyển dụng đang mở?, bạn vẫn muốn thay đổi?' :
                              'Thay đổi thông tin doanh nghiệp đang hoạt động sẽ đóng tất cả các tin tuyển dụng đang mở?, bạn vẫn muốn thay đổi?'
                            , 
                            buttonLabel: 'Xác nhận',
                            isDelete: false,
                            onPressFunction: () {
                              Map<String, dynamic> updateData = {
                                'enterprise_id' : (accountProvider.model.enterpriseId == model.id) ? '' : model.id
                              };
                              Future<Status> status = accountProvider.updateInfo(updateData);
                              status.then((value) {
                                if (value.isSuccess) {
                                  showAlertDialog(AlertType.success, 'Cập nhật thành công', context);
                                } else {
                                  showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                                }
                              });
                              Navigator.pop(context);
                            },
                            ),
                        ));
                    }
                  },
                ),
              )
            ],
          ),
        )
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



                        