class UpdateProfilePictureResModel {
  String? message;
  String? profilePictureURL;

  UpdateProfilePictureResModel({this.message, this.profilePictureURL});

  UpdateProfilePictureResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    profilePictureURL = json['profilePictureURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['profilePictureURL'] = this.profilePictureURL;
    return data;
  }
}
