import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart';

String monthIntToString(int m) {
  switch (m) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

String toDateString(DateTime date) {
  String d = "";
  d += date.day.toString() +
      ' ' +
      monthIntToString(date.month) +
      ' ' +
      date.year.toString();
  return d;
}

String toTimeString(DateTime date){
  String d = "";
  d+=date.hour.toString();
  d+=':';
  if(date.minute<10){
    d+='0'+date.minute.toString();
  }else{
    d+=date.minute.toString();
  }
  // d+=':';
  // if(date.second<10){
  //   d+='0'+date.second.toString();
  // }else{
  //   d+=date.second.toString();
  // }
  return d;
}

String toDateTimeString(DateTime date){
  String d = ""+toDateString(date);
  return d;
}

Map<String, dynamic> parseResponse(Response response) {
  Map<String, dynamic> res = Map<String, dynamic>();
  if (response.statusCode == 500) {
    res['status'] = 'error';
    res['error'] = response.reasonPhrase;
  } else {
    try {
      res = json.decode(response.body);
    } catch (error) {
      res['status'] = 'error';
      res['error'] = error.toString();
    }
  }
  return res;
}

int _getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return int.parse(hexColor, radix: 16);
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

MaterialColor hexToMaterialColor(final String hexColor) {
  Map<int, Color> color = {
    50: HexColor(hexColor).withOpacity(0.1),
    100: HexColor(hexColor).withOpacity(0.2),
    200: HexColor(hexColor).withOpacity(0.3),
    300: HexColor(hexColor).withOpacity(0.4),
    400: HexColor(hexColor).withOpacity(0.5),
    500: HexColor(hexColor).withOpacity(0.6),
    600: HexColor(hexColor).withOpacity(0.7),
    700: HexColor(hexColor).withOpacity(0.8),
    800: HexColor(hexColor).withOpacity(0.9),
    900: HexColor(hexColor).withOpacity(1),
  };

  return MaterialColor(_getColorFromHex(hexColor), color);
}

MaterialColor getPrimaryColor() {
  return hexToMaterialColor('#0DAC8E');
}

MaterialColor getAccentColor() {
  return hexToMaterialColor('#2952FF');
}
