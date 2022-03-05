import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youth_action_handbook/models/generic_response.dart';
import 'app_exceptions.dart';

class ApiClient {
  final httpClient = http.Client();

  Future<dynamic> get(String url) async {
    // print('Api Get, url $url');
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException('No Internet connection');
    }
    // print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> postForm(String url, Map body) async {
    // print('Api Post, url :' + url);
    // print('parameters:' + body.toString());

    var responseJson;
    try {
      final response =
          await http.post(Uri.parse(url), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException('No Internet connection');
    }
    // print('api post.');
    // print("responsejson" + responseJson.toString());

    return responseJson;
  }

  Future<dynamic> postFormWithHeader(String url, Map body) async {
    // print('Api Post, url :' + url);
    // print('parameters:' + body.toString());


    var headers = <String, String>{
      "Accept": "application/x-www-form-urlencoded",
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: body, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException('No Internet connection');
    }
    // print('api post.');
    // print("responsejson" + responseJson.toString());

    return responseJson;
  }


  Future<dynamic> post(String url, String body) async {
    // print('parameters:' + body.toString());

    var responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException('No Internet connection');
    }
    // print('api post.');
    // print(responseJson.toString());

    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    // print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(Uri.parse(url), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException('No Internet connection');
    }
    // print('api put.');
    // print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    // print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(Uri.parse(url));
      apiResponse = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException('No Internet connection');
    }
    // print('api delete.');
    return apiResponse;
  }

  dynamic _returnResponse(http.Response response) {
    var responseJson = response.body;
    GenericResponse genericResponse =
        GenericResponse.fromJson(jsonDecode(response.body));
    // print("response :" + responseJson.toString());
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 201:
        return responseJson;
      case 302:
        return responseJson;
      case 400:
        throw BadRequestException(genericResponse.message);
      case 401:
      case 403:
        throw UnauthorisedException(genericResponse.message);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communicating with Server with StatusCode : ${response.statusCode}');
    }
  }
}
