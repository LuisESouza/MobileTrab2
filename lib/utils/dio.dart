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

  // DETAILS
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
      throw Exception('Erro ao buscar detalhes do filme: $e');
    }
  }

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

  // CREDITS
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

  // FAVORITOS
  // Adicionar favoritos
  Future<int> markAsFavorite({
    required int accountId,
    required int mediaId,
    required String mediaType,
    required bool favorite,
    String token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNzQyNDY0OTIxOTE0YzM1NzFlNzM5Zjg5NmU1YWRlZiIsIm5iZiI6MTczMjQ2MDU5NS42MjI2NzQ1LCJzdWIiOiI2NzNjZjJlNDBkMGQ4ZGM4MjdlOTk0YjIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.RI5gp6Q_ShkNGnaArLbJIbovnnjKdk5cyjdONBA-ihY',
  }) async {
    try {
      final response = await _dio.post(
        'https://api.themoviedb.org/3/account/$accountId/favorite',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'media_type': mediaType,
          'media_id': mediaId,
          'favorite': favorite,
        },
      );
      return response.statusCode ?? 0;
    } catch (e) {
      throw Exception('Erro ao atualizar favorito: $e');
    }
  }

  // Filmes favoritos
  Future<List<Map<String, dynamic>>> fetchFilmesFavorites() async {
    try {
      final int page = 1;
      final int accountId = 21640604;
      final String token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNzQyNDY0OTIxOTE0YzM1NzFlNzM5Zjg5NmU1YWRlZiIsIm5iZiI6MTczMjQ2MDU5NS42MjI2NzQ1LCJzdWIiOiI2NzNjZjJlNDBkMGQ4ZGM4MjdlOTk0YjIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.RI5gp6Q_ShkNGnaArLbJIbovnnjKdk5cyjdONBA-ihY';
      final response = await _dio.get(
        'https://api.themoviedb.org/3/account/$accountId/favorite/movies',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
          'page': page,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      List<dynamic> results = response.data['results'] ?? [];
      return results.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar filmes favoritos: $e');
    }
  }

  // Séries favoritas
  Future<List<Map<String, dynamic>>> fetchSeriesFavorites() async {
    try {
      final int page = 1;
      final int accountId = 21640604;
      final String token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNzQyNDY0OTIxOTE0YzM1NzFlNzM5Zjg5NmU1YWRlZiIsIm5iZiI6MTczMjQ2MDU5NS42MjI2NzQ1LCJzdWIiOiI2NzNjZjJlNDBkMGQ4ZGM4MjdlOTk0YjIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.RI5gp6Q_ShkNGnaArLbJIbovnnjKdk5cyjdONBA-ihY';
      final response = await _dio.get(
        'https://api.themoviedb.org/3/account/$accountId/favorite/tv',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
          'page': page,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      List<dynamic> results = response.data['results'] ?? [];
      return results.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar séries favoritas: $e');
    }
  }
}