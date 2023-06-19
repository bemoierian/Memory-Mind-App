class SignInResModel {
  String? token;
  String? userId;
  String? name;
  double? usedStorage;
  double? storageLimit;
  String? message;
  String? profilePictureURL;

  SignInResModel(
      {this.token,
      this.userId,
      this.name,
      this.usedStorage,
      this.message,
      this.storageLimit,
      this.profilePictureURL});

  SignInResModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['userId'];
    name = json['name'];
    usedStorage = json['usedStorage'];
    storageLimit = json['storageLimit'];
    message = json['message'];
    profilePictureURL = json['profilePictureURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['message'] = this.message;
    data['name'] = this.name;
    data['usedStorage'] = this.usedStorage;
    data['storageLimit'] = this.storageLimit;
    data['profilePictureURL'] = this.profilePictureURL;
    return data;
  }
}
