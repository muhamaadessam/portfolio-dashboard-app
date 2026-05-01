class AlertModel {
  String? title;
  String? content;
  String? media;

  AlertModel({this.title, this.content, this.media});

  AlertModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    media = json['media'];
  }
}
