import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:chatgpt/widgets/dropdown.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../provider/models_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/chat_logo.png')),
        ),
        title: const Text(
          'ChatGPT',
          style: TextStyle(color: Colors.greenAccent),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  backgroundColor: scaffoldBackgroundColor,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Flexible(
                              child: TextWidget(
                            label: "Choose Model",
                            fontSize: 16,
                          )),
                          Flexible(flex: 2, child: DropDownWidget()),
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.more_vert_rounded),
            color: Colors.white,
          )
        ],
      ),
      body: SafeArea(
          child: Column(children: [
        Flexible(
          //if we dont use flexible here, it will show us a error saying vertical height unbounded
          child: ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              return ChatWidget(
                msg: chatList[index].msg,
                chatIndex: chatList[index].chatIndex,
              );
            },
          ),
        ),
        if (isTyping) ...[
          //we use three dots here so that we can add multiple widgets inside a single if statement
          const SpinKitThreeBounce(
            color: Colors.white,
            size: 18,
          ),
        ],
        const SizedBox(
          height: 15,
        ),
        Material(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: textEditingController,
                    onSubmitted: (value) async {
                      await sendMessageFCT(modelsProvider);
                    },
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can I Help you Buddy???",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await sendMessageFCT(modelsProvider);
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                )
              ],
            ),
          ),
        )
      ])),
    );
  }

  Future<void> sendMessageFCT(ModelProvider modelsProvider) async {
    setState(() {});
    try {
      setState(() {
        isTyping = true;
      });
      chatList = await ApiService.sendMessage(
          modelId: textEditingController.text,
          message: modelsProvider.getcurrentModel);
      await ApiService.sendMessage(
        modelId: modelsProvider.getcurrentModel,
        message: textEditingController.text,
      );
      setState(() {});
    } catch (error) {
      log('error chatscreenwala $error');
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }
}
