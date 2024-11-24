import 'package:flutter/material.dart';
import '../utils/dio.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key}) : super(key: key);

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final filmes = await _apiService.fetchFilmesFavorites();
      final series = await _apiService.fetchSeriesFavorites();

      setState(() {
        _favorites = [...filmes, ...series];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar favoritos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final item = _favorites[index];
                    return GestureDetector(
                      child: Column(
                        children: [
                          Expanded(
                            child: item['poster_path'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(2.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w200${item['poster_path']}',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported, size: 50),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
