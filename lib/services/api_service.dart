import 'dart:convert';
import 'dart:developer';

import 'package:chatgpt/constants/api_constants.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:http/http.dart' as http;

// Future function to get the models of chatgpt
class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
          Uri.parse('https://api.openai.com/v1/models'),
          headers: {'Authorization': 'Bearer $API_KEY'});

      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse['object']);
      if (jsonResponse['error'] != null) {
        print(jsonResponse['error']['message']);
      }
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
        log("temp ${value['id']}");
      }

      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log('error $error');
      rethrow;
    }
  }

  // Send Message future function
  static Future<List<ChatModel>> sendMessage(
      {required String modelId, required String message}) async {
    var response = await http.post(Uri.parse('$BASE_URL/completions'),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ],
            "max_tokens": 25
          },
        ));

    Map jsonResponse = jsonDecode(response.body);
    //print(jsonResponse['object']);
    List<ChatModel> chatList = [];

    if (jsonResponse["choices"].length > 0) {
      chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
              msg: jsonResponse["choices"][index]['text'], chatIndex: 1));
      return chatList;
    }

    throw ("Erroe");
  }
}
