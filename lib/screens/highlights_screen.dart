import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/dio.dart';

final ApiService _apiService = ApiService();

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({Key? key, required this.media}) : super(key: key);
  final dynamic media;

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  bool showDetails = true;
  List<dynamic>? relatedContent;
  Map<String, dynamic>? detailsData;
  Map<String, dynamic>? creditsData;

  Future<void> fetchDetails() async {
    try {
      if (widget.media['type'] == 'Filme') {
        detailsData = await _apiService.fetchMoviesDetails(widget.media['id']);
        creditsData = await _apiService.fetchMoviesCredits(widget.media['id']);
      } else if (widget.media['type'] == 'Série' ||
          widget.media['type'] == 'Novela') {
        detailsData = await _apiService.fetchSeriesDetails(widget.media['id']);
        creditsData = await _apiService.fetchSeriesCredits(widget.media['id']);
      }
      setState(() {});
    } catch (e) {
      print("Erro ao buscar detalhes: $e");
    }
  }

  Future<void> fetchContent() async {
  try {
    if (widget.media['type'] == 'Filme') {
      relatedContent = await _apiService.fetchMovies(2);
    } else if (widget.media['type'] == 'Série') {
      relatedContent = (await _apiService.fetchSeries(2)).take(6).toList();
    } else if (widget.media['type'] == 'Novela') {
      relatedContent = await _apiService.fetchNovelas(2);
    }
    setState(() {});
  } catch (e) {
    print("Erro ao buscar conteúdo relacionado: $e");
  }
}

  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            height: MediaQuery.of(context).size.height * .51,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500${widget.media['poster_path']}',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Container da imagem principal
                Center(
                  child: Container(
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${widget.media['poster_path']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.media['title'] ?? widget.media['name'] ?? "Título Indisponível",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.media['type'] ?? "Tipo Indisponível",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    widget.media['overview'] != null &&
                            widget.media['overview'].length > 200
                        ? '${widget.media['overview'].substring(0, 170)}...'
                        : widget.media['overview'] ?? "Descrição não encontrada. Por favor, tente novamente.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                // Botões de navegação
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showDetails = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showDetails ? Colors.grey : Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text("ASSISTA TAMBÉM"),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showDetails = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showDetails ? Colors.white : Colors.grey,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text("DETALHES"),
                    ),
                  ],
                ),
                if (showDetails && detailsData != null)
                  Container(
                    color: Color(0xFF1F1F1F),
                    //Eu quero que isto ocupe tudo para baixo e nao apenas uma parte pequena
                    height: 317,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ficha Técnica",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Título Original: ${detailsData!['original_title'] ?? detailsData!['original_name'] ?? 'Título não encontrado'}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Gênero: ${detailsData!['genres']?.take(3).map((e) => e['name']).join(', ') ?? 'Não disponível'}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Ano de produção: ${detailsData!['first_air_date'] ?? 'Não disponível'}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "País: ${detailsData!['origin_country'] ?? 'Não disponível'}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Direção: ${creditsData?['crew']?.firstWhere((person) => person['job'] == 'Director', orElse: () => null)?['name'] ?? 'Não disponível'}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Elenco: ${creditsData!['cast']?.take(10).map((e) => e['name']).join(', ') ?? 'Não disponível'}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                if (!showDetails && relatedContent != null)
                  Container(
                    color: Color(0xFF1F1F1F),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.6,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: relatedContent!.length,
                            itemBuilder: (context, index) {
                              final content = relatedContent![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/highlights',
                                    arguments: content,
                                  );
                                },
                                child: Container(
                                  child: ClipRRect(
                                    
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${content['poster_path']}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}