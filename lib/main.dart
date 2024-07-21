import 'package:expense_tracker_app/bloc/expense%20bloc/expense_bloc.dart';
import 'package:expense_tracker_app/bloc/graph%20bloc/graph_bloc.dart';
import 'package:expense_tracker_app/data/provider/data_provider.dart';
import 'package:expense_tracker_app/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataProvider.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ExpenseBloc()),
        BlocProvider(create: (context) => GraphBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
