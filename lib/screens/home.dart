import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:suppy_employees/models/employee.dart';
import 'package:suppy_employees/network/employees_api.dart';
import 'package:suppy_employees/provider/employees_provider.dart';
import 'package:suppy_employees/redux/actions.dart';
import 'package:suppy_employees/redux/app_state.dart';
import 'package:suppy_employees/screens/employee_details.dart';
import 'package:suppy_employees/screens/employees.dart';

enum ApiResultStates { INIT, LOADING, DONE }

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();
  final EmployeesAPI apiService = EmployeesAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Searching for an employee"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: 'search for an employee by Id'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _searchEmployeeById(context),
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            Consumer<EmployeesProvider>(
              builder: (context, provider, child) => SizedBox(
                height: 200,
                child: Center(
                  child: (provider.apiCallState == "LOADING")
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        )
                      : (provider.isEmployeeNotFound)
                          ? const Text(
                              "No Employee Found with this ID",
                              style:
                                  TextStyle(fontSize: 17.0, color: Colors.red),
                            )
                          : Container(),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => _getAllEmployees(context),
                child: Text("See All Employees")),
          ],
        ),
      ),
    );
  }

  _searchEmployeeById(context) async {
    EmployeesProvider employeesProvider =
        Provider.of<EmployeesProvider>(context, listen: false);
    try {
      if (_searchController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please Enter Employee Id"),
        ));
        return;
      }
      var employeeId = _searchController.text;
      employeesProvider.updateApiState("LOADING");
      var result = await apiService.get('/employees/$employeeId');
      employeesProvider.updateApiState("DONE");
      employeesProvider.updateEmployeeFoundFlag(false);
      Employee employee = Employee.fromJson(result);
      employeesProvider.selectEmployee(employee);
      // navigate to employees details
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmployeeDetailsScreen()));
      return true;
    } catch (error) {
      employeesProvider.updateApiState("DONE");
      employeesProvider.updateEmployeeFoundFlag(true);
      print('_searchEmployeeById function ERROR > $error');
      // rethrow;
    }
  }

  /* Get List Of All Employees*/
  _getAllEmployees(context) async {
    //TODO: Should initialze provide from one place
    EmployeesProvider employeesProvider =
        Provider.of<EmployeesProvider>(context, listen: false);
    try {
      employeesProvider.updateApiState("LOADING");
      var result = await apiService.get('/employees'); //?page=1&limit=12
      // convert api result of type dynamic list to employees list
      List<Employee> list = <Employee>[];
      for (var i = 0; i < result.length; i++) {
        var row = result[i];
        Employee employee = Employee.fromJson(row);
        list.add(employee);
      }
      // dispatch redux update employees list action
      StoreProvider.of<AppState>(context).dispatch(UpdateEmployeeAction(list));
      // navigate to employees screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EmployeesScreen()));
    } catch (error) {
      //TODO: Should use logs instead + show error msg to user
      print('_getAllEmployees function ERROR > $error');
      // rethrow;
    } finally {
      employeesProvider.updateApiState("DONE");
    }
  }
}
