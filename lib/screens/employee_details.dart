import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suppy_employees/models/employee.dart';
import 'package:suppy_employees/provider/employees_provider.dart';
import 'package:suppy_employees/utils.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final EmployeesProvider employeesProvider = EmployeesProvider();
  final Utils _utils = Utils();

  EmployeeDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Details"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<EmployeesProvider>(
                  builder: (context, provider, child) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10.0),
                              child: Text(
                                provider.selectedEmployee.firstname +
                                    '   ' +
                                    provider.selectedEmployee.lastname,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Date of Birth:  ' +
                                    _utils.formatDate(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            provider
                                                .selectedEmployee.dateOfBirth),
                                        'dd/MM/yyyy'),
                                style: const TextStyle(
                                    fontSize: 17.0, color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Position:  ' +
                                    provider.selectedEmployee.position,
                                style: const TextStyle(
                                    fontSize: 17.0, color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Is still employed:  ' +
                                    provider.selectedEmployee.isActive
                                        .toString(),
                                style: const TextStyle(
                                    fontSize: 17.0, color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'Start Date:  ' +
                                    _utils.formatDate(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            provider
                                                .selectedEmployee.startDate),
                                        'dd/MM/yyyy'),
                                style: const TextStyle(
                                    fontSize: 17.0, color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                'End Date:  ' +
                                    _utils.formatDate(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            provider.selectedEmployee.endDate),
                                        'dd/MM/yyyy'),
                                style: const TextStyle(
                                    fontSize: 17.0, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: Create widget for the text Fields