class CreateSavedSentenceModel
{
  String? message;
  bool? success;
  late List<dynamic> data;

  CreateSavedSentenceModel.fromJson(Map<String,dynamic> json)
  {
    message = json["message"];
    success = json["success"];
    data = json["data"] ;
  }

}
