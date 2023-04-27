import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:online_technician/shared/components/constants.dart';

class DioHelper {
  static Dio dio = Dio();
  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://api-inference.huggingface.co',
          receiveDataWhenStatusError: true,
          headers: {
            'Authorization': 'Bearer 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',
            "Content-Type": "application/json",
          }),
    );
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
    String lang = 'ar',
    String? token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'authorization': token,
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {
      required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic> data
      }) async {
    dio.options.headers = {
      'Authorization': 'Bearer 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',
    };
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> sendFcmMessage(
      {String? title, String? message, String? token}) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    dio.options.headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$serverToken",
    };
    var request = {
      "to": '$token',
      "notification": {"title": title, "body": message, "sound": "default"},
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default"
        }
      },
      "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK"}
    };
    return await dio.post(url, data: json.encode(request));
  }
}
