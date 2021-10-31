import 'package:suppy_employees/models/employee.dart';
import 'package:suppy_employees/redux/actions.dart';
import 'package:suppy_employees/redux/app_state.dart';
import 'package:redux/redux.dart';

AppState updateEmployeesReducer(AppState state, dynamic action) {
  //TODO: Check switch case method intead of if else

  if (action is UpdateEmployeeAction) {
    return AppState(employees: []..addAll(action.updatedEmployee));
  }

  return state;
}
