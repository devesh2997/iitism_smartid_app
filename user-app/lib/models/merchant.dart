import 'dart:convert';

class Merchant {
  final String businessName;
  final String firstName;
  final String middleName;
  final String lastName;

  Merchant({this.businessName, this.firstName, this.middleName, this.lastName});

  factory Merchant.fromMap(Map data) {
    if(data == null )return null;
    return Merchant(
      businessName: data['business_name'] ?? '',
      firstName: data['first_name'] ?? '',
      middleName: data['middle_name'] ?? '',
      lastName: data['last_name'] ?? '',
    );
  }
}
