import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _apiKey = 'b742464921914c3571e739f896e5adef';

  Future<List<Map<String, dynamic>>> _fetchData(String endpoint, Map<String, dynamic> params, String type) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: params,
      );

      List<dynamic> results = response.data['results'] ?? [];

      return results.map((item) {
        final Map<String, dynamic> itemWithType = Map<String, dynamic>.from(item);
        itemWithType['type'] = type;
        return itemWithType;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar dados: $e');
    }
  }

  // Pega todos os filmes populares
  Future<List<Map<String, dynamic>>> fetchMovies(int page) async {
    return _fetchData(
      'https://api.themoviedb.org/3/discover/movie',
      {
        'api_key': _apiKey,
        'language': 'pt-BR',
        'page': page,
        'sort_by': 'popularity.desc',
        'with_watch_providers': '307',
        'watch_region': 'BR',
      },
      'Filme',
    );
  }

  // Pega todas as séries populares
  Future<List<Map<String, dynamic>>> fetchSeries(int page) async {
    return _fetchData(
      'https://api.themoviedb.org/3/discover/tv',
      {
        'api_key': _apiKey,
        'language': 'pt-BR',
        'page': page,
        'sort_by': 'popularity.desc',
        'with_watch_providers': '307',
        'watch_region': 'BR',
      },
      'Série',
    );
  }

  // Pega apenas novelas brasileiras
  Future<List<Map<String, dynamic>>> fetchNovelas(int page) async {
    return _fetchData(
      'https://api.themoviedb.org/3/discover/tv',
      {
        'api_key': _apiKey,
        'language': 'pt-BR',
        'page': page,
        'with_genres': '10766',
        'region': 'BR',
        'with_original_language': 'pt',
        'with_watch_providers': '307',
        'watch_region': 'BR',
      },
      'Novela',
    );
  }

  //DETAILS
  // Pega os detalhes do filme
  Future<Map<String, dynamic>> fetchMoviesDetails(int id) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/$id',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar detalhes da série: $e');
    }
  }

  // Pega os detalhes da série
  Future<Map<String, dynamic>> fetchSeriesDetails(int id) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/tv/$id',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar detalhes da série: $e');
    }
  }

  //CREDITS
  //Pega o credito e equipe do filme
  Future<Map<String, dynamic>> fetchMoviesCredits(int id) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/$id/credits',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar créditos do filme: $e');
    }
  }


  // Pega o elenco e equipe da série
  Future<Map<String, dynamic>> fetchSeriesCredits(int id) async {
    try {
      final response = await _dio.get(
        'https://api.themoviedb.org/3/tv/$id/credits',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar créditos da série: $e');
    }
  }
}