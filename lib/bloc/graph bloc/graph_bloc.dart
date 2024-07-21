import 'package:expense_tracker_app/data/provider/data_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'graph_event.dart';
part 'graph_state.dart';

class GraphBloc extends Bloc<GraphEvent, GraphState> {
  GraphBloc() : super(GraphInitial()) {
    on<GetGraphData>((event, emit) async {
      emit(GraphLoading());
      try {
        final monthlyTotal = await DataProvider().calculateMonthlyTotal();
        final startMonth = await DataProvider().getStartMonth();
        final startYear = await DataProvider().getStartYear();
        emit(GraphLoaded(monthlyTotal, startMonth, startYear));
      } catch (e) {
        emit(GraphError(e.toString()));
      }
    });
  }
}
