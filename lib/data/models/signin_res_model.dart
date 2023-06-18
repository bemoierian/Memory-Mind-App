class SignInResModel {
  String? token;
  String? userId;
  String? name;
  double? usedStorage;
  String? message;

  SignInResModel(
      {this.token, this.userId, this.name, this.usedStorage, this.message});

  SignInResModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['userId'];
    name = json['name'];
    usedStorage = json['usedStorage'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['message'] = this.message;
    data['name'] = this.name;
    data['usedStorage'] = this.usedStorage;
    return data;
  }
}
