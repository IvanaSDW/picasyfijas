
import 'dart:convert';

import 'package:bulls_n_cows_reloaded/shared/constants.dart';
import 'package:http/http.dart' as http;

class HttpService {

  Future<Map<String,dynamic>> loadRandomUserData() async {
    // logger.i('Called');
    http.Response dataFromUrl = await http.get(Uri.parse(randomUserUrl));
    var jsonResponse = jsonDecode(dataFromUrl.body);
    // logger.i('Random data received: $jsonResponse');
    var userData = jsonResponse['results'][0];
    Map<String, dynamic> randomData =
    {
      playerEmailFN: userData['email'],
      playerNameFN: userData['name']['first'] + ' ' + userData['name']['last'],
      playerNickNameFN: userData['name']['first'] + userData['login']['uuid'].toString().substring(0,3),
      // playerNickNameFN: userData['login']['username'],
      playerGoogleAvatarFN: userData['picture']['large'],
      playerCountryCodeFN: userData['nat'].toString().toLowerCase(),
    };
    // logger.i('Data to update in bot doc: $randomData');
    return randomData;
  }
}