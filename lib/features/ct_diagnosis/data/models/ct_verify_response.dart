import 'ct_analyze_response.dart';

class CtVerifyResponse {
  final bool success;
  final String resultId;
  final CtPatient patient;
  final String finalDiagnosis;
  final String diagnosis;
  final String displayName;
  final double confidencePct;
  final double initialConfidencePct;
  final double updatedConfidencePct;
  final String severity;
  final bool emergency;
  final List<String> confirmedSymptoms;
  final int confirmedSymptomsCount;
  final List<CtEvidence> topEvidence;
  final List<String> requiredTests;
  final List<String> recommendations;
  final String explanation;

  CtVerifyResponse({
    required this.success,
    required this.resultId,
    required this.patient,
    required this.finalDiagnosis,
    required this.diagnosis,
    required this.displayName,
    required this.confidencePct,
    required this.initialConfidencePct,
    required this.updatedConfidencePct,
    required this.severity,
    required this.emergency,
    required this.confirmedSymptoms,
    required this.confirmedSymptomsCount,
    required this.topEvidence,
    required this.requiredTests,
    required this.recommendations,
    required this.explanation,
  });

  factory CtVerifyResponse.fromJson(Map<String, dynamic> json) {
    return CtVerifyResponse(
      success: json['success'] ?? false,
      resultId: json['result_id'] ?? '',
      patient: CtPatient.fromJson(json['patient'] ?? {}),
      finalDiagnosis: json['final_diagnosis'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      displayName: json['display_name'] ?? '',
      confidencePct: (json['confidence_pct'] as num?)?.toDouble() ?? 0.0,
      initialConfidencePct: (json['initial_confidence_pct'] as num?)?.toDouble() ?? 0.0,
      updatedConfidencePct: (json['updated_confidence_pct'] as num?)?.toDouble() ?? 0.0,
      severity: json['severity'] ?? '',
      emergency: json['emergency'] ?? false,
      confirmedSymptoms: List<String>.from(json['confirmed_symptoms'] ?? []),
      confirmedSymptomsCount: json['confirmed_symptoms_count'] ?? 0,
      topEvidence: (json['top_evidence'] as List?)
              ?.map((e) => CtEvidence.fromJson(e))
              .toList() ??
          [],
      requiredTests: List<String>.from(json['required_tests'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      explanation: json['explanation'] ?? '',
    );
  }
}

class CtEvidence {
  final String symptom;
  final double weight;

  CtEvidence({
    required this.symptom,
    required this.weight,
  });

  factory CtEvidence.fromJson(Map<String, dynamic> json) {
    return CtEvidence(
      symptom: json['symptom'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
