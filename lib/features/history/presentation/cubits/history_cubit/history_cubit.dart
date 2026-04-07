import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';
import 'package:final_project/features/diagnosis/data/services/api_services.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());
  final supabase = Supabase.instance.client;
  ApiServices apiServices = ApiServices();
  List<Map<String, dynamic>> _allHistory = [];
  String _searchQuery = '';
  DateTime? _selectedDate;

  void addToHistory(DiagnosisModel diagnosisModel) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final imageUrl = await uploadImageToSupabase(
      File(diagnosisModel.image!.path),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .add({
          'diagnosis': diagnosisModel.diagnosis,
          'confidence': diagnosisModel.confidence,
          'image': imageUrl,
          'date': Timestamp.now(),
          'name': diagnosisModel.name,
          'age': diagnosisModel.age,
          'gender': diagnosisModel.gender,
        });
  }

  Future<void> getHistory() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      emit(HistoryLoading());

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('history')
          .orderBy('date', descending: true)
          .get();

      _allHistory = snapshot.docs.map((doc) => doc.data()).toList();

      _applyFilters();
    } catch (e) {
      emit(HistoryFailure(message: e.toString()));
    }
  }

  //! ================= FILTER =================
  void updateSearch(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateDate(DateTime? date) {
    _selectedDate = date;
    _applyFilters();
  }

  void _applyFilters() {
    final filtered = _allHistory.where((item) {
      bool matchesSearch = true;
      bool matchesDate = true;

      if (_searchQuery.isNotEmpty) {
        final name = item['name']?.toString().toLowerCase() ?? '';
        matchesSearch = name.contains(_searchQuery.toLowerCase());
      }

      if (_selectedDate != null) {
        final timestamp = item['date'] as Timestamp?;
        if (timestamp != null) {
          final date = timestamp.toDate();
          matchesDate =
              date.year == _selectedDate!.year &&
              date.month == _selectedDate!.month &&
              date.day == _selectedDate!.day;
        } else {
          matchesDate = false;
        }
      }

      return matchesSearch && matchesDate;
    }).toList();

    emit(HistorySuccess(filtered));
  }

  Future<void> removeFromHistory(Timestamp date) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return;

    final doc = snapshot.docs.first;
    final imageUrl = doc['image'];

    await deleteImageFromSupabase(imageUrl);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .doc(doc.id)
        .delete();
    //! 🔥 أهم سطر
    _allHistory.removeWhere((item) => item['date'] == date);

    //! 🔥 أعد الفلترة
    _applyFilters();
  }

  //! Supabase
  Future<void> deleteImageFromSupabase(String imageUrl) async {
    final supabase = Supabase.instance.client;

    final uri = Uri.parse(imageUrl);
    final filePath = uri.path.split('/public/').last;

    await supabase.storage.from('history_images').remove([
      filePath.replaceFirst('history_images/', ''),
    ]);
  }

  Future<String> uploadImageToSupabase(File image) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';

    await supabase.storage.from('history_images').upload(fileName, image);

    final imageUrl = supabase.storage
        .from('history_images')
        .getPublicUrl(fileName);

    return imageUrl;
  }
}
