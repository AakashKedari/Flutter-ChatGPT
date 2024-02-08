import 'package:chatgpt/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/assets_manager.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.greenAccent,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Favourites',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),
        ),

      ),
      body: AssetsManager.likedResponses == null ? const Center(child: Text('No Favourites',style: TextStyle(color: Colors.white),),) : ListView.builder(
          itemCount: AssetsManager.likedResponses!.length,
          itemBuilder: (context,index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: index.isEven ? Colors.black87 : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AssetsManager.likedResponses![index],style: TextStyle(color: index.isEven ? Colors.white : Colors.black87,
                  fontWeight: index.isEven ? FontWeight.w900 : FontWeight.w400
                  ),

                  ),
                ),
              ),
            );
          }),
    );
  }
}
