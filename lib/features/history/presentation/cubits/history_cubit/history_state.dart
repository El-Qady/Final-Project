
abstract class HistoryState {}

final class HistoryInitial extends HistoryState {}
class HistorySuccess extends HistoryState {
  final List<Map<String, dynamic>> history;
  HistorySuccess(this.history);
}
final class HistoryLoading extends HistoryState {}

final class HistoryFailure extends HistoryState {
  final String message;
  HistoryFailure({required this.message});
}
