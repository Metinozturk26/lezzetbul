import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        final lat = provider.currentLat ?? AppConstants.defaultLat;
        final lng = provider.currentLng ?? AppConstants.defaultLng;

        final Set<Marker> markers = {};

        // Kullanici konumu
        markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: const InfoWindow(title: 'Konumunuz'),
          ),
        );

        // Restoran marker'lari
        for (final restaurant in provider.restaurants) {
          markers.add(
            Marker(
              markerId: MarkerId(restaurant.placeId),
              position: LatLng(restaurant.lat, restaurant.lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
              infoWindow: InfoWindow(
                title: restaurant.name,
                snippet:
                    '${restaurant.rating?.toStringAsFixed(1) ?? '-'} ★  ${restaurant.address ?? ''}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                          placeId: restaurant.placeId),
                    ),
                  );
                },
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              provider.currentCity.isNotEmpty
                  ? '${provider.currentCity} - Harita'
                  : 'Harita',
            ),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 13,
                ),
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),
              // Restoran sayisi bilgisi
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.restaurant,
                          size: 18, color: AppConstants.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        '${provider.restaurants.length} restoran',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Konuma git butonu
              Positioned(
                bottom: 24,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 13),
                    );
                  },
                  child: const Icon(Icons.my_location,
                      color: AppConstants.primaryColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
