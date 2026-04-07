import 'dart:io';

import 'package:dio/dio.dart';
import 'package:final_project/features/diagnosis/data/services/api_services.dart';
import 'package:final_project/features/history/presentation/cubits/history_diagnosis/history_diagnosis_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryDiagnosisCubit extends Cubit<HistoryDiagnosisState> {
  HistoryDiagnosisCubit() : super(HistoryDiagnosisInitial());
  ApiServices apiServices = ApiServices();
  Future<void> getPrediction(
    File imageFile,
    String name,
    int age,
    String gender,
  ) async {
    emit(DiangonosisHistoryLoading());

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
        emit(DiagonosisHistoryFailure('Error connecting to server'));
        return;
      }
      emit(DiangonosisHistorySuccess());
    } on DioException catch (e) {
      emit(DiagonosisHistoryFailure(_handleDioError(e)));
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
