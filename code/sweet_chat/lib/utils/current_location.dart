library current_location;

import 'dart:convert';

// import 'package:latlong2/latlong.dart';

import 'package:http/http.dart' as http;


class Location {
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? timezone;
  double? latitude;
  double? longitude;
  String? isp;
  String? currentIP;

  Location({
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.timezone,
    this.latitude,
    this.longitude,
    this.isp,
    this.currentIP,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'] as String,
      countryCode: json['countryCode'] as String,
      region: json['region'] as String,
      regionName: json['regionName'] as String,
      timezone: json['timezone'] as String,
      latitude: json['lat'] as double,
      longitude: json['lon'] as double,
      isp: json['isp'] as String,
      currentIP: json['query'] as String,
    );
  }
}

class UserLocation {
  UserLocation._();

  static Future<Location?> getValue() async {
    http.Response response = await http.get(
      Uri.parse('http://ip-api.com/json'),
    );

    if (response.statusCode != 200) {
      Future.error('Failed to get location');
    }

    return Location.fromJson(jsonDecode(response.body));
  }

  static Future<Location> latlng() async {
    
    Location? lc = await getValue();

    // if (lc != null) {
    //   return LatLng(lc.latitude!, lc.longitude!);
    // }

    return lc!;
  }

// FutureBuilder(
//         future: UserLocation.getValue(),
//         builder: (BuildContext context, dynamic snapshot) {
//           if (snapshot.hasData) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text('Country: ${snapshot.data!.country}'),
//                   Text('Country Code: ${snapshot.data!.countryCode}'),
//                   Text('Region: ${snapshot.data!.region}'),
//                   Text('Region Name: ${snapshot.data!.regionName}'),
//                   Text('Timezone: ${snapshot.data!.timezone}'),
//                   Text('Latitude: ${snapshot.data!.latitude}'),
//                   Text('Longitude: ${snapshot.data!.longitude}'),
//                   Text('ISP: ${snapshot.data!.isp}'),
//                   Text('Current IP: ${snapshot.data!.currentIP}'),
//                 ],
//               ),
//             );
//           }
//           return const CircularProgressIndicator();
//         },
//       ),

// LatLng usrCoor = LatLng(6.406793, 2.2899);
//   // late final Location? userLocation =  await UserLocation.getValue();

//   Future<List> latlng() async {
//     Location i = await UserLocation.latlng();
//     setState(() {
//       usrCoor = LatLng(i.latitude!, i.longitude!);
//     });
//     print(usrCoor.latitude );
//     print(usrCoor.longitude );

//     return [];
//   }
   // UserLocation.getValue().then((value) {
    //   print(value?.latitude);
    // });


}
