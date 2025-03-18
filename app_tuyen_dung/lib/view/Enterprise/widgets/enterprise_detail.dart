
import 'package:app_tuyen_dung/view/Enterprise/forms/enterprise_info_form.dart';
import 'package:app_tuyen_dung/view/widgets/expand_btn.dart';
import 'package:app_tuyen_dung/view/widgets/icon_text.dart';
import 'package:app_tuyen_dung/viewmodel/provider/enterprise_provider.dart';
import 'package:app_tuyen_dung/view/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../viewmodel/provider/account_provider.dart';
import '../../widgets/container.dart';
import '../../widgets/forms/confirm_form.dart';
import '../../widgets/function/alert_dialog.dart';
import 'logo_card.dart';

class EnterpriseDetail extends StatelessWidget {
  const EnterpriseDetail({Key? key}) : super (key : key);

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 110, 139, 201),
      appBar: AppBar(
        title: const Text('Thông tin doanh nghiệp', style: TextStyle(fontSize: 16),),
        backgroundColor: Colors.blue.shade200,
      ),
      body: SingleChildScrollView(
          child: CustomContainer(
            child: Column(
              children: [
                LogoCard(model : enterpriseProvider.model),
                const CustomTitle(label: 'Thông tin doanh nghiệp'),
                Column(
                  children: [
                    IconText(label: 'Tên doanh nghiệp:', icon: Icons.business, value: enterpriseProvider.model.name),
                    IconText(label: 'Mã số thuế:', icon: Icons.payment_outlined, value: enterpriseProvider.model.taxCode),
                    IconText(label: 'Email doanh nghiệp:', icon: Icons.email, value: enterpriseProvider.model.email),
                    IconText(label: 'Số điện thoại doanh nghiệp:', icon: Icons.phone, value: enterpriseProvider.model.phoneNumber),
                    IconText(label: 'Lĩnh vực kinh doanh:', icon: Icons.factory, value: enterpriseProvider.model.industry),
                    IconText(label: 'Quy mô nhân sự:', icon: Icons.people, value: enterpriseProvider.model.employeeAmount),
                    IconText(label: 'Địa chỉ:', icon: Icons.location_on, value: enterpriseProvider.model.address),
                    IconText(label: 'Giới thiệu doanh nghiệp:', icon: Icons.info, value: enterpriseProvider.model.infomation),
                  ]),
                Row(
                  children: [
                    Expanded(
                      child: ExpandButton(
                        label: 'Bỏ chọn',
                        type: ButtonType.delete,
                        onPressFunction: () {
                          if (accountProvider.model.isBlocked) {
                            showAlertDialog(AlertType.alert, 'Bạn đã bị chặn, vui lòng liên hệ với bộ phận hỗ trợ', context);
                          } else {
                            showDialog(context: context, builder: (context) => 
                              Dialog(
                                child: ConfirmForm(
                                  label: 'Loại bỏ thông tin doanh nghiệp đang hoạt động sẽ đóng tất cả các tin tuyển dụng đang mở?, bạn vẫn muốn thay đổi?',
                                  buttonLabel: 'Xác nhận',
                                  isDelete: false,
                                  onPressFunction: () {
                                    Future<Status> status = accountProvider.updateInfo({ 'enterprise_id' : '' });
                                    status.then((value) {
                                      if (value.isSuccess) {
                                        Navigator.pop(context);
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
                      )
                    ),
                    Expanded(
                      child: ExpandButton(
                        label: 'Cập nhật',
                        type: ButtonType.confirm,
                        onPressFunction: () {
                          if (accountProvider.model.isBlocked) {
                            showAlertDialog(AlertType.alert, 'Bạn đã bị chặn, vui lòng liên hệ với bộ phận hỗ trợ', context);
                          } else if (accountProvider.model.statusInt == 1 || accountProvider.model.statusInt ==0 ) {
                            showAlertDialog(AlertType.alert, 'Bạn chưa được xác nhận là nhân viên doanh nghiệp này, vui lòng liên hệ với bộ phận hỗ trợ', context);
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterpriseInfoForm()));
                          }
                        },
                      )
                    )
                  ],
                )
              ]
              ),
          ),
        ),
    );
  }}