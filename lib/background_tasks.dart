import 'package:workmanager/workmanager.dart';
import 'location_service.dart';


@pragma('vm:entry-point')
void callbackDispatcher() {
  print("MAMAMMAMAMAMAAMMMMA 👁️🔥👁️🔥👁️🔥👁️🔥👁️🔥👁️🔥");
  Workmanager().executeTask((task, inputData) async {

    switch (task) {
      case 'locationUpdateTask':
        await LocationService.sendLocationUpdate();
        break;
    }
    return Future.value(true);
  });
}