import 'package:dio/dio.dart';
import 'package:mypractice_flutter/AI.dart';

class Dioapi {
  String content = "";
  final dio = Dio(BaseOptions(
      baseUrl: 'https://betadash-api-swordslush-production.up.railway.app'));
  Future<Ai?> askAi(String ask) async {
    try {
      Response response = await dio.get('/');
      response = await dio.get('/gpt4', queryParameters: {'ask': ask});
      content = response.data['content'];
      return Ai.getContent(content);
    } catch (e) {
      print("Error: $e");
    }
  }
}
