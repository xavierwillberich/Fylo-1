class Event {
  final int id;
  final String date;
  final String month;
  final String year;
  final String dayOfWeek;
  final Weather weather;
  final int temperature;
  final String category;
  final String title;
  final String description;
  final String time;
  final String location;
  final int participants;
  final int budget;
  final bool recruiting;
  final ProficiencyLevel proficiency;
  final GenderRestriction genderRestriction;
  final bool passwordRequired;
  final String? password;
  final List<String> images;
  final List<String> attendeeAvatars;
  final bool isUserParticipating;
  final String? creatorId;
  final List<String> participantIds;

  Event({
    required this.id,
    required this.date,
    required this.month,
    required this.year,
    required this.dayOfWeek,
    required this.weather,
    required this.temperature,
    required this.category,
    required this.title,
    required this.description,
    required this.time,
    required this.location,
    required this.participants,
    required this.budget,
    required this.recruiting,
    required this.proficiency,
    required this.genderRestriction,
    required this.passwordRequired,
    this.password,
    required this.images,
    required this.attendeeAvatars,
    this.isUserParticipating = false,
    this.creatorId,
    this.participantIds = const [],
  });

  String get activityId {
    final categoryPrefix = category.substring(0, 3).toUpperCase();
    return '$categoryPrefix-${id.toString().padLeft(6, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'month': month,
      'year': year,
      'dayOfWeek': dayOfWeek,
      'weather': weather.name,
      'temperature': temperature,
      'category': category,
      'title': title,
      'description': description,
      'time': time,
      'location': location,
      'participants': participants,
      'budget': budget,
      'recruiting': recruiting,
      'proficiency': proficiency.name,
      'genderRestriction': genderRestriction.name,
      'passwordRequired': passwordRequired,
      'password': password,
      'images': images,
      'attendeeAvatars': attendeeAvatars,
      'isUserParticipating': isUserParticipating,
      'creatorId': creatorId,
      'participantIds': participantIds,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      date: json['date'] as String,
      month: json['month'] as String,
      year: json['year'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      weather: Weather.values.firstWhere(
        (e) => e.name == json['weather'],
        orElse: () => Weather.clear,
      ),
      temperature: json['temperature'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      participants: json['participants'] as int,
      budget: json['budget'] as int,
      recruiting: json['recruiting'] as bool,
      proficiency: ProficiencyLevel.values.firstWhere(
        (e) => e.name == json['proficiency'],
        orElse: () => ProficiencyLevel.beginner,
      ),
      genderRestriction: GenderRestriction.values.firstWhere(
        (e) => e.name == json['genderRestriction'],
        orElse: () => GenderRestriction.noRestrictions,
      ),
      passwordRequired: json['passwordRequired'] as bool,
      password: json['password'] as String?,
      images: List<String>.from(json['images'] as List),
      attendeeAvatars: List<String>.from(json['attendeeAvatars'] as List),
      isUserParticipating: json['isUserParticipating'] as bool? ?? false,
      creatorId: json['creatorId'] as String?,
      participantIds: json['participantIds'] != null ? List<String>.from(json['participantIds'] as List) : [],
    );
  }
}

enum Weather {
  clear,
  partlyCloudy,
  cloudy,
  rainy,
  snowy,
}

enum ProficiencyLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

enum GenderRestriction {
  noRestrictions,
  maleOnly,
  femaleOnly,
}
