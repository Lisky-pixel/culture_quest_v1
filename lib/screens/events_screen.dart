import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedIndex = 1;

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
    setState(() {
      _selectedIndex = index;
    });
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
              const Row(
                children: [
                  _FilterChip(label: 'Category', icon: Icons.category),
                  SizedBox(width: 8),
                  _FilterChip(label: 'Date', icon: Icons.calendar_today),
                  SizedBox(width: 8),
                  _FilterChip(label: 'Location', icon: Icons.location_on),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/event_details');
                      },
                      child: const _EventListItem(
                        category: 'Music',
                        title: 'Afrobeat Fusion Night',
                        description:
                            'Experience the vibrant rhythms of Afrobeat combined with modern electronic sounds. Featuring DJ Kojo and live performances.',
                        imagePath: 'assets/images/afrobeat.png',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/event_details');
                      },
                      child: const _EventListItem(
                        category: 'Culture',
                        title: 'Traditional Dance Workshop',
                        description:
                            'Learn the steps and stories behind traditional dances from various regions. Open to all skill levels.',
                        imagePath: 'assets/images/dance.png',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/event_details');
                      },
                      child: const _EventListItem(
                        category: 'Music',
                        title: 'Highlife Revival Concert',
                        description:
                            'Celebrate the golden era of Highlife music with legendary artists and contemporary performers.',
                        imagePath: 'assets/images/highlife.png',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/event_details');
                      },
                      child: const _EventListItem(
                        category: 'Culture',
                        title: 'Storytelling Under the Stars',
                        description:
                            'Gather around for an evening of captivating tales and folklore shared by master storytellers.',
                        imagePath: 'assets/images/storytelling.png',
                      ),
                    ),
                  ],
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
  const _FilterChip({required this.label, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.black54),
      label: Text(label, style: const TextStyle(color: Colors.black87)),
      backgroundColor: const Color(0xFFF5F1EE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    );
  }
}

class _EventListItem extends StatelessWidget {
  final String category;
  final String title;
  final String description;
  final String imagePath;
  const _EventListItem({
    required this.category,
    required this.title,
    required this.description,
    required this.imagePath,
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
                    fontSize: 13,
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
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
