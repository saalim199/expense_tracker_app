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
}
