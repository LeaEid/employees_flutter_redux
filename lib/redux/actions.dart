import 'package:suppy_employees/models/employee.dart';

class InitializeEmployeesAction {
  final List<Employee> initilizedEmployees;

  InitializeEmployeesAction(this.initilizedEmployees);
}

class UpdateEmployeesAction {
  final List<Employee> updatedEmployees;

  UpdateEmployeesAction(this.updatedEmployees);
}


//TODO: Check redux Epics