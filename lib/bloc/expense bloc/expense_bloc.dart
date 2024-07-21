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
        final expenses = await DataProvider()
            .getExpensesByMonth(DateTime.now().year, DateTime.now().month);
        final totalExpense = expenses.fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
        emit(ExpenseLoaded(
          expenses: expenses,
          totalExpense: totalExpense,
          month: DateTime.now().month,
          year: DateTime.now().year,
        ));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    // on<ReadAllExpenses>((event, emit) async {
    //   emit(ExpenseLoading());
    //   try {
    //     emit(ExpenseLoaded(expenses: await DataProvider().getAllExpenses()));
    //   } catch (e) {
    //     emit(ExpenseError(e.toString()));
    //   }
    // });

    on<UpdateExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await DataProvider()
            .updateExpense(event.expense.id, event.updatedExpense);
        final expenses = await DataProvider().getExpensesByMonth(
            event.expense.date.year, event.expense.date.month);
        final totalExpense = expenses.fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
        emit(ExpenseLoaded(
          expenses: expenses,
          totalExpense: totalExpense,
          month: event.expense.date.month,
          year: event.expense.date.year,
        ));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<DeleteExpense>((event, emit) async {
      emit(ExpenseLoading());
      try {
        await DataProvider().deleteExpense(event.expense.id);
        final expenses = await DataProvider().getExpensesByMonth(
            event.expense.date.year, event.expense.date.month);
        final totalExpense = expenses.fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
        emit(ExpenseLoaded(
          expenses: expenses,
          totalExpense: totalExpense,
          month: event.expense.date.month,
          year: event.expense.date.year,
        ));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<ReadMonthExpesnes>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final expenses =
            await DataProvider().getExpensesByMonth(event.year, event.month);
        final totalExpense = expenses.fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
        emit(ExpenseLoaded(
          expenses: expenses,
          totalExpense: totalExpense,
          month: event.month,
          year: event.year,
        ));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });
  }
}
