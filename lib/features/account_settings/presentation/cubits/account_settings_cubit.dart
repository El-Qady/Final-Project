import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  AccountSettingsCubit() : super(AccountSettingsInitial());

  String? profileImageUrl;
  String? initialProfileImageUrl;
  String? currentName;
  String? currentEmail;

  final String _imgbbApiKey = '58ad2c3f61c6825170be7ff6fe3c6c12';
  final ImagePicker _picker = ImagePicker();

  Future<void> fetchUserData() async {
    try {
      emit(AccountSettingsLoading());
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(AccountSettingsFailure('User not logged in'));
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        currentName = data['name'];
        currentEmail = data['email'];
        profileImageUrl = data['profileImageUrl'];
        initialProfileImageUrl = profileImageUrl;
        emit(AccountSettingsSuccess('Data loaded'));
      } else {
        emit(AccountSettingsFailure('User data not found'));
      }
    } catch (e) {
      emit(AccountSettingsFailure('Error fetching data: $e'));
    }
  }

  Future<void> updateUserData({String? name}) async {
    try {
      emit(AccountSettingsLoading());
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(AccountSettingsFailure('User not logged in'));
        return;
      }

      final updates = <String, dynamic>{};
      if (name != null && name.isNotEmpty) {
        updates['name'] = name;
        currentName = name;
      }

      if (profileImageUrl != initialProfileImageUrl) {
        updates['profileImageUrl'] = profileImageUrl;
        initialProfileImageUrl = profileImageUrl;
      }

      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update(updates);
      }

      emit(AccountSettingsSuccess('Profile updated successfully'));
    } catch (e) {
      emit(AccountSettingsFailure('Error updating profile: $e'));
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      emit(AccountSettingsLoading());

      final File file = File(image.path);
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Dio dio = Dio();
      var response = await dio.post(
        'https://api.imgbb.com/1/upload?key=$_imgbbApiKey',
        data: formData,
      );

      if (response.statusCode == 200) {
        final url = response.data['data']['url'];
        profileImageUrl = url;
        // Fast Request: Store URL locally, but refrain from inserting to Firestore until calling updateUserData
        emit(
          AccountSettingsSuccess('Image ready! Click Save Changes to confirm.'),
        );
      } else {
        emit(AccountSettingsFailure('Image upload failed to imgbb'));
      }
    } catch (e) {
      emit(AccountSettingsFailure('Error uploading image: $e'));
    }
  }
}
