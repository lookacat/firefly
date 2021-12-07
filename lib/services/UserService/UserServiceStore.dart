import 'dart:convert';
import 'dart:io';

import 'package:Firefly/models/User.dart';
import 'package:Firefly/services/UserService/UserService.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
part 'UserServiceStore.g.dart';

class UserServiceStoreA = UserServiceStoreBase with _$UserServiceStoreA;

abstract class UserServiceStoreBase with Store {
	@observable
	User user;

	@action
	void setUser(User user) {
		this.user = user;
		saveToLocalStorage();
	}

	Future<void> saveToLocalStorage() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/user');
		String encodedData = jsonEncode(user);
		file.writeAsStringSync(encodedData);
	}
	Future<void> deleteLocalStorage() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/user');
		file.writeAsStringSync('[]');
		loadLocalStorage();
	}
	Future<void> loadLocalStorage({int iteration=0}) async {
		try{
			final directory = await getApplicationDocumentsDirectory();
			final file = File('${directory.path}/user');
			this.user = jsonDecode(file.readAsStringSync());
		} catch (Exception){

		}
	}
}
class UserServiceStore {
	static final UserServiceStoreA store = new UserServiceStoreA();
}



