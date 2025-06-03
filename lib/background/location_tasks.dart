import 'package:workmanager/workmanager.dart';
import 'package:afet_acil_durum_app/services/location/location_service.dart';

const fetchLocationTask = "fetchLocationTask";

@pragma('vm:entry-point') // entry point for background task execution
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // check if the current task is the fetch location task
    if (task == fetchLocationTask) {
      // get the current location using LocationService
      await LocationService().getCurrentLocation();
    }
    // signal that the task is complete
    return Future.value(true);
  });
}