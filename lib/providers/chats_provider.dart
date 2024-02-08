
import 'package:chatgpt/services/assets_manager.dart';
import 'package:flutter/cupertino.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0,isFavourite: false));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId,required ScrollController listScrollController}) async {

      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.easeOut);

      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,

      ));

      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.easeOut);

    notifyListeners(

    );
  }

  void alertChange(){
    notifyListeners();
  }
}
