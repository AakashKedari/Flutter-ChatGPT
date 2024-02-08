import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/providers/chats_provider.dart';
import 'package:chatgpt/screens/favourites_screen.dart';
import 'package:chatgpt/services/assets_manager.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool _isResponseLoading = false;
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late Animation<Offset> animation;
  bool queryFlag = false;

  @override
  void initState() {
    print('Initial Scroll : ${AssetsManager.shouldScroll}');

    _listScrollController = ScrollController();
    textEditingController = TextEditingController();

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      //
      // Timer.periodic(const Duration(milliseconds: 1), (timer) {
      //     scrollListToEND();
      // });
      print(AssetsManager.shouldScroll);
      if (AssetsManager.shouldScroll)
        {
          scrollListToEND();
        }
    });
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {

    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiLogo,height: 20,width: 20,)
            // Image.asset(AssetsManager.openaiLogo),
            ),
        centerTitle: true,
        title: chatProvider.chatList.isEmpty
            ? const Text(
                "New Chat",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
              )
            : const Text(
                'AI OverView',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),
              ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Favourites()));
            },
            icon: const Icon(
              Icons.favorite_outline_rounded,
              color: Colors.white70,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: chatProvider.chatList.isNotEmpty
            ?
        Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 5,),
                  ChatsFlexWidget(
                      listScrollController: _listScrollController,
                      chatProvider: chatProvider),
                  if (_isResponseLoading) ...[
                    const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  // This Padding Widget is the TextField for the User Input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(25),
                      elevation: 20,
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Center(
                                child: TextField(
                                    onTap: () {
                                      setState(() {
                                        queryFlag = true;
                                      });
                                    },
                                    onTapOutside: (value) {
                                      setState(() {
                                        queryFlag = false;
                                      });
                                    },
                                    minLines: 1,
                                    maxLines: 10,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.top,
                                    focusNode: focusNode,
                                    style: const TextStyle(color: Colors.white),
                                    controller: textEditingController,
                                    onSubmitted: (value) async {
                                      queryFlag = false;
                                      await sendMessageFCT(

                                          chatProvider: chatProvider);
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        label: queryFlag == false
                                            ? DefaultTextStyle(
                                                style: const TextStyle(
                                                    // height: 0.6,
                                                    fontFamily: 'PTSans',
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16),
                                                child: AnimatedTextKit(

                                                    stopPauseOnTap: true,
                                                    isRepeatingAnimation: true,
                                                    repeatForever: false,
                                                    displayFullTextOnTap: true,
                                                    animatedTexts: [
                                                      ScaleAnimatedText(
                                                          'Enter Your Query',
                                                          duration:
                                                              const Duration(
                                                                  seconds: 1))
                                                    ]),
                                              )
                                            : null)),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  AssetsManager.shouldScroll = true;
                                  await sendMessageFCT(
                                      chatProvider: chatProvider);
                                },
                                icon:const Icon(Icons.search_rounded,color: Colors.greenAccent,))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            :
            // Using Stack to show animation behind to avoid Widget overflow when keyboard is opened
            Stack(
                children: [
                  // This Widget for displaying the ChatBot Animation if chatList is empty
                  Center(
                      child: Lottie.asset(
                          AssetsManager.botAnimation,
                          height: 330)),

                  Column(
                    children: [
                      ChatsFlexWidget(
                          listScrollController: _listScrollController,
                          chatProvider: chatProvider),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Material(
                          borderRadius: BorderRadius.circular(25),
                          elevation: 20,
                          color: cardColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: TextField(
                                        onTap: () {
                                          setState(() {
                                            queryFlag = true;
                                          });
                                        },
                                        onTapOutside: (value) {
                                          setState(() {
                                            queryFlag = false;
                                          });
                                        },
                                        minLines: 1,
                                        maxLines: 10,
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        focusNode: focusNode,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: textEditingController,
                                        onSubmitted: (value) async {
                                          queryFlag = false;
                                          await sendMessageFCT(
                                              chatProvider: chatProvider);
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            label: queryFlag == false
                                                ? DefaultTextStyle(
                                                    style: const TextStyle(
                                                        // height: 0.6,
                                                        fontFamily: 'PTSans',
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16),
                                                    child: AnimatedTextKit(
                                                        stopPauseOnTap: true,
                                                        isRepeatingAnimation:
                                                            true,
                                                        repeatForever: true,
                                                        displayFullTextOnTap:
                                                            true,
                                                        animatedTexts: [
                                                          ScaleAnimatedText(
                                                              'Enter Your Query',
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1))
                                                        ]),
                                                  )
                                                : null)),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {

                                      await sendMessageFCT(

                                          chatProvider: chatProvider);
                                    },
                                    icon: const Icon(Icons.search_rounded,color: Colors.greenAccent,)
                                   )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
    // if(_listScrollController.position.pixels != _listScrollController.position.maxScrollExtent){
    //   _listScrollController.animateTo(
    //       _listScrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 500),
    //       curve: Curves.easeOut);
    // }
  }

  Future<void> sendMessageFCT(
      {
      required ChatProvider chatProvider}) async {
    if (_isResponseLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isResponseLoading = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: "gpt-3.5-turbo-0301",listScrollController: _listScrollController);

      // ));

      // setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isResponseLoading = false;
      });
    }
  }
}

class ChatsFlexWidget extends StatefulWidget {
  const ChatsFlexWidget({
    super.key,
    required ScrollController listScrollController,
    required this.chatProvider,
  }) : _listScrollController = listScrollController;

  final ScrollController _listScrollController;
  final ChatProvider chatProvider;

  @override
  State<ChatsFlexWidget> createState() => _ChatsFlexWidgetState();
}

class _ChatsFlexWidgetState extends State<ChatsFlexWidget> {
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child:
      ListView.builder(
          physics: const ScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          controller: widget._listScrollController,
          itemCount: widget.chatProvider.getChatList.length, //chatList.length,
          itemBuilder: (context, index) {

            return widget.chatProvider.chatList.isNotEmpty ? ChatWidget(
              msg: widget.chatProvider.getChatList[index].msg, // chatList[index].msg,
              chatIndex: widget.chatProvider
                  .getChatList[index].chatIndex, //chatList[index].chatIndex,
              shouldAnimate: widget.chatProvider.getChatList.length - 1 == index,
              isResponseLiked: widget.chatProvider.getChatList[index].isFavourite,
            ) : Container();

          }) ,
    );
  }
}
