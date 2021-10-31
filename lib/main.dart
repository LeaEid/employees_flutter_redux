// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:suppy_employees/models/employee.dart';
import 'package:suppy_employees/provider/employees_provider.dart';
import 'package:suppy_employees/redux/reducer.dart';
import 'package:suppy_employees/screens/home.dart';

import 'redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Store<AppState> _store = Store<AppState>(
    updateEmployeesReducer,
    initialState: AppState(
      employees: [],
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EmployeesProvider(),
        child: StoreProvider(
          store: _store,
          child: MaterialApp(
            title: 'Suppy Employees',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomeScreen(),
          ),
        ));
  }
}
