import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:suppy_employees/models/employee.dart';
import 'package:suppy_employees/network/employees_api.dart';
import 'package:suppy_employees/provider/employees_provider.dart';
import 'package:suppy_employees/redux/actions.dart';
import 'package:suppy_employees/redux/app_state.dart';
import 'package:suppy_employees/screens/employee_details.dart';

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final EmployeesAPI apiService = EmployeesAPI();

  bool isLoadingVertical = false;
  final _pageLimit = 15;
  var _pageKey = 2;
  var _isLoadingFinished = false;

  @override
  void initState() {
    _loadMoreVertical();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Should dispose scroll listener if exists
    super.dispose();
  }

  Future _loadMoreVertical() async {
    if (_isLoadingFinished) {
      return;
    }
    setState(() {
      isLoadingVertical = true;
    });

    var result =
        await apiService.get('/employees?page=$_pageKey&limit=$_pageLimit');

    // convert api result of type dynamic list to employees list
    List<Employee> list = <Employee>[];
    for (var i = 0; i < result.length; i++) {
      var row = result[i];
      Employee employee = Employee.fromJson(row);
      list.add(employee);
    }

    if (list.length < _pageLimit) {
      _isLoadingFinished = true;
    }
    // dispatch redux update employees list action
    StoreProvider.of<AppState>(context).dispatch(UpdateEmployeesAction(list));

    setState(() {
      isLoadingVertical = false;
      _pageKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List of Employees"),
        ),
        body: LazyLoadScrollView(
          isLoading: isLoadingVertical,
          scrollOffset: 100,
          onEndOfPage: () => _loadMoreVertical(),
          child: Scrollbar(
            child: ListView(children: [
              StoreConnector<AppState, List<Employee>>(
                converter: (store) => store.state.employees,
                builder: (context, List<Employee> allEmployees) => (allEmployees
                        .isEmpty)
                    ? const Center(
                        child: Text(
                          "No Employees Found",
                          style: TextStyle(fontSize: 23.0, color: Colors.grey),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 30.0),
                            child: const Text(
                              "Select an employee to see his/her details",
                              style:
                                  TextStyle(fontSize: 23.0, color: Colors.grey),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: allEmployees.length,
                            itemBuilder: (context, position) {
                              return InkWell(
                                onTap: () {
                                  _getEmployeeDetails(
                                      context, allEmployees[position]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allEmployees[position].firstname +
                                              '    ' +
                                              allEmployees[position].lastname,
                                          style: const TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.black),
                                        ),
                                        const Divider(color: Colors.black)
                                      ]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ),
              (isLoadingVertical)
                  ? const Center(
                      widthFactor: 1,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Container()
            ]),
          ),
        )
        /*SingleChildScrollView(
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
      ),*/
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
