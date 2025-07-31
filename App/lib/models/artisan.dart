class Artisan {
  final String id;
  final String name;
  final String profession;
  final String address;
  final String city;
  final Coordinates? coordinates;
  final Map<String, String>? workingHours;
  final String description;
  final List<String> specialties;
  final List<GalleryItem> gallery;
  final String phone;
  final String email;
  final String whatsapp;
  final String preferredContact;
  final bool isVerified;
  final String? verifiedById;
  final String? verificationDate;
  final List<dynamic> documents;
  final int viewCount;
  final int contactCount;
  final double rating;
  final List<Craft> crafts;
  final DateTime createdAt;
  final dynamic verifier;

  Artisan({
    required this.id,
    required this.name,
    required this.profession,
    required this.address,
    required this.city,
    this.coordinates,
    this.workingHours,
    required this.description,
    required this.specialties,
    required this.gallery,
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.preferredContact,
    required this.isVerified,
    this.verifiedById,
    this.verificationDate,
    required this.documents,
    required this.viewCount,
    required this.contactCount,
    required this.rating,
    required this.crafts,
    required this.createdAt,
    this.verifier,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      workingHours: (json['workingHours'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())),
      description: json['description'] ?? '',
      specialties: (json['specialties'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      gallery: (json['gallery'] as List<dynamic>? ?? [])
          .map((e) => GalleryItem.fromJson(e))
          .toList(),
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      preferredContact: json['preferredContact'] ?? '',
      isVerified: json['isVerified'] ?? false,
      verifiedById: json['verifiedById'],
      verificationDate: json['verificationDate'],
      documents: json['documents'] ?? [],
      viewCount: json['viewCount'] ?? 0,
      contactCount: json['contactCount'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      crafts: (json['crafts'] as List<dynamic>? ?? [])
          .map((e) => Craft.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      verifier: json['verifier'],
    );
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class GalleryItem {
  final String url;
  final String type;
  final String caption;

  GalleryItem({required this.url, required this.type, required this.caption});

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      caption: json['caption'] ?? '',
    );
  }
}

class Craft {
  final String name;
  final double price;
  final List<String> images;
  final List<String> materials;
  final String description;

  Craft({
    required this.name,
    required this.price,
    required this.images,
    required this.materials,
    required this.description,
  });

  factory Craft.fromJson(Map<String, dynamic> json) {
    return Craft(
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      materials: (json['materials'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      description: json['description'] ?? '',
    );
  }
}
