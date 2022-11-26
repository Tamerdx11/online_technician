import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio() ;
  static init(){
    dio= Dio(
      BaseOptions(
        baseUrl: 'https://newsapi.org/',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type':'application/json',
        }
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    required Map<String,dynamic> query,
    String lang = 'ar',
    String? token,
}) async
  {
    dio.options.headers= {
  'lang':lang,
  'authorization':token,
  };
    return await dio.get(url,queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String,dynamic>? query,
    String lang = 'ar',
    String? token,
    required Map<String,dynamic> data

}) async
  {
    dio.options.headers= {
      'lang':lang,
      'authorization':token,
    };
    return await dio.post(
        url,
        queryParameters:query,
        data: data,
    );
  }


}