part of 'graph_bloc.dart';

@immutable
sealed class GraphState {}

final class GraphInitial extends GraphState {}

final class GraphLoading extends GraphState {}

final class GraphLoaded extends GraphState {
  final Map<int, double> monthlyTotal;
  final int startMonth;
  final int startYear;

  GraphLoaded(this.monthlyTotal, this.startMonth, this.startYear);
}

final class GraphError extends GraphState {
  final String message;

  GraphError(this.message);
}
