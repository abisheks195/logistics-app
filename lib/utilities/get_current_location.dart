import 'package:location/location.dart';

Location location = new Location();
LocationData _locationData;

Future<LocationData> getCurrentLocation() async {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();

  return _locationData;

  // Position res =
  //     await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // setState(() {
  //   position = res;
  // });
}
