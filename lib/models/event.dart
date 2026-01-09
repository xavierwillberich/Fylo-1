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
  });

  String get activityId {
    final categoryPrefix = category.substring(0, 3).toUpperCase();
    return '$categoryPrefix-${id.toString().padLeft(6, '0')}';
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
