import 'dart:io';
import 'package:dio/dio.dart';

class ForensicApiServices {
  late Dio dio;

  ForensicApiServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://sayed-ai-lab-forensic.hf.space',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  Future<Response> predict(File imageFile) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    return await dio.post('/predict', data: formData);
  }
}
