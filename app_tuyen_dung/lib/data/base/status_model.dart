class Status<T> {
  bool isSuccess;
  T? data;
  String failMsg;

  Status({required this.isSuccess, this.data, this.failMsg = ''});
}