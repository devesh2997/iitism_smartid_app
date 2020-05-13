class User {
  final String admnNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String authId;
  final String branchId;
  final String courseId;
  final String email;
  final String mobileNo;
  final String smartIdNo;
  final double balance;

  User(
      {this.admnNo,
      this.balance,
      this.firstName,
      this.middleName,
      this.lastName,
      this.authId,
      this.branchId,
      this.courseId,
      this.email,
      this.mobileNo,
      this.smartIdNo});

  factory User.fromMap(Map map) {
    return User(
        admnNo: map['admn_no'] ?? '',
        firstName: map['first_name'] ?? '',
        middleName: map['middle_name'] ?? '',
        lastName: map['last_name'],
        authId: map['auth_id'],
        branchId: map['branch_id'],
        courseId: map['course_id'],
        email: map['email'],
        mobileNo: map['mobile_no'],
        smartIdNo: map['smartid_no'],
        balance: double.parse(map['balance'].toString()));
  }
}
