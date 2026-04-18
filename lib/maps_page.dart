import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'home_page.dart';
import 'education_page.dart';
import 'profile_page.dart';
import 'test_intro_page.dart';

class MapsPage extends StatefulWidget {
  final String email;
  final String? destination;

  const MapsPage({
    super.key,
    required this.email,
    this.destination,
  });

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  int currentIndex = 4;

  final Completer<GoogleMapController> _controller = Completer();

  LatLng? currentPosition;

  Set<Marker> markers = {};

  bool isLoading = true;

  /// ================== SEMUA DATA PSIKOLOG (DARI PAGE SEBELAH) ==================
  final List<Map<String, dynamic>> psychologistPlaces = [
    {
      "name": "Discoverme | Biro Psikologi",
      "address":
          "Gedung Prudential, Jl. Taruma No.17-A-B Lantai 3, Medan Petisah",
      "lat": 3.5952,
      "lng": 98.6722,
    },
    {
      "name": "Biro Psikologi Marsha Puntadewa",
      "address": "Jl. Sultan Hasanuddin No.18, Medan Baru",
      "lat": 3.5853,
      "lng": 98.6720,
    },
    {
      "name": "Biro Konsultasi Psikologi Riski Ananda",
      "address":
          "Komplek Taman Impian Indah, Jl. Banteng No.9, Medan Helvetia",
      "lat": 3.5755,
      "lng": 98.6600,
    },
    {
      "name": "Psikoplus Consulting",
      "address":
          "Komplek Setia Budi Business Point BB No.2, Medan Sunggal",
      "lat": 3.5678,
      "lng": 98.6402,
    },
    {
      "name": "YPPI Cabang Medan",
      "address": "Jl. Iskandar Muda No.127, Medan Petisah",
      "lat": 3.5921,
      "lng": 98.6751,
    },
    {
      "name": "Tes Bakat Indonesia",
      "address": "Cohive Clapham, Gg. Buntu, Medan Timur",
      "lat": 3.5890,
      "lng": 98.6900,
    },
    {
      "name": "Lembaga Psikologi Kognisia",
      "address": "Jl. Rajawali No.30, Medan Sunggal",
      "lat": 3.5700,
      "lng": 98.6450,
    },
    {
      "name": "Cosmo Integritas Indonesia",
      "address": "Jl. Kutilang No.16A, Medan Sunggal",
      "lat": 3.5650,
      "lng": 98.6420,
    },
    {
      "name": "Citra Kencana Konseling",
      "address": "Jl. Tenis No.15, Medan Kota",
      "lat": 3.5750,
      "lng": 98.6830,
    },
    {
      "name": "Psikotes Indonesia Medan",
      "address": "Jl. Sederhana, Percut Sei Tuan",
      "lat": 3.6100,
      "lng": 98.7200,
    },
    {
      "name": "Psychology Consultation Bureau UMA",
      "address": "Jl. Kolam No.1, Deli Serdang",
      "lat": 3.5200,
      "lng": 98.8600,
    },
    {
      "name": "Biro Psikologi MDF",
      "address": "Medan Tuntungan",
      "lat": 3.5420,
      "lng": 98.6150,
    },
  ];

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  /// ================= MARKER PSIKOLOG =================
  void addPsychologistMarkers() {
    for (var place in psychologistPlaces) {
      markers.add(
        Marker(
          markerId: MarkerId(place["name"]),
          position: LatLng(place["lat"], place["lng"]),
          infoWindow: InfoWindow(
            title: place["name"],
            snippet: place["address"],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRose,
          ),
        ),
      );
    }
  }

  /// ================= LOCATION =================
  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition = LatLng(position.latitude, position.longitude);

      /// USER MARKER
      markers.add(
        Marker(
          markerId: const MarkerId("user"),
          position: currentPosition!,
          infoWindow: const InfoWindow(title: "Lokasi Kamu"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );

      /// PSIKOLOG MARKER
      addPsychologistMarkers();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// ================= NAVBAR =================
  void goTo(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage(email: widget.email)),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TestIntroPage(email: widget.email)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EducationPage(email: widget.email)),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProfilePage(email: widget.email)),
      );
    }

    setState(() => currentIndex = index);
  }

  /// ================= UI (TIDAK DIUBAH SAMA SEKALI) =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Psikiater Terdekat"),
        backgroundColor: const Color(0xFF6FBF8F),
        automaticallyImplyLeading: false,
      ),

      body: Stack(
        children: [
          if (currentPosition != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition!,
                zoom: 13,
              ),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: markers,
              onMapCreated: (c) {
                if (!_controller.isCompleted) {
                  _controller.complete(c);
                }
              },
            ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6FBF8F),
        child: const Icon(Icons.map),
        onPressed: () async {
          if (currentPosition == null) return;

          final controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newLatLng(currentPosition!),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: const Color(0xffe4f4ec),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(Icons.home, "Halaman", 0),
              navItem(Icons.assignment, "Ujian", 1),
              const SizedBox(width: 40),
              navItem(Icons.menu_book, "Materi", 2),
              navItem(Icons.person, "Akun", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => goTo(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF6FBF8F) : Colors.green[700],
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}