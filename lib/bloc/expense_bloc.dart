import 'package:expense_tracker_app/data/provider/data_provider.dart';
import 'package:expense_tracker_app/model/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<CreateExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await DataProvider().createNewExpense(event.newExpense);
        emit(ExpenseLoaded(expenses: await DataProvider().getAllExpenses()));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<ReadAllExpenses>((event, emit) async {
      emit(ExpenseLoading());
      try {
        emit(ExpenseLoaded(expenses: await DataProvider().getAllExpenses()));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<UpdateExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await DataProvider().updateExpense(event.id, event.updatedExpense);
        emit(ExpenseLoaded(expenses: await DataProvider().getAllExpenses()));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<DeleteExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await DataProvider().deleteExpense(event.id);
        emit(ExpenseLoaded(expenses: await DataProvider().getAllExpenses()));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });
  }
}
