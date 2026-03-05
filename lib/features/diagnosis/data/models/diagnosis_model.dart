import 'dart:io';

class DiagnosisModel {
  DiagnosisModel({
    required this.imagename,
    this.image,
    required this.diagnosis,
    required this.confidence,
    this.imageurl,
    required this.age,
    required this.gender,
    required this.name,
  });
  final String diagnosis;
  final double confidence;
  final File? image;
  final String? imageurl;
  final String imagename;
  final int age;
  final String gender;
  final String name;
  factory DiagnosisModel.fromJson(
    Map<String, dynamic> json,
    File image,
    String name,
    int age,
    String gender,
  ) {
    return DiagnosisModel(
      imagename: image.path.split('/').last,
      image: image,
      diagnosis: json['diagnosis'],
      confidence: (json['confidence']),
      age: age,
      gender: gender,
      name: name,
    );
  }
  factory DiagnosisModel.fromMap(Map<String, dynamic> map) {
    return DiagnosisModel(
      imagename: Uri.parse(map['image']).path.split('/history_images/').last,
      imageurl: map['image'],
      diagnosis: map['diagnosis'],
      confidence: map['confidence'],
      age: map['age'],
      gender: map['gender'],
      name: map['name'],
    );
  }
}
