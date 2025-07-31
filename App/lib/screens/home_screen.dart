import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import '../models/story.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = true;
  List<Story> _stories = [];
  List<Story> _filteredStories = [];
  bool _isStoriesLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _fetchStories();
    _searchController.addListener(_filterContent);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    final events = await ApiService.fetchEvents();
    setState(() {
      _events = events;
      _filteredEvents = events;
      _isLoading = false;
    });
  }

  Future<void> _fetchStories() async {
    final stories = await ApiService.fetchStories();
    setState(() {
      _stories = stories;
      _filteredStories = stories;
      _isStoriesLoading = false;
    });
  }

  void _filterContent() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEvents = _events;
        _filteredStories = _stories;
      } else {
        _filteredEvents = _events.where((event) {
          return event.title.toLowerCase().contains(query) ||
              event.description.toLowerCase().contains(query);
        }).toList();

        _filteredStories = _stories.where((story) {
          return story.title.toLowerCase().contains(query) ||
              story.text.toLowerCase().contains(query);
        }).toList();
      }
    });
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'CultureQuest',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F1EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black45),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search for events, stories...',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Colors.black45,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                // Events section - only show if there are events or if loading
                if (_isLoading || _filteredEvents.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    _searchController.text.isNotEmpty
                        ? 'Events (${_filteredEvents.length})'
                        : 'Featured Events',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240, // Increased height for better visibility
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            itemCount: _filteredEvents.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 16),
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
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: _EventCard(
                                    imagePath: event.images.isNotEmpty
                                        ? event.images.first
                                        : null,
                                    isNetworkImage: event.images.isNotEmpty,
                                    title: event.title,
                                    description: event.description,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
                // Stories section - only show if there are stories or if loading
                if (_isStoriesLoading || _filteredStories.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    _searchController.text.isNotEmpty
                        ? 'Stories (${_filteredStories.length})'
                        : 'Explore Stories',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _isStoriesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            Expanded(
                              child: _filteredStories.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/story_details',
                                          arguments: _filteredStories[0],
                                        );
                                      },
                                      child: _StoryCard(
                                        imagePath: _filteredStories[0].videoUrl,
                                        title: _filteredStories[0].title,
                                        description: _filteredStories[0]
                                                    .text
                                                    .length >
                                                60
                                            ? '${_filteredStories[0].text.substring(0, 60)}...'
                                            : _filteredStories[0].text,
                                      ),
                                    )
                                  : Container(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _filteredStories.length > 1
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/story_details',
                                          arguments: _filteredStories[1],
                                        );
                                      },
                                      child: _StoryCard(
                                        imagePath: _filteredStories[1].videoUrl,
                                        title: _filteredStories[1].title,
                                        description: _filteredStories[1]
                                                    .text
                                                    .length >
                                                60
                                            ? '${_filteredStories[1].text.substring(0, 60)}...'
                                            : _filteredStories[1].text,
                                      ),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                ],
                const SizedBox(height: 32),
              ],
            ),
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

class _EventCard extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String description;
  final bool isNetworkImage;

  const _EventCard({
    this.imagePath,
    required this.title,
    required this.description,
    this.isNetworkImage = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: imagePath != null
                ? (isNetworkImage
                    ? Image.network(
                        imagePath!,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 130,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 130,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade100,
                                  Colors.purple.shade100,
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        imagePath!,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 130,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade100,
                                Colors.purple.shade100,
                              ],
                            ),
                          ),
                        ),
                      ))
                : Container(
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade100,
                          Colors.purple.shade100,
                        ],
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String description;

  const _StoryCard({
    this.imagePath,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // Fixed height for consistent sizing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: imagePath != null
                ? Image.network(
                    imagePath!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 100,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.orange.shade100,
                              Colors.pink.shade100,
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade100,
                          Colors.pink.shade100,
                        ],
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
