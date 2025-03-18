class Validator {
  static String? enterpriseNameValidator(String? value) {
    if (notEmpty(value)) {
      return 'Tên doanh nghiệp không được để trống';
    }
    return null;
  }

  static String? taxCodeValidator(String? value) {
    if (notEmpty(value)) {
      return 'Mã số thuế không được để trống';
    }
    return null;
  }

  static String? notNull(String? value) {
    if (notEmpty(value)) {
      return 'Không được để trống';
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (notEmpty(value)) {
      return 'Họ và tên không được để trống';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    } else if (value.contains(' ')) {
      return 'Mật khẩu không được có dấu cách';
    } else if (value.length < 10 || value.length > 20) {
      return 'Mật khẩu cần ít nhất 10 ký tự và tối đa 20 ký tự';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    } else if (value.contains(' ')) {
      return 'Email không được có dấu cách';
    } else {
      final bool emailValid = RegExp(r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$").hasMatch(value);
      if (!emailValid) return 'Email không hợp lệ';
    }
    return null;
  }

  static String? accountNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên tài khoản không được để trống';
    } else if (value.contains(' ')) {
      return 'Tên tài khoản không được có dấu cách';
    } else if (value.length < 10) {
      return 'Tên tài khoản cần ít nhất 10 ký tự';
    }
    return null;
  }
  
  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được để trống';
    } else if (value.contains(' ')) {
      return 'Số điện thoại không được có dấu cách';
    } else {
      final bool emailValid = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value);
      if (!emailValid) return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  static String? amountValidator(String? value) {
    if (value != null) {
      bool amountValid = RegExp(r'^[0-9]+$').hasMatch(value);
      if (amountValid) {
        if (int.parse(value) > 0) {
          return null;
        } else {
          return 'Quy mô phải lớn hơn 0';
        }
      } else {
        return 'Quy mô là số nhân viên trong doanh nghiệp';
      }
    } else {
      return 'Quy mô không được để trống';
    }
  }

  static String? salaryValidator(String? value) {
    if (value != null && value != '') {
      bool amountValid = RegExp(r'^[0-9]+$').hasMatch(value);
      if (amountValid) {
        if (int.parse(value) >= 0) {
          return null;
        } else {
          return 'Nhập số tự nhiên';
        }
      } else {
        return 'Nhập số tự nhiên';
      }
    } else {
      return null;
    }
  }

  static String? expValidator(String? value) {
    if (value != null && value != '') {
      bool amountValid = RegExp(r'^[0-9]+$').hasMatch(value);
      if (amountValid) {
        if (int.parse(value) >= 0) {
          return null;
        } else {
          return 'Kinh nghiệm là số tự nhiên';
        }
      } else {
        return 'Kinh nghiệm là số tự nhiên';
      }
    } else {
      return null;
    }
  }

  static String? numberValidator(String? value) {
    if (value == null) {
      return 'Không được để trống';
    }
    if (value.isNotEmpty) {
      bool amountValid = RegExp(r'^[0-9]+$').hasMatch(value);
      if (amountValid) {
        if (int.parse(value) > 0) {
          return null;
        } else {
          return 'Phải lớn hơn 0';
        }
      } else {
        return 'Phải là số tự nhiên';
      }
    } else {
      return 'Không được để trống';
    }
  }

  static String? addressValidator(String? value) {
    if (notEmpty(value)) {
      return 'Địa chỉ không được để trống';
    }
    return null;
  }

  static String? industryValidator(String? value) {
    if (notEmpty(value)) {
      return 'Quy mô doanh nghiệp không được để trống';
    }
    return null;
  }
}

bool notEmpty(String? value){
  if (value == null || value.isEmpty || value.trim()=="") {
    return true;
  } else {
    return false;
  }
}