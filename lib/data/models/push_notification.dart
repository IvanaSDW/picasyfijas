

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.data,
  });
  String? title;
  String? body;
  Map<String, dynamic>? data;

  toJson() => {
    'title' : title,
    'body' : body,
    'data' : data
  };
}
