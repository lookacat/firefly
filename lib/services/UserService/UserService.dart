
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:Firefly/models/User.dart';
import 'package:Firefly/services/UserService/UserServiceStore.dart';
import 'package:http/http.dart' as http;

class UserService {
	static final String apiHost = 'http://5.45.96.16:5000/';
	static Future<bool> login(String username, String password) async {
		Map<String, String> body = {
			'email': username,
			'password': md5.convert(utf8.encode(password)).toString()
		};
		Map<String, String> headers = {
			'Content-type': 'application/x-www-form-urlencoded',
			'Accept': 'application/json',
		};
		var response = await http.post(apiHost + 'user/login', body: body, headers: headers);
		var decoded = jsonDecode(response.body);
		var success = decoded['success'];
		var session = decoded['message'];
		if(success){
      print("SESSION!!::");
      print(session);
			UserServiceStore.store.setUser(new User(session: session));
			UserServiceStore.store.saveToLocalStorage();
		}
		return (decoded['success'] as bool);
	}
	static Future<Map<String, dynamic>> register(String username, String password, String firstName, String lastName) async {
		Map<String, String> body = {
			'email': username,
			'password': md5.convert(utf8.encode(password)).toString(),
			'firstName': firstName,
			'lastName': lastName
		};
		Map<String, String> headers = {
			'Content-type': 'application/x-www-form-urlencoded',
			'Accept': 'application/json',
		};
		var response = await http.post(apiHost + 'user/register', body: body, headers: headers);
		return jsonDecode(response.body);
	}
	static Future<bool> sessionVerify(String hash) async {
		Map<String, String> body = {
			'hash': hash,
		};
		Map<String, String> headers = {
			'Content-type': 'application/x-www-form-urlencoded',
			'Accept': 'application/json',
		};
		var response = await http.post(apiHost + 'user/session/verify', body: body, headers: headers);
		var decoded = jsonDecode(response.body);
		var success = decoded['success'] as bool;
		if(!success){
			UserServiceStore.store.setUser(new User(session: ''));
			UserServiceStore.store.saveToLocalStorage();
		}
		return success;
	}
}