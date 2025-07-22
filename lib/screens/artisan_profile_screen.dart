import 'package:flutter/material.dart';

class ArtisanProfileScreen extends StatelessWidget {
  const ArtisanProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Artisan Profile',
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
                const SizedBox(height: 16),
                // Profile image
                CircleAvatar(
                  radius: 54,
                  backgroundImage: AssetImage(
                      'assets/images/artisan_profile.png'), // TODO: Replace with actual image
                ),
                const SizedBox(height: 20),
                const Text(
                  'Omar Marmoush',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Traditional Weaver',
                  style: TextStyle(
                    color: Color(0xFFB49A87),
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'Marrakesh, Morocco',
                  style: TextStyle(
                    color: Color(0xFFB49A87),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Omar Marmoush is a master weaver from Marrakesh, Morocco, known for his intricate designs and use of natural dyes. His work reflects the rich cultural heritage of the Moroccan people, blending traditional techniques with contemporary aesthetics.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Gallery
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _GalleryImage(imagePath: 'assets/images/gallery1.png'),
                      const SizedBox(width: 12),
                      _GalleryImage(imagePath: 'assets/images/gallery2.png'),
                      const SizedBox(width: 12),
                      _GalleryImage(imagePath: 'assets/images/gallery3.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Specialties
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Specialties',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: const [
                    _SpecialtyChip(label: 'Textile Art'),
                    _SpecialtyChip(label: 'Natural Dyes'),
                    _SpecialtyChip(label: 'Yoruba Weaving'),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1872D),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Contact Artisan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryImage extends StatelessWidget {
  final String imagePath;
  const _GalleryImage({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String label;
  const _SpecialtyChip({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }
}
