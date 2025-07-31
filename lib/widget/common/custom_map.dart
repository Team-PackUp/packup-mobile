import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends StatelessWidget {
  static final LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
  );
  static final Marker marker = Marker(
    markerId: MarkerId('company'),
    position: companyLatLng,
  );
  static final Circle circle = Circle(
    circleId: CircleId('circle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  const CustomMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppBar(),
        body: FutureBuilder<String>(
          future: checkPermission(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return Center(child: Text('데이터 없음'));
              }

              final result = snapshot.data!;

              if (result == '위치 권한이 허가 되었습니다.') {
                return Column(
                  children: [
                    // ...
                  ],
                );
              }

              return Center(child: Text(result));
            }
        )
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        '지도',
        style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission checkPermission = await Geolocator.checkPermission();

    if(!isLocationEnabled) {
      return '위치 서비스를 활성화해주세요';
    }

    if(checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();

      if(checkPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요';
    }

    return '위치 권한이 허가 되었습니다.';
  }
}

