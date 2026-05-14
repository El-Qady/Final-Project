import 'dart:io';
import 'package:dio/dio.dart';
import 'package:final_project/features/forensic/data/models/forensic_model.dart';
import 'package:final_project/features/forensic/data/services/forensic_api_services.dart';
import 'package:final_project/features/forensic/presentation/cubits/forensic_cubit/forensic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForensicCubit extends Cubit<ForensicState> {
  final ForensicApiServices _apiServices;

  ForensicCubit(this._apiServices) : super(ForensicInitial());

  Future<void> getForensicPrediction(File imageFile) async {
    emit(ForensicLoading());
    try {
      final response = await _apiServices.predict(imageFile);
      if (response.statusCode == 200) {
        final forensicModel = ForensicModel.fromJson(response.data);
        emit(ForensicSuccess(forensicModel));
      } else {
        emit(ForensicFailure('Failed to get diagnosis. Status: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(ForensicFailure(e.response?.data['detail'] ?? 'An error occurred'));
      } else {
        emit(ForensicFailure('Network error: ${e.message}'));
      }
    } catch (e) {
      emit(ForensicFailure('Unexpected error: $e'));
    }
  }

  void reset() {
    emit(ForensicInitial());
  }
}
