import 'package:expense_tracker_app/bloc/expense%20bloc/expense_bloc.dart';
import 'package:expense_tracker_app/bloc/graph%20bloc/graph_bloc.dart';
import 'package:expense_tracker_app/graph/bar_graph.dart';
import 'package:expense_tracker_app/model/expense.dart';
import 'package:expense_tracker_app/presentation/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    context.read<GraphBloc>().add(GetGraphData());
    context.read<ExpenseBloc>().add(ReadMonthExpesnes(
        year: DateTime.now().year, month: DateTime.now().month));
    super.initState();
  }

  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Add New Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                amountController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  context.read<ExpenseBloc>().add(CreateExpense(Expense(
                        name: nameController.text,
                        amount: double.parse(amountController.text),
                        date: DateTime.now(),
                      )));
                  nameController.clear();
                  amountController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill all the fields'),
                  ));
                }
              },
              child: const Text('Save'),
            ),
          ]),
    );
  }

  void openEditBox(Expense expense) {
    nameController.text = expense.name;
    amountController.text = expense.amount.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: expense.name,
                ),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  hintText: expense.amount.toString(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                amountController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  context.read<ExpenseBloc>().add(UpdateExpense(
                      expense: expense,
                      updatedExpense: Expense(
                        name: nameController.text,
                        amount: double.parse(amountController.text),
                        date: DateTime.now(),
                      )));
                  nameController.clear();
                  amountController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill all the fields'),
                  ));
                }
              },
              child: const Text('Save'),
            ),
          ]),
    );
  }

  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context.read<ExpenseBloc>().add(DeleteExpense(expense: expense));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                DateFormat('MMM yy').format(
                                    DateTime(state.year, state.month, 1)),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.currency_rupee),
                              Text(
                                state.totalExpense.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              BlocBuilder<GraphBloc, GraphState>(
                builder: (context, state) {
                  if (state is GraphError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  if (state is GraphLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is GraphLoaded) {
                    int startMonth = state.startMonth;
                    int startYear = state.startYear;
                    int currentMonth = DateTime.now().month;
                    int currentYear = DateTime.now().year;

                    int monthCount = (currentYear - startYear) * 12 +
                        currentMonth -
                        startMonth +
                        1;
                    final monthlyTotal = state.monthlyTotal;
                    List<double> monthlySummary = List.generate(monthCount,
                        (index) => monthlyTotal[startMonth + index] ?? 0.0);
                    return SizedBox(
                      height: 250,
                      child: BarGraph(
                        monthlySummary: monthlySummary,
                        startMonth: startMonth,
                        startYear: startYear,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpenseError) {
                      return Center(
                        child: Text(state.error),
                      );
                    }
                    if (state is ExpenseLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is ExpenseLoaded) {
                      context.read<GraphBloc>().add(GetGraphData());
                      return ListView.builder(
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = state.expenses[index];
                          return MyListTile(
                            title: expense.name,
                            trailing: expense.amount.toString(),
                            onEditPressed: (expense.date.month ==
                                        DateTime.now().month &&
                                    expense.date.year == DateTime.now().year)
                                ? (context) => openEditBox(expense)
                                : (context) => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'You can only edit expenses of the current month'),
                                    )),
                            onDeletePressed: (expense.date.month ==
                                        DateTime.now().month &&
                                    expense.date.year == DateTime.now().year)
                                ? (context) => openDeleteBox(expense)
                                : (context) => ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'You can only delete expenses of the current month'),
                                    )),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
