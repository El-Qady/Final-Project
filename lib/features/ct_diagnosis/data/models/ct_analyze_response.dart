class CtAnalyzeResponse {
  final bool success;
  final String resultId;
  final CtPatient patient;
  final String diagnosis;
  final String displayName;
  final double confidencePct;
  final String severity;
  final bool emergency;
  final bool verificationRequired;
  final int questionCount;
  final List<CtQuestion> questions;
  final List<String> requiredTests;
  final List<String> recommendations;
  final String explanation;

  CtAnalyzeResponse({
    required this.success,
    required this.resultId,
    required this.patient,
    required this.diagnosis,
    required this.displayName,
    required this.confidencePct,
    required this.severity,
    required this.emergency,
    required this.verificationRequired,
    required this.questionCount,
    required this.questions,
    required this.requiredTests,
    required this.recommendations,
    required this.explanation,
  });

  factory CtAnalyzeResponse.fromJson(Map<String, dynamic> json) {
    return CtAnalyzeResponse(
      success: json['success'] ?? false,
      resultId: json['result_id'] ?? '',
      patient: CtPatient.fromJson(json['patient'] ?? {}),
      diagnosis: json['diagnosis'] ?? '',
      displayName: json['display_name'] ?? '',
      confidencePct: (json['confidence_pct'] as num?)?.toDouble() ?? 0.0,
      severity: json['severity'] ?? '',
      emergency: json['emergency'] ?? false,
      verificationRequired: json['verification_required'] ?? false,
      questionCount: json['question_count'] ?? 0,
      questions: (json['questions'] as List?)
              ?.map((q) => CtQuestion.fromJson(q))
              .toList() ??
          [],
      requiredTests: List<String>.from(json['required_tests'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      explanation: json['explanation'] ?? '',
    );
  }
}

class CtPatient {
  final String name;
  final int age;
  final String gender;

  CtPatient({
    required this.name,
    required this.age,
    required this.gender,
  });

  factory CtPatient.fromJson(Map<String, dynamic> json) {
    return CtPatient(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
    };
  }
}

class CtQuestion {
  final String symptom;
  final String question;
  final double weight;
  final String severity;
  final bool emergency;

  CtQuestion({
    required this.symptom,
    required this.question,
    required this.weight,
    required this.severity,
    required this.emergency,
  });

  factory CtQuestion.fromJson(Map<String, dynamic> json) {
    return CtQuestion(
      symptom: json['symptom'] ?? '',
      question: json['question'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      severity: json['severity'] ?? '',
      emergency: json['emergency'] ?? false,
    );
  }
}
