import 'dart:io';

import 'package:starflut/starflut.dart';
import 'package:path_provider/path_provider.dart';

class PythonInstance {
	StarCoreFactory _pythonCoreFactory;
	StarServiceClass _pythonService;
	StarSrvGroupClass _pythonSrvGroup;
	dynamic _pythonContext;
	bool _isBusy = false;
	String _resPath;
	String _scriptFile;

	Future initialize(int uniqueNumber, String scriptFile) async {
		_scriptFile = scriptFile;
		_pythonCoreFactory = await Starflut.getFactory();
		_pythonService = await _pythonCoreFactory.initSimple(
			"pyservice$uniqueNumber", 
			"$uniqueNumber", 
			6000+uniqueNumber,
			6000+uniqueNumber, 
			[]
		);
		await _pythonCoreFactory.regMsgCallBackP(
			(int serviceGroupID, int uMsg, Object wParam, Object lParam) async{
				if( uMsg == Starflut.MSG_DISPMSG || uMsg == Starflut.MSG_DISPLUAMSG ){
					print(wParam);
				}
				print("$serviceGroupID	$uMsg	 $wParam	 $lParam");
				return null;
			}
		);
		_pythonSrvGroup = await _pythonService["_ServiceGroup"];
		await _loadLibrariesAndFiles();
		if(await _pythonSrvGroup.initRaw("python36", _pythonService) == true){
			print("init starcore($uniqueNumber) and python 3.6 successfully");
		}else{
			print("init starcore($uniqueNumber) and python 3.6 failed");
		}
		await _pythonSrvGroup.loadRawModule("python", "", _resPath + "/flutter_assets/starfiles/" + _scriptFile, false);
		_pythonContext = await _pythonService.importRawContext("python", "", false, "");

		Directory tempDir = await getTemporaryDirectory();
		await this.callFunction('init', [tempDir.path]);
	}

	Future _loadLibrariesAndFiles() async {
		bool isAndroid = await Starflut.isAndroid();
		if(isAndroid == true) {
			String libraryDir = await Starflut.getNativeLibraryDir();
			String docPath = await Starflut.getDocumentPath();
			if(libraryDir.indexOf("arm64") > 0){
				Starflut.unzipFromAssets("lib-dynload-arm64.zip", docPath, true);
			}else if(libraryDir.indexOf("x86_64") > 0){
				Starflut.unzipFromAssets("lib-dynload-x86_64.zip", docPath, true);
			}else if(libraryDir.indexOf("arm") > 0){
				Starflut.unzipFromAssets("lib-dynload-armeabi.zip", docPath, true);
			}else{
				Starflut.unzipFromAssets("lib-dynload-x86.zip", docPath, true);
			}
			await Starflut.copyFileFromAssets(_scriptFile, "flutter_assets/starfiles", "flutter_assets/starfiles");
			await Starflut.copyFileFromAssets("python3.6.zip", "flutter_assets/starfiles", null);
			_resPath = await Starflut.getResourcePath();
		}
	}

	Future<String> callFunction(String name, [ params=const [] ]) async {
		_isBusy = true;
		String result = await _pythonContext.call(name, params);
		_isBusy = false;
		return result;
	}
	bool isBusy() => _isBusy;
}