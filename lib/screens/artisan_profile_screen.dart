import 'package:flutter/material.dart';
import '../models/artisan.dart';
import '../services/api_service.dart';

class ArtisanProfileScreen extends StatefulWidget {
  const ArtisanProfileScreen({Key? key}) : super(key: key);

  @override
  State<ArtisanProfileScreen> createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends State<ArtisanProfileScreen> {
  Artisan? _artisan;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Artisan) {
      _fetchArtisan(arg.id);
    } else if (arg is String) {
      _fetchArtisan(arg);
    } else {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchArtisan(String id) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final artisan = await ApiService.fetchArtisanById(id);
    setState(() {
      _artisan = artisan;
      _isLoading = false;
      _hasError = artisan == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_hasError || _artisan == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load artisan profile.')),
      );
    }
    final artisan = _artisan!;
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
                  backgroundImage: artisan.gallery.isNotEmpty
                      ? NetworkImage(artisan.gallery.first.url)
                      : const AssetImage('assets/images/artisan_profile.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 20),
                Text(
                  artisan.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  artisan.profession,
                  style:
                      const TextStyle(color: Color(0xFFB49A87), fontSize: 16),
                ),
                Text(
                  artisan.city,
                  style:
                      const TextStyle(color: Color(0xFFB49A87), fontSize: 15),
                ),
                const SizedBox(height: 16),
                Text(
                  artisan.description,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Gallery
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: artisan.gallery.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final img = artisan.gallery[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          img.url,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/images/gallery1.png',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Specialties
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Specialties',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: artisan.specialties
                        .map((label) => _SpecialtyChip(label: label))
                        .toList(),
                  ),
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
      child: Image.asset(imagePath, width: 70, height: 70, fit: BoxFit.cover),
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
        style: const TextStyle(color: Colors.black87, fontSize: 14),
      ),
    );
  }
}
