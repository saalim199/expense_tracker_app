import 'dart:math';

import 'package:expense_tracker_app/bloc/expense_bloc.dart';
import 'package:expense_tracker_app/model/expense.dart';
import 'package:expense_tracker_app/presentation/widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<ExpenseBloc>().add(ReadAllExpenses());
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
                      id: expense.id,
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

  void openDeleteBox(int id) {
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
              context.read<ExpenseBloc>().add(DeleteExpense(id: id));
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
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
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
            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense = state.expenses[index];
                return MyListTile(
                  title: expense.name,
                  trailing: expense.amount.toString(),
                  onEditPressed: (context) => openEditBox(expense),
                  onDeletePressed: (context) => openDeleteBox(expense.id),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
