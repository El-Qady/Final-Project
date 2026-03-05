import 'dart:io';
import 'package:dio/dio.dart';
import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';
import 'package:final_project/features/diagnosis/data/services/api_services.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiagnosisCubit extends Cubit<DiagnosisState> {
  DiagnosisCubit(this.apiServices) : super(DiagnosisInitial());
  final ApiServices apiServices;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> getPrediction(
    File imageFile,
    String name,
    int age,
    String gender,
  ) async {
    emit(DiagnosisLoading());

    await _runPrediction(imageFile, name, age, gender);
  }

  Future<void> _runPrediction(
    File imageFile,
    String name,
    int age,
    String gender,
  ) async {
    try {
      final response = await apiServices.predict(
        endpoint: '/analyze',
        imageFile: imageFile,
        name: name,
        age: age,
        gender: gender,
      );
      if (response.data == null) {
        emit(DiagnosisFailure(message: 'Error connecting to server'));
        return;
      } else if (response.data['is_mri'] == false) {
        emit(DiagnosisFailure(message: 'Image is not MRI'));
        return;
      }
      final diagnosisModel = DiagnosisModel.fromJson(
        response.data,
        imageFile,
        name,
        age,
        gender,
      );

      emit(DiagnosisSuccess(diagnosisModel: diagnosisModel));
    } on DioException catch (e) {
      emit(DiagnosisFailure(message: _handleDioError(e)));
    }
  }

  Future<void> downloadPdf(String patient) async {
    emit(DiagnosisDownloadLoading());

    try {
      final file = await apiServices.downloadFile(
        '/download-report',
        patient,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            emit(DiagnosisDownloadProgress(received / total));
          }
        },
      );

      if (file != null) {
        emit(DiagnosisDownloadSuccess(file));
      } else {
        emit(DiagnosisDownloadFailure(message: "Download failed"));
      }
    } catch (e) {
      emit(DiagnosisDownloadFailure(message: "Error downloading file"));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Timeout connecting to server';
      default:
        return 'Server error';
    }
  }
}
