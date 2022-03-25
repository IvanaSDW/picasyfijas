import 'dart:convert';

import 'package:http/http.dart' as http;

class IpLocator {
  final String url = "http://ip-api.com/json";

  Future<String> _getLocationString() async {
    http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      return 'No Data';
    }
  }

  Future<String> getCountryName() async {
    String locationString = await _getLocationString();
    Map<String, dynamic> locationJson = jsonDecode(locationString);
    return locationJson['country']!;
  }

  Future<String> getCountryCode() async {
    String locationString = await _getLocationString();
    Map<String, dynamic> locationJson = jsonDecode(locationString);
    return locationJson['countryCode']!.toString().toLowerCase();
  }

}