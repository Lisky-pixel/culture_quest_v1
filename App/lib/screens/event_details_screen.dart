import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/event.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)?.settings.arguments as Event?;
    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Details')),
        body: const Center(child: Text('No event data provided.')),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar with back button and title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Event Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // To balance the back button
              ],
            ),
            // Event image
            Container(
              width: double.infinity,
              color: const Color(0xFFF7EFE7),
              child: AspectRatio(
                aspectRatio: 2.2,
                child: _buildEventImage(event),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Date & Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatEventDateTime(event),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMapWidget(event),
                      const SizedBox(height: 10),
                      Text(
                        event.venue.isNotEmpty ? event.venue : event.address,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventDateTime(Event event) {
    final start = event.startDate;
    final end = event.endDate;

    // Day names
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Month names
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final dayName = dayNames[start.weekday - 1];
    final monthName = monthNames[start.month - 1];
    final date = '$dayName, $monthName ${start.day}, ${start.year}';

    final startTime = _formatTime(start);
    final endTime = _formatTime(end);

    return '$date · $startTime - $endTime';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }

  Widget _buildMapWidget(Event event) {
    // Check if coordinates are available and valid
    if (event.coordinates == null ||
        (event.coordinates!.latitude == 0.0 &&
            event.coordinates!.longitude == 0.0)) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Location not available',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: _buildSafeGoogleMap(event),
      ),
    );
  }

  Widget _buildSafeGoogleMap(Event event) {
    try {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            event.coordinates!.latitude,
            event.coordinates!.longitude,
          ),
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('event_location'),
            position: LatLng(
              event.coordinates!.latitude,
              event.coordinates!.longitude,
            ),
            infoWindow: InfoWindow(
              title: event.title,
              snippet: event.venue.isNotEmpty ? event.venue : event.address,
            ),
          ),
        },
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          // Map created successfully
        },
      );
    } catch (e) {
      // Fallback if Google Maps fails to load
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Map temporarily unavailable',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                'Please check your internet connection',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildEventImage(Event event) {
    // Check if we have a valid image URL (not example.com or empty)
    if (event.images.isEmpty ||
        event.images.first.isEmpty ||
        event.images.first.contains('example.com')) {
      return _buildEventPlaceholder();
    }

    return Image.network(
      event.images.first,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xFFF7EFE7),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildEventPlaceholder();
      },
    );
  }

  Widget _buildEventPlaceholder() {
    return Container(
      color: const Color(0xFFF7EFE7),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 48,
              color: Colors.orange,
            ),
            SizedBox(height: 8),
            Text(
              'Event Image',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
