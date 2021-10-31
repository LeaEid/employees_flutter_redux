/* Manage state of employees list */

import 'package:suppy_employees/models/employee.dart';

class AppState {
  List<Employee> employees;
  AppState({this.employees = const []});
}
