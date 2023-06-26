class VerifyEmailReqModel {
  String? userId;
  String? signUpCode;

  VerifyEmailReqModel({this.userId, this.signUpCode});

  VerifyEmailReqModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    signUpCode = json['signUpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['signUpCode'] = this.signUpCode;
    return data;
  }
}
