class Event {
  final String id;
  final String title;
  final String description;
  final String venue;
  final String address;
  final Coordinates? coordinates;
  final String accessInstructions;
  final DateTime startDate;
  final DateTime endDate;
  final String timezone;
  final List<Session> sessions;
  final String category;
  final String culturalSignificance;
  final int capacity;
  final List<String> images;
  final List<String> videos;
  final String? brochureUrl;
  final int interestedCount;
  final int attendingCount;
  final int sharesCount;
  final DateTime createdAt;
  final List<dynamic> artisans;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.address,
    this.coordinates,
    required this.accessInstructions,
    required this.startDate,
    required this.endDate,
    required this.timezone,
    required this.sessions,
    required this.category,
    required this.culturalSignificance,
    required this.capacity,
    required this.images,
    required this.videos,
    this.brochureUrl,
    required this.interestedCount,
    required this.attendingCount,
    required this.sharesCount,
    required this.createdAt,
    required this.artisans,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      venue: json['venue'] ?? '',
      address: json['address'] ?? '',
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      accessInstructions: json['accessInstructions'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      timezone: json['timezone'] ?? '',
      sessions: (json['sessions'] as List<dynamic>? ?? [])
          .map((e) => Session.fromJson(e))
          .toList(),
      category: json['category'] ?? '',
      culturalSignificance: json['culturalSignificance'] ?? '',
      capacity: json['capacity'] ?? 0,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      videos: (json['videos'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      brochureUrl: json['brochureUrl'],
      interestedCount: json['interestedCount'] ?? 0,
      attendingCount: json['attendingCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      artisans: json['artisans'] ?? [],
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

class Session {
  final String title;
  final String startTime;
  final String endTime;
  final String description;

  Session({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      title: json['title'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
