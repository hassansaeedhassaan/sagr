import 'package:sagr/core/utils/app_log.dart';
import 'package:workmanager/workmanager.dart';
import 'location_service.dart';


@pragma('vm:entry-point')
void callbackDispatcher() {
  appLog("MAMAMMAMAMAMAAMMMMA 👁️🔥👁️🔥👁️🔥👁️🔥👁️🔥👁️🔥");
  Workmanager().executeTask((task, inputData) async {

    switch (task) {
      case 'locationUpdateTask':
        await LocationService.sendLocationUpdate();
        break;
    }
    return Future.value(true);
  });
}