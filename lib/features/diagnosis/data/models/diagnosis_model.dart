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
  String returnDescription(String diagnosis) {
    if (diagnosis == 'Normal') {
      return 'No significant abnormalities detected in the brain tissue structure and morphology.';
    } else if (diagnosis == 'Epilepsy') {
      return 'The diagnosis indicates the presence of epilepsy, a neurological disorder characterized by recurrent seizures. It is important to consult with a healthcare professional for further evaluation and management.';
    } else if (diagnosis == 'Mild_Impairment_Alzheimer') {
      return 'The diagnosis suggests mild impairment associated with Alzheimer\'s disease. It is recommended to seek medical advice for further assessment and potential treatment options.';
    } else if (diagnosis == 'Moderate_Impairment_Alzheimer') {
      return 'The diagnosis indicates moderate impairment related to Alzheimer\'s disease. It is crucial to consult with a healthcare provider for comprehensive evaluation and appropriate care planning.';
    } else if (diagnosis == 'StrokeMR') {
      return 'The diagnosis suggests the presence of a stroke, which is a medical emergency. Immediate medical attention is necessary to assess the extent of the stroke and initiate appropriate treatment.';
    } else if (diagnosis == 'Very_Mild_Impairment_Alzheimer') {
      return 'The diagnosis indicates very mild impairment associated with Alzheimer\'s disease. It is advisable to consult with a healthcare professional for further evaluation and monitoring.';
    } else if (diagnosis == 'glioma_Tumor') {
      return 'The diagnosis suggests the presence of a glioma tumor, which is a type of brain tumor. It is essential to seek medical advice for further evaluation, diagnosis confirmation, and treatment planning.';
    } else if (diagnosis == 'meningioma_Tumor') {
      return 'The diagnosis indicates the presence of a meningioma tumor, which is a type of brain tumor that arises from the meninges. It is important to consult with a healthcare professional for further evaluation, diagnosis confirmation, and appropriate management.';
    } else if (diagnosis == 'pituitary_Tumor') {
      return 'The diagnosis suggests the presence of a pituitary tumor, which is a growth that develops in the pituitary gland. It is crucial to seek medical advice for further evaluation, diagnosis confirmation, and treatment planning.';
    } else {
      return 'No description available for this diagnosis.';
    }
  }
}
