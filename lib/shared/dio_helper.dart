import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://mafhoom-api.onrender.com/users/",
        receiveDataWhenStatusError: true,
        headers: {"Content-Type": "application/json"},
      ),
    );
  }

  static Future<Response?> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio?.options.headers={
      'authorization': "Bearer $token",
    };
    return await dio?.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
      required String url,
      Map<String, dynamic>? query,
      String? token,
      required Map<String, dynamic> data}) async {
    dio?.options.headers={
      'authorization': "Bearer $token",
    };
    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  })
  {
    dio?.options.headers={
      'authorization': "Bearer $token",
    };
    return dio!.delete(url,data: data);
  }

  static Future<Response> patchData({
    required String url,
    required Map<String,dynamic> data,
}){
    return dio!.patch(
      url,
      data: data,
    );
}
}
