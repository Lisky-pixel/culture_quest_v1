import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedIndex = 1;
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = true;

  // Filter states
  String? _selectedCategory;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isLocationFilterActive = false;

  // Available categories
  Set<String> _availableCategories = {};

  // Helper method to capitalize category names
  String _capitalizeCategory(String category) {
    if (category.isEmpty) return category;
    return category.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    final events = await ApiService.fetchEvents();
    if (mounted) {
      setState(() {
        _events = events;
        _filteredEvents = events;
        _availableCategories = events.map((e) => e.category).toSet();
        _isLoading = false;
      });
    }
  }

  void _applyLocalFilters() {
    List<Event> filteredEvents = _events;

    // Apply category filter
    if (_selectedCategory != null) {
      filteredEvents = filteredEvents
          .where((event) => event.category == _selectedCategory)
          .toList();
    }

    // Apply date filter
    if (_fromDate != null && _toDate != null) {
      filteredEvents = filteredEvents.where((event) {
        return event.startDate
                .isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
            event.startDate.isBefore(_toDate!.add(const Duration(days: 1)));
      }).toList();
    }

    if (mounted) {
      setState(() {
        _filteredEvents = filteredEvents;
      });
    }
  }

  Future<void> _applyCategoryFilter(String? category) async {
    if (mounted) {
      setState(() {
        _selectedCategory = category;
      });
    }

    // If only category and/or date filters are active, use local filtering
    if (!_isLocationFilterActive) {
      _applyLocalFilters();
    } else {
      // If location filter is active, fetch from API
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      List<Event> filteredEvents;
      if (category != null) {
        filteredEvents = await ApiService.fetchEventsByCategory(category);
      } else {
        filteredEvents = _events;
      }

      if (mounted) {
        setState(() {
          _filteredEvents = filteredEvents;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _applyDateFilter() async {
    if (_fromDate == null || _toDate == null) return;

    // If only category and/or date filters are active, use local filtering
    if (!_isLocationFilterActive) {
      _applyLocalFilters();
    } else {
      // If location filter is active, fetch from API
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final filteredEvents =
          await ApiService.fetchEventsByDateRange(_fromDate!, _toDate!);

      if (mounted) {
        setState(() {
          _filteredEvents = filteredEvents;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _applyLocationFilter() async {
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationPermissionDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationPermissionDialog();
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final nearbyEvents = await ApiService.fetchNearbyEvents(
        position.latitude,
        position.longitude,
      );

      if (mounted) {
        setState(() {
          _filteredEvents = nearbyEvents;
          _isLocationFilterActive = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showLocationErrorDialog();
      }
    }
  }

  void _clearFilters() {
    if (mounted) {
      setState(() {
        _selectedCategory = null;
        _fromDate = null;
        _toDate = null;
        _isLocationFilterActive = false;
        _filteredEvents = _events;
      });
    }
  }

  void _showLocationPermissionDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'To find events near you, we need access to your location. '
          'Please enable location permissions in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showLocationErrorDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Error'),
        content: const Text(
          'Unable to get your current location. Please check your GPS settings '
          'and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryFilterDialog() async {
    if (!mounted) return;

    final categories = _availableCategories.toList()..sort();

    final selectedCategory = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length + 1, // +1 for "All Categories"
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: const Text('All Categories'),
                  onTap: () => Navigator.pop(context, null),
                );
              }
              final category = categories[index - 1];
              return ListTile(
                title: Text(_capitalizeCategory(category)),
                onTap: () => Navigator.pop(context, category),
              );
            },
          ),
        ),
      ),
    );

    if (mounted && (selectedCategory != null || selectedCategory == null)) {
      await _applyCategoryFilter(selectedCategory);
    }
  }

  Future<void> _showDateFilterDialog() async {
    if (!mounted) return;

    // Show dialog to select From date
    final fromDate = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020), // Allow selecting past events
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      helpText: 'Select From Date',
      confirmText: 'Next',
      cancelText: 'Cancel',
    );

    if (fromDate != null && mounted) {
      // Show dialog to select To date
      final toDate = await showDatePicker(
        context: context,
        initialDate: _toDate ??
            (fromDate.isAfter(DateTime.now()) ? fromDate : DateTime.now()),
        firstDate: fromDate, // To date must be after From date
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
        helpText: 'Select To Date',
        confirmText: 'Apply',
        cancelText: 'Back',
      );

      if (toDate != null && mounted) {
        setState(() {
          _fromDate = fromDate;
          _toDate = toDate;
        });
        await _applyDateFilter();
      }
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/events');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/stories');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/artisans');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CultureQuest',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.search, color: Colors.black, size: 28),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _FilterChip(
                    label: 'Category',
                    icon: Icons.filter_list,
                    isActive: _selectedCategory != null,
                    onTap: _showCategoryFilterDialog,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Date',
                    icon: Icons.calendar_today,
                    isActive: _fromDate != null && _toDate != null,
                    onTap: _showDateFilterDialog,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Location',
                    icon: Icons.location_on,
                    isActive: _isLocationFilterActive,
                    onTap: _applyLocationFilter,
                  ),
                  const Spacer(),
                  if (_selectedCategory != null ||
                      _fromDate != null ||
                      _isLocationFilterActive)
                    GestureDetector(
                      onTap: _clearFilters,
                      child: const Icon(Icons.clear, color: Colors.red),
                    ),
                ],
              ),
              if (_selectedCategory != null ||
                  _fromDate != null ||
                  _isLocationFilterActive)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (_selectedCategory != null)
                        Chip(
                          label: Text(
                              'Category: ${_capitalizeCategory(_selectedCategory!)}'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _applyCategoryFilter(null),
                        ),
                      if (_fromDate != null && _toDate != null)
                        Chip(
                          label: Text(
                            'Date: ${_fromDate!.day}/${_fromDate!.month} - ${_toDate!.day}/${_toDate!.month}',
                          ),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            if (mounted) {
                              setState(() {
                                _fromDate = null;
                                _toDate = null;
                              });
                            }
                            _clearFilters();
                          },
                        ),
                      if (_isLocationFilterActive)
                        Chip(
                          label: const Text('Nearby Events'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            if (mounted) {
                              setState(() {
                                _isLocationFilterActive = false;
                              });
                            }
                            _clearFilters();
                          },
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredEvents.isEmpty
                        ? const Center(child: Text('No events found'))
                        : ListView.builder(
                            itemCount: _filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = _filteredEvents[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/event_details',
                                    arguments: event,
                                  );
                                },
                                child: _EventListItem(
                                  category: _capitalizeCategory(event.category),
                                  title: event.title,
                                  description: event.description,
                                  imagePath: event.images.isNotEmpty
                                      ? event.images.first
                                      : 'assets/images/event1.png',
                                  isNetworkImage: event.images.isNotEmpty,
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Artisans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : Colors.black54,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isActive ? Colors.black : const Color(0xFFF5F1EE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
    );
  }
}

class _EventListItem extends StatelessWidget {
  final String category;
  final String title;
  final String description;
  final String imagePath;
  final bool isNetworkImage;
  const _EventListItem({
    required this.category,
    required this.title,
    required this.description,
    required this.imagePath,
    this.isNetworkImage = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description.length > 120
                      ? '${description.substring(0, 120)}...'
                      : description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: isNetworkImage
                ? Image.network(
                    imagePath,
                    width: 130,
                    height: 133,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/event1.png',
                      width: 130,
                      height: 133,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    imagePath,
                    width: 130,
                    height: 133,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }
}
