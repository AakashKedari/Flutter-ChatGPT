class ChatModel {
  final String msg;
  final int chatIndex;
   bool isFavourite;


  ChatModel({required this.msg, required this.chatIndex,required this.isFavourite,});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json["msg"],
        chatIndex: json["chatIndex"],
        isFavourite: false,
      );
}
