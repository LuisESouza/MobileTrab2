import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../utils/dio.dart';

final ApiService _apiService = ApiService();

class ListScreen extends StatefulWidget {
  final String mediaType;

  const ListScreen({Key? key, required this.mediaType}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<dynamic> filmes = [];
  int currentPage = 1;
  bool isLoading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener); // Adiciona o listener para o scroll
    _fetchFilmes(); // Carrega os filmes iniciais
  }

  // Função de escuta do scroll
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Quando o usuário chega no fim da lista
      _fetchFilmes();
    }
  }

  Future<void> _fetchFilmes() async {
    if (isLoading) return;  // Evita múltiplas requisições

    setState(() {
      isLoading = true;
    });

    try {
      var response;
      
      // Carregar mais páginas dependendo do tipo
      if (widget.mediaType == "filmes") {
        response = await _apiService.fetchMovies(currentPage);
      } else if (widget.mediaType == "novelas") {
        response = await _apiService.fetchNovelas(currentPage);
      } else if (widget.mediaType == "series") {
        response = await _apiService.fetchSeries(currentPage);
      }

      setState(() {
        filmes.addAll(response);  // Adiciona os novos filmes à lista existente
        currentPage++;  // Incrementa a página para a próxima requisição
      });
    } catch (e) {
      print('Erro ao carregar filmes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mediaType[0].toUpperCase()}${widget.mediaType.substring(1)} Populares'),
        backgroundColor: Colors.black,
      ),
      body: filmes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: filmes.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filmes.length) {
                  return Center(child: CircularProgressIndicator()); 
                }

                var filme = filmes[index];
                return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/highlights',
                          arguments: filme,
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: filme['poster_path'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(2.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w200${filme['poster_path']}',
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
