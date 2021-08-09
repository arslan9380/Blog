class BlogModel {
  String id;
  String title;
  String body;
  DateTime timeOfBlog;
  dynamic image;

  BlogModel({this.id, this.title, this.body, this.timeOfBlog, this.image});

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return new BlogModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      timeOfBlog: map['timeOfBlog'] as DateTime,
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'title': this.title,
      'body': this.body,
      'timeOfBlog': this.timeOfBlog,
      'image': this.image,
    } as Map<String, dynamic>;
  }
}
