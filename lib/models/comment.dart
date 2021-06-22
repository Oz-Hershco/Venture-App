class Comment {
  final String id;
  final DateTime time;
  final String userId;
  final String text;

  Comment({
    this.id,
    this.text,
    this.time,
    this.userId,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        time = DateTime.parse(json['time']),
        userId = json['userId'];
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'time': time,
      'userId': userId,
    };
  }
}
