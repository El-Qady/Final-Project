import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:final_project/features/home/data/models/diagnosis_model.dart';
import 'package:final_project/features/home/data/services/api_services.dart';
import 'package:final_project/features/home/presentation/cubits/home_cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.apiServices) : super(HomeInitial());

  final ApiServices apiServices;
  Future<String>? _userNameFuture;

  Future<String> getUserName() {
    _userNameFuture ??= _fetchUserName();
    return _userNameFuture!;
  }

  Future<String> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc['name'];
  }

  Future<void> getPrediction(File imageFile) async {
    emit(DiagnosisLoading());
    final isValid = await _validateMri(imageFile);
    if (!isValid) return;

    await _runPrediction(imageFile);
  }

  Future<bool> _validateMri(File imageFile) async {
    final isMri = await apiServices.checkMri(
      imageFile: imageFile,
      endpoint: '/check-mri',
    );

    if (isMri == null) {
      emit(DiagnosisFailure(message: 'Error connecting to server'));
      return false;
    }

    if (!isMri) {
      emit(DiagnosisFailure(message: 'Image is not MRI'));
      return false;
    }

    return true;
  }

  Future<void> _runPrediction(File imageFile) async {
    try {
      final response = await apiServices.predict(
        endpoint: '/predict',
        imageFile: imageFile,
      );

      final diagnosisModel = DiagnosisModel.fromJson(response.data, imageFile);

      emit(DiagnosisSuccess(diagnosisModel: diagnosisModel));
    } on DioException catch (e) {
      emit(DiagnosisFailure(message: _handleDioError(e)));
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
