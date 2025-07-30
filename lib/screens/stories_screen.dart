import 'package:flutter/material.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  int _selectedIndex = 2;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Stories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/story_details');
                    },
                    child: const _StoryListItem(
                      imagePath: 'assets/images/golden_stool.png',
                      title: 'The Golden Stool of the Ashanti',
                      description:
                          'Unveil the legend of the sacred Golden Stool — a symbol of unity, power, and the soul of the Ashanti Kingdom.',
                      iconType: _StoryIconType.audio,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/story_details');
                    },
                    child: const _StoryListItem(
                      imagePath: 'assets/images/Adinkra clothing.png',
                      title: 'Adinkra Cloth: Language in Symbols',
                      description:
                          'Uncover the sacred art of Adinkra printing—where every symbol tells a story.',
                      iconType: _StoryIconType.book,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/story_details');
                    },
                    child: const _StoryListItem(
                      imagePath: 'assets/images/Anansi the Spider.png',
                      title: 'Anansi the Spider:',
                      description:
                          'Dive into the mischief and magic of Anansi the spider, the cleverest trickster in all the land',
                      iconType: _StoryIconType.audio,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/story_details');
                    },
                    child: const _StoryListItem(
                      imagePath: 'assets/images/Kente clothing.jpg',
                      title: 'Kente Cloth: Weaving',
                      description:
                          'Explore the rich meaning woven into every thread of Ghanaian Kente ,a cloth of kings, heritage, and pride."',
                      iconType: _StoryIconType.book,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/story_details');
                    },
                    child: const _StoryListItem(
                      imagePath: 'assets/images/highlife.png',
                      title: 'Highlife Music: Rhythms',
                      description:
                          'Immerse yourself in the rhythms of Highlife music, a',
                      iconType: _StoryIconType.audio,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/story_details');
                    },
                    child: const _StoryListItem(
                      imagePath: 'assets/images/Ghanian festivals.jpg',
                      title: 'Festivals of Ghana:',
                      description:
                          'Uncover the festivals that honor the land, the people, and the past.,',
                      iconType: _StoryIconType.book,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

enum _StoryIconType { audio, book }

class _StoryListItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final _StoryIconType iconType;
  const _StoryListItem({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.iconType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          iconType == _StoryIconType.audio
              ? const Icon(Icons.headset, color: Colors.black54)
              : const Text('B',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black54)),
        ],
      ),
    );
  }
}
