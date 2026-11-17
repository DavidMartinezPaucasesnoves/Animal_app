import 'models.dart';

class ObservationsResponse {
  final List<Observation> results;

  ObservationsResponse({required this.results});

  factory ObservationsResponse.fromJson(String str) =>
      ObservationsResponse.fromMap(json.decode(str));

  factory ObservationsResponse.fromMap(Map<String, dynamic> json) =>
      ObservationsResponse(
        results: List<Observation>.from(
          json["results"].map((x) => Observation.fromMap(x)),
        ),
      );
}

class Observation {
  final int id;
  final String? placeGuess;
  final String userName;
  final String? photoUrl;

  String get fullPhotoUrl {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return photoUrl!.replaceFirst('/square.', '/medium.');
    }
    return "https://i.stack.imgur.com/GNhxO.png";
  }

  Observation({
    required this.id,
    this.placeGuess,
    required this.userName,
    this.photoUrl,
  });

  factory Observation.fromMap(Map<String, dynamic> json) {
    final photosList = json["photos"] as List?;
    final firstPhoto = (photosList != null && photosList.isNotEmpty)
        ? photosList[0]["url"]
        : null;
    final userMap = json["user"] as Map<String, dynamic>?;

    return Observation(
      id: json["id"],
      placeGuess: json["place_guess"] ?? "Hábitat natural",
      userName: userMap?["name"] ?? userMap?["login"] ?? "Explorador",
      photoUrl: firstPhoto,
    );
  }
}