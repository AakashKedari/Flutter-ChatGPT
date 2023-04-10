import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/provider/models_provider.dart';
import 'package:chatgpt/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Chatgpt());
}

class Chatgpt extends StatelessWidget {
  const Chatgpt({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelProvider()),
      ],
      child: MaterialApp(
        home: const SplashScreen(),
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(color: cardColor)),
      ),
    );
  }
}
