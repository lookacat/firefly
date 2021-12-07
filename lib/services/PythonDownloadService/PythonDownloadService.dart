import 'package:Firefly/services/PythonDownloadService/PythonInstance.dart';

class PythonDownloadService {
	static const PYTHON_SERVICE_NUMBER = 1; // 2 Instances crash at the moment TODO: fix
	static List<PythonInstance> pythonInstances = new List<PythonInstance>();

	static void initializeAndBindEvents() async {
		for(int i=0; i < PYTHON_SERVICE_NUMBER; i++) {
			PythonInstance pyInstance = new PythonInstance();
			await pyInstance.initialize(i, 'python_download_service.py');
			pythonInstances.add(pyInstance);
		}	
	}
	static PythonInstance _getFreePythonInstance() {
		for(PythonInstance inst in pythonInstances) {
			if(!inst.isBusy()) return inst;
		}
		return pythonInstances.first;
	}
	static Future<String> downloadVideo(String id) async {
		PythonInstance free = _getFreePythonInstance();
		return await free.callFunction('downloadId', [id]);
	}
}