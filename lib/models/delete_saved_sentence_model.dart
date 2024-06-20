class DeleteSavedSentenceModel
{
  String? status;
  String? message;
  late List<dynamic> data;

  DeleteSavedSentenceModel.fromJson(Map<String,dynamic> json)
  {
    status = json["status"];
    message = json["message"];
    data = json["data"];
  }

}