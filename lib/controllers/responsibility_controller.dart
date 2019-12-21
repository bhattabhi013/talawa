import 'package:flutter_quito/model/activity.dart';
import 'package:flutter_quito/model/responsibility.dart';
import 'package:flutter_quito/model/user.dart';
import 'package:flutter_quito/views/pages/_pages.dart';
import 'package:flutter_quito/views/widgets/_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_quito/utils/globals.dart';

class ResponsibilityController {
  Future<List<Responsibility>> getResponsibilitiesByActivity(
      String activityId) async {
    final response = await http
        .get(baseRoute + "/responsibility/getByActivity/" + activityId);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var data = json.decode(response.body);
      data = data['responsibilities'];
      return (data as List)
          .map((resp) => new Responsibility.fromJson(resp))
          .toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load responsibilities');
    }
  }
  Future<Responsibility> getResponsibility(
      String respId) async {
    final response = await http
        .get(baseRoute + "/responsibility/" + respId);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var data = json.decode(response.body);
      return new Responsibility.fromJson(data);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load responsibilities');
    }
  }

  Future postResponsibility(BuildContext context, Responsibility resp) async {
    Map<String, dynamic> requestBody = {
      "name": resp.name,
      "datetime": resp.date,
      "description": resp.description,
      "activity": resp.activity,
      "asignee": resp.asignee
    };
    Map<String, String> headers = {'Content-Type': 'application/json'};
    try {
      final response = await http
          .post(baseRoute + '/responsibility',
              headers: headers, body: jsonEncode(requestBody))
          .timeout(Duration(seconds: 20));
      switch (response.statusCode) {
        case 201:
          {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => new HomePage()));
            return response.body;
          }
          break;
        case 401:
          {
            showAlertDialog(
                context, "Unauthorized", "You are unauthorized to login", "Ok");
          }
          break;
        case 403:
          {
            showAlertDialog(
                context, "Forbidden", "Forbidden access to resource", "Ok");
          }
          break;
        case 415:
          {
            showAlertDialog(context, "Invalid media", "", "Ok");
          }
          break;
        case 500:
          {
            showAlertDialog(context, "Something drastic happened", "", "Ok");
          }
          break;
        default:
          {
            showAlertDialog(context, "Something happened", "", "Ok");
          }
          break;
      }
    } catch (e) {
      showAlertDialog(context, e.toString(), e.toString(), "Ok");
    }
  }

  Future<List<User>> getUsersByActivity(String activityId) async {
    final response = await http
        .get(baseRoute + "/responsibility/getUsersByActivity/" + activityId);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var data = json.decode(response.body);
      data = data['users'];
      return (data as List)
          .map((user) => new User.fromJson(user))
          .toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load users');
    }
  }
}
