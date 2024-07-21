part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

class CreateExpense extends ExpenseEvent {
  final Expense newExpense;

  CreateExpense(this.newExpense);
}

// class ReadAllExpenses extends ExpenseEvent {}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;
  final Expense updatedExpense;

  UpdateExpense({required this.expense, required this.updatedExpense});
}

class DeleteExpense extends ExpenseEvent {
  final Expense expense;

  DeleteExpense({required this.expense});
}

class ReadMonthExpesnes extends ExpenseEvent {
  final int year;
  final int month;
  ReadMonthExpesnes({required this.year, required this.month});
}
