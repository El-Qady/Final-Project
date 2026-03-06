import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<Response> predict({
    required String endpoint,
    required File imageFile,
    required String name,
    required int age,
    required String gender,
  }) async {
    FormData formData = await bodyPostApiDiagnosis(
      imageFile,
      name: name,
      age: age,
      gender: gender,
    );

    return await dioModel.post(endpoint, data: formData);
  }

  Future<File?> downloadFile(
    String endpoint,
    String patientName, {
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getDownloadsDirectory();
      }

      dir ??= await getApplicationDocumentsDirectory();

      final fileName = "${patientName.replaceAll(' ', '_')}_Report.pdf";
      final file = File("${dir.path}/$fileName");

      final response = await dioModel.get(
        endpoint,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: onReceiveProgress,
      );

      await file.writeAsBytes(response.data);

      return file;
    } catch (e) {
      return null;
    }
  }
}
