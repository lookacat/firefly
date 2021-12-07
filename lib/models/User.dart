import 'package:flutter/widgets.dart';

class User {
	String email = '';
	String firstName = '';
	String lastName = '';
	String session = '';
	User({
		this.email,
		this.firstName,
		this.lastName,
		@required this.session
	});
	User.fromJson(Map<String, dynamic> json)
		: email = json['email'],
		firstName = json['firstName'],
		lastName = json['lastName'],
		session = json['session'];

	Map<String, dynamic> toJson() => {
		'email': email,
		'firstName': firstName,
		'lastName': lastName,
		'session': session
	};
}