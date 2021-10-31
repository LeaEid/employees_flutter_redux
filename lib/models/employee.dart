class Employee {
  String id;
  String firstname;
  String lastname;
  int dateOfBirth;
  String position;
  final bool isActive;
  final int startDate;
  final int endDate;


  Employee(this.id, this.firstname, this.lastname, this.dateOfBirth, this.position, this.isActive, this.startDate, this.endDate);

  Employee.fromJson(Map<String, dynamic> json)
      : id = json['id:'],
        firstname = json['firstName'] ?? '',
        lastname = json['lastName'], 
        dateOfBirth = json['dateOfBirth'],
        position = json['position'],
        isActive = json['isActive'],
        startDate = json['startDate'],
        endDate = json['endDate'];
}