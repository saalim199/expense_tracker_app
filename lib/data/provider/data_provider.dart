import 'package:expense_tracker_app/model/expense.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DataProvider {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  Future<void> createNewExpense(Expense newExpense) async {
    await isar.writeTxn(() {
      return isar.expenses.put(newExpense);
    });
  }

  Future<List<Expense>> getAllExpenses() async {
    return await isar.expenses.where().findAll();
  }

  Future<List<Expense>> getExpensesByMonth(int year, int month) async {
    return await isar.expenses
        .where()
        .filter()
        .dateBetween(DateTime(year, month, 1), DateTime(year, month + 1, 1))
        .findAll();
  }

  Future<void> updateExpense(int id, Expense updatedExpense) async {
    updatedExpense.id = id;
    await isar.writeTxn(() {
      return isar.expenses.put(updatedExpense);
    });
  }

  Future<void> deleteExpense(int id) async {
    await isar.writeTxn(() {
      return isar.expenses.delete(id);
    });
  }

  Future<Map<int, double>> calculateMonthlyTotal() async {
    final expenses = await getAllExpenses();
    Map<int, double> monthlyTotal = {};
    int startYear = await getStartYear();
    for (var expense in expenses) {
      int month = expense.date.month;
      int year = expense.date.year;
      if (year < startYear) {
        continue;
      }
      month += (year - startYear) * 12;
      if (!monthlyTotal.containsKey(month)) {
        monthlyTotal[month] = 0;
      }
      monthlyTotal[month] = monthlyTotal[month]! + expense.amount;
    }
    return monthlyTotal;
  }

  Future<int> getStartMonth() async {
    final expenses = await getAllExpenses();
    if (expenses.isEmpty) {
      return DateTime.now().month;
    }
    expenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    return expenses.first.date.month;
  }

  Future<int> getStartYear() async {
    final expenses = await getAllExpenses();
    if (expenses.isEmpty) {
      return DateTime.now().year;
    }
    expenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    return expenses.first.date.year;
  }
}
