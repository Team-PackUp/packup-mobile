import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:packup/widget/common/custom_appbar.dart';


enum LocationStatus {
  notServiceActivate('서비스가 비활성화됨'),
  notAuthLocation('위치 권한 없음'),
  notAuthLocationSetting('위치 설정 미허용'),
  available('정상 사용 가능');

  final String message; // enum 타입이면 자동 getter 생성해주네
  const LocationStatus(this.message);
}

class CustomMap extends StatefulWidget {
  const CustomMap({super.key});

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  GoogleMapController? mapController;
  LatLng? currentLatLng;

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    LocationStatus result = await checkPermission();
    if (result == LocationStatus.available) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
      });
    } else {
      print(result.message);
      setState(() {
        currentLatLng = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: '구글 지도 유료인 것 같습니다.', arrowFlag: false,),
      body: currentLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLatLng!,
          zoom: 15,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  Future<LocationStatus> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (!isLocationEnabled) {
      return LocationStatus.notServiceActivate;
    }

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();
      if (checkPermission == LocationPermission.denied) {
        return LocationStatus.notAuthLocation;
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      return LocationStatus.notAuthLocationSetting;
    }

    return LocationStatus.available;
  }
}
