import 'dart:io';
import 'package:dio/dio.dart';

class ApiServices {
  late Dio dioModel;
  late Dio dioMri;

  ApiServices() {
    dioModel = Dio(
      BaseOptions(
        baseUrl: 'https://sayed-ai-lab-mokhi.hf.space',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dioMri = Dio(
      BaseOptions(
        baseUrl: 'https://sayed-ai-lab-check-mri.hf.space',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }
  Future<FormData> bodyPostApiCkeckMri(File imageFile) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });
    return formData;
  }
  Future<FormData> bodyPostApiDiagnosis(
  File imageFile, {
  required String name,
  required int age,
  required String gender,
}) async {
  FormData formData = FormData.fromMap({
    'name': name,
    'age': age,
    'gender': gender,
    'file': await MultipartFile.fromFile(
      imageFile.path,
      filename: imageFile.path.split('/').last,
    ),
  });

  return formData;
}

  Future<bool?> checkMri({
    required File imageFile,
    required String endpoint,
  }) async {
    try {
      FormData formData = await bodyPostApiCkeckMri(imageFile);

      final response = await dioMri.post(endpoint, data: formData);

      return response.data['is_mri'];
    } catch (_) {
      return null;
    }
  }

  Future<Response> predict({
    required String endpoint,
    required File imageFile,
    required String name,
    required int age,
    required String gender,
  }) async {
    FormData formData = await bodyPostApiDiagnosis(imageFile, name: name, age: age, gender: gender);

    return await dioModel.post(endpoint, data: formData);
  }

  
}
