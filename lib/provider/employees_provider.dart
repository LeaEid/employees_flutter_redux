import 'package:flutter/cupertino.dart';
import 'package:suppy_employees/models/employee.dart';

//TODO: check enum solution for api call states
class EmployeesProvider extends ChangeNotifier {
  String _apiCallState = "INIT";
  bool _isEmployeeNotFound = false;
  Employee _selectedEmployee =
      Employee('', 'test test', '', 0, '', false, 0, 0);

  void selectEmployee(Employee employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  void updateEmployeeFoundFlag(bool value) {
    _isEmployeeNotFound = value;
    notifyListeners();
  }

  void updateApiState(String state) {
    _apiCallState = state;
    notifyListeners();
  }

  Employee get selectedEmployee => _selectedEmployee;
  bool get isEmployeeNotFound => _isEmployeeNotFound;
  String get apiCallState => _apiCallState;
}
