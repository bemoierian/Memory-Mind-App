class DeleteMediaResModel {
  String? message;
  double? usedStorage;

  DeleteMediaResModel({this.message, this.usedStorage});

  DeleteMediaResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    usedStorage = json['usedStorage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['usedStorage'] = this.usedStorage;
    return data;
  }
}
