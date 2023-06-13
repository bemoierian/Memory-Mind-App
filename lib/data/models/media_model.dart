class MediaModel {
  String? message;
  List<Media>? media;
  int? totalItems;

  MediaModel({this.message, this.media, this.totalItems});

  MediaModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    totalItems = json['totalItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['totalItems'] = this.totalItems;
    return data;
  }
}

class Media {
  String? sId;
  String? title;
  String? content;
  String? fileUrl;
  String? fileType;
  String? creator;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Media(
      {this.sId,
      this.title,
      this.content,
      this.fileUrl,
      this.fileType,
      this.creator,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Media.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    content = json['content'];
    fileUrl = json['fileUrl'];
    fileType = json['fileType'];
    creator = json['creator'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['fileUrl'] = this.fileUrl;
    data['fileType'] = this.fileType;
    data['creator'] = this.creator;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
