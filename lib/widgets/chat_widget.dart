import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/chats_provider.dart';
import 'text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWidget extends StatefulWidget with ChangeNotifier {
  ChatWidget({super.key,
    required this.msg,
    required this.chatIndex,
    this.shouldAnimate = false, required this.isResponseLiked});

  final String msg;
  final int chatIndex;
  bool shouldAnimate;
  bool isResponseLiked;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  bool isAnimationDone = false;

  late Animation<Offset> animation;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Material(
      color: widget.chatIndex == 0 ? Colors.black87 : cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        widget.chatIndex == 0 ?
        Lottie.asset(
            'assets/animations/user.json',
            height: 30, width: 30
        ) : Image.asset(AssetsManager.botImage, height: 30, width: 30,),
      const SizedBox(
        width: 8,
      ),
      Expanded(
          child: widget.chatIndex == 0
              ? TextWidget(
            label: widget.msg,
          )
              : (widget.shouldAnimate && !isAnimationDone )
              ?
          DefaultTextStyle(
              style: const TextStyle(
                  fontFamily: 'PTSans',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
              child: AnimatedTextKit(
                  onFinished: () {
                    AssetsManager.shouldScroll = false;
                    widget.shouldAnimate = false;
                    isAnimationDone = true;
                  },
                  isRepeatingAnimation: false,
                  repeatForever: false,
                  displayFullTextOnTap: true,
              totalRepeatCount: 1,
              animatedTexts: [
              TyperAnimatedText(

              widget.msg,
              speed: const Duration(milliseconds: 30)

          ),

          ]),)

        : Text(
    widget.msg.trim(),
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: 'PTSans'
    ),
    ),
    ),
    widget.chatIndex == 0
    ? const SizedBox.shrink()
        : Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
    IconButton(
    onPressed : ()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    chatProvider.chatList[widget.chatIndex].isFavourite = !chatProvider.chatList[widget.chatIndex].isFavourite;
    if(chatProvider.chatList[widget.chatIndex].isFavourite) {
    AssetsManager.likedResponses?.add(chatProvider.chatList[widget.chatIndex-1].msg);

    AssetsManager.likedResponses?.add(chatProvider.chatList[widget.chatIndex].msg);
    if (AssetsManager.likedResponses != null) {
    prefs.setStringList('SavedResponses',
    AssetsManager.likedResponses!);
    }
    print(AssetsManager.likedResponses);
    }
    else{
    AssetsManager.likedResponses?.remove(chatProvider.chatList[widget.chatIndex-1].msg);
    AssetsManager.likedResponses?.remove(chatProvider.chatList[widget.chatIndex].msg);
    if (AssetsManager.likedResponses != null) {
    prefs.setStringList('SavedResponses',
    AssetsManager.likedResponses!);
    }

    print(AssetsManager.likedResponses);
    }
    chatProvider.alertChange();
    },
    icon : widget.isResponseLiked ? const Icon(Icons.thumb_up,color: Colors.red,) :
    const Icon( Icons.thumb_up_alt_outlined ),
    color: Colors.white,
    ),

    ],
    ),
    ],
    ),
    ),
    );
  }
}
