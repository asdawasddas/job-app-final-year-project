import 'dart:io';
import 'package:app_tuyen_dung/utils/functions_util.dart';
import 'package:app_tuyen_dung/viewmodel/provider/enterprise_provider.dart';
import 'package:app_tuyen_dung/view/widgets/function/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/base/status_model.dart';
import '../../../utils/enums.dart';
import '../../../viewmodel/provider/account_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/forms/confirm_form.dart';
import '../forms/logo_url_form.dart';

class CameraIcon extends StatelessWidget {

  const CameraIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final enterpriseProvider = Provider.of<EnterpriseProvider>(context);
    return GestureDetector(
      onTap: () {
        if (accountProvider.model.isBlocked) {
          showAlertDialog(AlertType.alert, 'Bạn đã bị chặn, vui lòng liên hệ với bộ phận hỗ trợ', context);
        } else if (accountProvider.model.statusInt == 1) {
          showAlertDialog(AlertType.alert, 'Bạn chưa được xác nhận là nhân viên doanh nghiệp này, vui lòng liên hệ với bộ phận hỗ trợ', context);
        } else {
        showModalBottomSheet(
          context: context, 
          builder: (BuildContext context){
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Chọn ảnh',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)
                    ),
                  CustomButton(
                    label: 'Nhập từ Url', 
                    type: ButtonType.confirm,
                    onPressFunction: () {
                      // showUrlDialog(context);
                      showDialog(context: context, builder: (context) {return const Dialog(insetPadding: EdgeInsets.all(5), child: LogoUrlForm());});
                    },),
                  CustomButton(
                    label: 'Chọn từ bộ sưu tập', 
                    type: ButtonType.confirm,
                    onPressFunction: () async {
                      File? file = await FunctionsUtil.getImageGallery();
                      if(file != null) {
                        Future<Status>  status = enterpriseProvider.changeLogo(file);
                        status.then((value) {
                        if (value.isSuccess) {
                          showAlertDialog(AlertType.success, 'Tải logo thành công', context);
                        } else {
                          showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                        }
                      });
                      }
                    },),
                  CustomButton(
                    label: 'Máy ảnh', 
                    type: ButtonType.confirm,
                    onPressFunction: () async{
                      File? file = await FunctionsUtil.getImageCamera();
                      if(file != null) {
                        Future<Status>  status = enterpriseProvider.changeLogo(file);
                        status.then((value) {
                        if (value.isSuccess) {
                          showAlertDialog(AlertType.success, 'Tải logo thành công', context);
                        } else {
                          showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                        }
                      });
                      }
                    },),
                  CustomButton(
                    label: 'Xóa ảnh', 
                    type: ButtonType.delete,
                    onPressFunction: () async {
                      showDialog(context: context, builder: (context) => 
                        Dialog(
                          child: ConfirmForm(
                            label: 'Bạn muốn xóa logo?', 
                            buttonLabel: 'Xóa',
                            isDelete: true,
                            onPressFunction: () {
                              Future<Status>  status = enterpriseProvider.deleteLogo();
                              status.then((value) {
                                if (value.isSuccess) {
                                  showAlertDialog(AlertType.success, 'Xóa logo thành công', context);
                                } else {
                                  showAlertDialog(AlertType.error, 'Đã có lỗi xảy ra', context);
                                }
                              });
                              Navigator.pop(context);
                            },
                            ),
                        ));
                    },),
                ],),
            );
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
        child: Icon(
          Icons.camera_alt_sharp,
          color: Colors.indigo.shade900,
          size: 35,
        ),
      ));
  }
}