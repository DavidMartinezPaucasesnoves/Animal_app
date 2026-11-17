import "models.dart";

class Result {
  final int id;
  final String? rank;
  final int? rankLevel;
  final int? iconicTaxonId;
  final bool isActive;
  final String name;
  final bool extinct;
  final DefaultPhoto? defaultPhoto;
  final int observationsCount;
  final String? wikipediaUrl;
  final String? wikipediaSummary;
  final String? iconicTaxonName;
  final String? preferredCommonName;
  final String? englishCommonName;
  final ConservationStatus? conservationStatus;

  Result({
    required this.id,
    this.rank,
    this.rankLevel,
    this.iconicTaxonId,
    required this.isActive,
    required this.name,
    required this.extinct,
    this.defaultPhoto,
    required this.observationsCount,
    this.wikipediaUrl,
    this.wikipediaSummary,
    this.iconicTaxonName,
    this.preferredCommonName,
    this.englishCommonName,
    this.conservationStatus,
  });

  // Getters útiles para tus pantallas (Home y Detalle)
  String get fullImg {
    if (defaultPhoto?.mediumUrl != null && defaultPhoto!.mediumUrl.isNotEmpty) {
      return defaultPhoto!.mediumUrl;
    }
    return 'https://placehold.co/400x600/png?text=Sin+Imagen';
  }

  get fullPosterPath {
  if (defaultPhoto?.mediumUrl != null && defaultPhoto!.mediumUrl.isNotEmpty) {
    return defaultPhoto!.mediumUrl;
  }
  return "https://i.stack.imgur.com/GNhxO.png";
}

  String get displayName {
    return preferredCommonName ?? englishCommonName ?? name;
  }

  String get descriptionText {
    if (wikipediaSummary != null && wikipediaSummary!.isNotEmpty) {
      // Limpia posibles etiquetas HTML básicas de Wikipedia
      return wikipediaSummary!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
    }
    return 'Especie perteneciente al grupo ${iconicTaxonName ?? "Animalia"} con $observationsCount avistamientos registrados en iNaturalist.';
  }

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  //String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
    id: json["id"],
    rank: json["rank"],
    rankLevel: json["rank_level"],
    iconicTaxonId: json["iconic_taxon_id"],
    isActive: json["is_active"] ?? true,
    name: json["name"] ?? 'Especie desconocida',
    extinct: json["extinct"] ?? false,
    defaultPhoto: json["default_photo"] == null
        ? null
        : DefaultPhoto.fromMap(json["default_photo"]),
    observationsCount: json["observations_count"] ?? 0,
    wikipediaUrl: json["wikipedia_url"],
    wikipediaSummary: json["wikipedia_summary"],
    iconicTaxonName: json["iconic_taxon_name"],
    preferredCommonName: json["preferred_common_name"],
    englishCommonName: json["english_common_name"],
    conservationStatus: json["conservation_status"] == null
        ? null
        : ConservationStatus.fromMap(json["conservation_status"]),
  );
}