class ForensicModel {
  final String diagnosis;
  final double confidence;
  final String? report;

  ForensicModel({
    required this.diagnosis,
    required this.confidence,
    this.report,
  });

  factory ForensicModel.fromJson(Map<String, dynamic> json) {
    return ForensicModel(
      diagnosis: json['diagnosis'] as String? ?? 'Unknown Diagnosis',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      report: json['report'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diagnosis': diagnosis,
      'confidence': confidence,
      'report': report,
    };
  }
}
