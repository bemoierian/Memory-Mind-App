class SignInResModel {
  String? token;
  String? userId;
  String? message;

  SignInResModel({this.token, this.userId});

  SignInResModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['userId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['message'] = this.message;
    return data;
  }
}
