import 'package:suppy_employees/models/employee.dart';
import 'package:suppy_employees/redux/actions.dart';
import 'package:suppy_employees/redux/app_state.dart';
import 'package:redux/redux.dart';

AppState updateEmployeesReducer(AppState state, dynamic action) {
  //TODO: Check if there's another method intead of if else

  if (action is InitializeEmployeesAction) {
    return AppState(employees: [...action.initilizedEmployees]);
  } else if (action is UpdateEmployeesAction) {
    return AppState(
        employees: [...state.employees, ...action.updatedEmployees]);
  }

  return state;
}
