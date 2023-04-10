import 'dart:async';

import 'package:chatgpt/screens/chatscreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ChatScreen())));
  }

  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    //print(mediaquery.width);
    return const SafeArea(
      child: Scaffold(
          body: Center(
        child: Image(image: AssetImage('assets/chat_logo.png')),
      )),
    );
  }
}
