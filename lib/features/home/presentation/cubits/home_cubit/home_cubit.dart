import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/features/home/presentation/cubits/home_cubit/home_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
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
}
