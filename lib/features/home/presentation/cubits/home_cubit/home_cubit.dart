import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/home/presentation/cubits/home_cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  Future<Map<String, dynamic>?>? _userDataFuture;
  
  Future<Map<String, dynamic>?> getUserData() {
    _userDataFuture ??= _fetchUserData();
    return _userDataFuture!;
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data();
  }

  void refreshUserData() {
    _userDataFuture = _fetchUserData();
    emit(HomeInitial());
  }
}
