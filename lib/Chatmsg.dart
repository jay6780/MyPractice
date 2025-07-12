class Chatmsg {
  final bool isUser;
  final String message;

  Chatmsg(this.isUser, this.message);

  Map<String, dynamic> toJson() => {
        'isUser': isUser,
        'message': message,
      };

  factory Chatmsg.fromJson(Map<String, dynamic> json) =>
      Chatmsg(json['isUser'], json['message']);
}
