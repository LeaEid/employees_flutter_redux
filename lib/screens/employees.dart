import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:suppy_employees/models/employee.dart';
import 'package:suppy_employees/network/employees_api.dart';
import 'package:suppy_employees/provider/employees_provider.dart';
import 'package:suppy_employees/redux/actions.dart';
import 'package:suppy_employees/redux/app_state.dart';
import 'package:suppy_employees/screens/employee_details.dart';

class EmployeesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Employees"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: StoreConnector<AppState, List<Employee>>(
                  converter: (store) => store.state.employees,
                  builder: (context, List<Employee> allEmployees) =>
                      (allEmployees.isEmpty)
                          ? const Center(
                              child: Text(
                                "No Employees Found",
                                style: TextStyle(
                                    fontSize: 23.0, color: Colors.grey),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 30.0),
                                  child: const Text(
                                    "Select an employee to see his/her details",
                                    style: TextStyle(
                                        fontSize: 23.0, color: Colors.grey),
                                  ),
                                ),
                                ...allEmployees
                                    .map(
                                      (employee) => InkWell(
                                        onTap: () {
                                          _getEmployeeDetails(
                                              context, employee);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  employee.firstname +
                                                      '    ' +
                                                      employee.lastname,
                                                  style: const TextStyle(
                                                      fontSize: 17.0,
                                                      color: Colors.black),
                                                ),
                                                const Divider(
                                                    color: Colors.black)
                                              ]),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getEmployeeDetails(context, Employee employee) async {
    try {
      EmployeesProvider provider =
          Provider.of<EmployeesProvider>(context, listen: false);
      provider.selectEmployee(employee);
      // navigate to employees
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmployeeDetailsScreen()),
      );
    } catch (error) {
      print('_getEmployeeDetails function ERROR > $error');
      rethrow;
    }
  }
}
