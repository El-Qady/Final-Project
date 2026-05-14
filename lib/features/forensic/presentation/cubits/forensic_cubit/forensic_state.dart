import 'package:final_project/features/forensic/data/models/forensic_model.dart';

abstract class ForensicState {}

class ForensicInitial extends ForensicState {}

class ForensicLoading extends ForensicState {}

class ForensicSuccess extends ForensicState {
  final ForensicModel forensicModel;

  ForensicSuccess(this.forensicModel);
}

class ForensicFailure extends ForensicState {
  final String message;

  ForensicFailure(this.message);
}
