abstract class AccountSettingsState {}

class AccountSettingsInitial extends AccountSettingsState {}

class AccountSettingsLoading extends AccountSettingsState {}

class AccountSettingsSuccess extends AccountSettingsState {
  final String message;
  AccountSettingsSuccess(this.message);
}

class AccountSettingsFailure extends AccountSettingsState {
  final String error;
  AccountSettingsFailure(this.error);
}
