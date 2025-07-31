class Story {
  final String id;
  final String title;
  final String type;
  final String text;
  final String? audioUrl;
  final String? videoUrl;
  final String? transcription;
  final String language;
  final String? dialect;
  final String? region;
  final String? period;
  final String? culturalContext;
  final String? narratorId;
  final String? verificationStatus;
  final String? verifiedById;
  final String? verificationDate;
  final String? verificationNotes;
  final int views;
  final int downloads;
  final int shares;
  final double averageRating;
  final List<String> tags;
  final DateTime createdAt;
  final Narrator? narrator;
  final dynamic verifier;

  Story({
    required this.id,
    required this.title,
    required this.type,
    required this.text,
    this.audioUrl,
    this.videoUrl,
    this.transcription,
    required this.language,
    this.dialect,
    this.region,
    this.period,
    this.culturalContext,
    this.narratorId,
    this.verificationStatus,
    this.verifiedById,
    this.verificationDate,
    this.verificationNotes,
    required this.views,
    required this.downloads,
    required this.shares,
    required this.averageRating,
    required this.tags,
    required this.createdAt,
    this.narrator,
    this.verifier,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      text: json['text'] ?? '',
      audioUrl: json['audioUrl'],
      videoUrl: json['videoUrl'],
      transcription: json['transcription'],
      language: json['language'] ?? '',
      dialect: json['dialect'],
      region: json['region'],
      period: json['period'],
      culturalContext: json['culturalContext'],
      narratorId: json['narratorId'],
      verificationStatus: json['verificationStatus'],
      verifiedById: json['verifiedById'],
      verificationDate: json['verificationDate'],
      verificationNotes: json['verificationNotes'],
      views: json['views'] ?? 0,
      downloads: json['downloads'] ?? 0,
      shares: json['shares'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      narrator:
          json['narrator'] != null ? Narrator.fromJson(json['narrator']) : null,
      verifier: json['verifier'],
    );
  }
}

class Narrator {
  final String id;
  final String name;

  Narrator({required this.id, required this.name});

  factory Narrator.fromJson(Map<String, dynamic> json) {
    return Narrator(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
