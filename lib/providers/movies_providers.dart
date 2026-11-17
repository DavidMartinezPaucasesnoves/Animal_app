import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = "api.inaturalist.org";
  final String _language = "es";

  List<Result> onDisplayAnimals = [];
  List<Result> onPopularAnimals = [];

  Map<int, List<Observation>> observationsCache = {};

  MoviesProvider() {
    print("Animals provider inicialitzat");
    getOnDisplayAnimals();
    getOnPopularAnimals();
  }

  // Reptiles exóticos para el CardSwiper
  getOnDisplayAnimals() async {
    var url = Uri.https(_baseUrl, 'v1/taxa', {
      "taxon_id": "26036",
      "rank": "species",
      "per_page": "20",
      "locale": _language,
    });

    final result = await http.get(url);
    final taxaResponse = TaxaResponse.fromJson(result.body);
    onDisplayAnimals = taxaResponse.results;
    notifyListeners();
  }

  // Aves exóticas (loros, guacamayos, cacatúas) para el Slider
  getOnPopularAnimals() async {
    var url = Uri.https(_baseUrl, 'v1/taxa', {
      "taxon_id": "18874",
      "rank": "species",
      "per_page": "20",
      "locale": _language,
    });

    final result = await http.get(url);
    final taxaResponse = TaxaResponse.fromJson(result.body);
    onPopularAnimals = taxaResponse.results;
    notifyListeners();
  }

  // Avistamientos reales de esa especie para la pantalla de detalle
  Future<List<Observation>> getAnimalObservations(int taxonId) async {
    if (observationsCache.containsKey(taxonId)) {
      return observationsCache[taxonId]!;
    }

    var url = Uri.https(_baseUrl, 'v1/observations', {
      "taxon_id": "$taxonId",
      "photos": "true",
      "per_page": "10",
      "locale": _language,
    });

    final result = await http.get(url);
    final observationsResponse = ObservationsResponse.fromJson(result.body);

    observationsCache[taxonId] = observationsResponse.results;
    return observationsResponse.results;
  }
}