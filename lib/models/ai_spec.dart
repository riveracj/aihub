class AISpec {
  final String id;
  final String name;
  final String description;
  final String avatarUrl;
  final String category;
  final double rating;
  final int userCount;
  final bool online;
  final String personality;
  final String specialty;
  final String welcomeMessage;

  const AISpec({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.category,
    required this.rating,
    required this.userCount,
    this.online = true,
    this.personality = '',
    this.specialty = '',
    this.welcomeMessage = '',
  });

  factory AISpec.fromJson(Map<String, dynamic> json) {
    return AISpec(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      avatarUrl: json['avatar'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      userCount: json['users'] as int? ?? 0,
      online: json['online'] as bool? ?? true,
      personality: json['personality'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      welcomeMessage: json['welcomeMessage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatarUrl,
      'category': category,
      'rating': rating,
      'users': userCount,
      'online': online,
      'personality': personality,
      'specialty': specialty,
      'welcomeMessage': welcomeMessage,
    };
  }

  String get formattedUserCount {
    if (userCount >= 1000000) {
      return '${(userCount / 1000000).toStringAsFixed(1)}M';
    } else if (userCount >= 1000) {
      return '${(userCount / 1000).toStringAsFixed(1)}k';
    }
    return '$userCount';
  }
}
