import 'dart:async';
import 'package:chatgpt/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // late GifController gifController;

  @override
  void initState(){
    super.initState();
    Timer( const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body:
      Center(child:
      Lottie.asset("assets/animations/chatGPTLogo.json",
          width: 100  , height: 100)
      ),
      // Center(
      //   child: Image.asset('assets/animations/7BZk.gif')
      // )
    );
  }
}
