import 'dart:convert';

class TaxaResponse {
  final int totalResults;
  final int page;
  final int perPage;
  final List<Result> results;

  TaxaResponse({
    required this.totalResults,
    required this.page,
    required this.perPage,
    required this.results,
  });

  factory TaxaResponse.fromJson(String str) =>
      TaxaResponse.fromMap(json.decode(str));

  factory TaxaResponse.fromMap(Map<String, dynamic> json) => TaxaResponse(
        totalResults: json["total_results"] ?? 0,
        page: json["page"] ?? 1,
        perPage: json["per_page"] ?? 20,
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
      );
}

class Result {
  final int id;
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

  // Mismo nombre de getter que tenía en Movie para facilitar la adaptación
  String get fullPosterPath {
    if (defaultPhoto?.mediumUrl != null &&
        defaultPhoto!.mediumUrl.isNotEmpty) {
      return defaultPhoto!.mediumUrl;
    }
    return "https://i.stack.imgur.com/GNhxO.png";
  }

  String get displayName {
    return preferredCommonName ?? englishCommonName ?? name;
  }

  String get descriptionText {
    if (wikipediaSummary != null && wikipediaSummary!.isNotEmpty) {
      return wikipediaSummary!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
    }
    final estado = conservationStatus?.statusName != null
        ? 'Estado de conservación: ${conservationStatus!.statusName}.'
        : 'Estado de conservación: Especie monitorizada.';
    final ingles = englishCommonName != null
        ? ' También se conoce internacionalmente como "$englishCommonName".'
        : '';
    return '$displayName ($name) es una especie exótica perteneciente a la clase ${iconicTaxonName ?? "Animalia"}.$ingles Actualmente cuenta con $observationsCount avistamientos documentados por naturalistas en todo el mundo. $estado';
  }

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
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

class ConservationStatus {
  final String? status;
  final String? statusName;

  ConservationStatus({this.status, this.statusName});

  factory ConservationStatus.fromMap(Map<String, dynamic> json) =>
      ConservationStatus(
        status: json["status"],
        statusName: json["status_name"],
      );
}

class DefaultPhoto {
  final String url;
  final String squareUrl;
  final String mediumUrl;

  DefaultPhoto({
    required this.url,
    required this.squareUrl,
    required this.mediumUrl,
  });

  factory DefaultPhoto.fromMap(Map<String, dynamic> json) => DefaultPhoto(
        url: json["url"] ?? '',
        squareUrl: json["square_url"] ?? '',
        mediumUrl: json["medium_url"] ?? json["url"] ?? '',
      );
}