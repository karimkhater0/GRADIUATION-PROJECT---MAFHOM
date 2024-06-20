class SavedSentencesModel
{
  // String? message;
  // bool? success;
  late List<dynamic> data;

  SavedSentencesModel.fromJson(Map<String, dynamic> json){
    // message = json["message"];
    // success = json["success"];
    data = json["data"] ?? [];
  }

}