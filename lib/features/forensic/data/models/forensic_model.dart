class ForensicModel {
  final String diagnosis;
  final double confidence;

  ForensicModel({
    required this.diagnosis,
    required this.confidence,
  });

  factory ForensicModel.fromJson(Map<String, dynamic> json) {
    return ForensicModel(
      diagnosis: json['diagnosis'] as String? ?? 'Unknown Diagnosis',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diagnosis': diagnosis,
      'confidence': confidence,
    };
  }
}
