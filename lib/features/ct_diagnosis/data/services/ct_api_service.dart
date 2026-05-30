import 'dart:io';
import 'package:dio/dio.dart';
import '../models/ct_analyze_response.dart';
import '../models/ct_verify_response.dart';

class CtApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://sayed-ai-lab-mokhi-ct.hf.space',
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
    ),
  );

  Future<CtAnalyzeResponse> analyzeImage({
    required File imageFile,
    required String name,
    required String age,
    required String gender,
  }) async {
    final fileName = imageFile.path.split('/').last;
    final formData = FormData.fromMap({
      'name': name,
      'age': age,
      'gender': gender.toLowerCase(),
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final response = await _dio.post('/analyze', data: formData);
    if (response.data == null) {
      throw Exception('Empty response from server');
    }
    return CtAnalyzeResponse.fromJson(response.data);
  }

  Future<CtVerifyResponse> verifySymptoms({
    required String resultId,
    required String diagnosis,
    required CtPatient patient,
    required double initialConfidencePct,
    required Map<String, bool> answers,
  }) async {
    final Map<String, dynamic> requestBody = {
      'result_id': resultId,
      'diagnosis': diagnosis,
      'patient': patient.toJson(),
      'initial_confidence_pct': initialConfidencePct,
      'answers': answers,
    };

    final response = await _dio.post(
      '/verify',
      data: requestBody,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.data == null) {
      throw Exception('Empty response from server');
    }
    return CtVerifyResponse.fromJson(response.data);
  }
}
