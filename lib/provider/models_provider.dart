import 'package:chatgpt/models/models_model.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class ModelProvider with ChangeNotifier {
  String currentModel = "text-davinci-003";

  String get getcurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];
  // List<ModelsModel> get getmodelsList {
  //   return modelsList;
  // }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
