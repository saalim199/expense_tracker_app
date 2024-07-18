part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

class CreateExpense extends ExpenseEvent {
  final Expense newExpense;

  CreateExpense(this.newExpense);
}

class ReadAllExpenses extends ExpenseEvent {}

class UpdateExpense extends ExpenseEvent {
  final int id;
  final Expense updatedExpense;

  UpdateExpense({required this.id, required this.updatedExpense});
}

class DeleteExpense extends ExpenseEvent {
  final int id;

  DeleteExpense({required this.id});
}
