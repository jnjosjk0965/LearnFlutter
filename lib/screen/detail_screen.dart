import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widget/webtoon_episode.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences pref;
  final String favListName = "favoriteToons";
  bool isFavorite = false;

  Future initPrefs() async {
    pref = await SharedPreferences.getInstance();
    final favoriteToons = pref.getStringList(favListName);
    if (favoriteToons != null) {
      if (favoriteToons.contains(widget.id) == true) {
        setState(() {
          isFavorite = true;
        });
      }
    } else {
      pref.setStringList(favListName, []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonbyId(widget.id);
    episodes = ApiService.getLatestEpisodesbyId(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final favoriteToons = pref.getStringList(favListName);
    if (favoriteToons != null) {
      if (isFavorite) {
        favoriteToons.remove(widget.id);
      } else {
        favoriteToons.add(widget.id);
      }
      await pref.setStringList(favListName, favoriteToons);
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).textTheme.displayLarge!.color,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_outline_rounded),
          ),
        ],
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              // 썸네일
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              offset: const Offset(10, 10),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ]),
                      width: 250,
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // 웹툰 상세 정보
                  FutureBuilder(
                    future: webtoon,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.about,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${snapshot.data!.genre} / ${snapshot.data!.age}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        );
                      }
                      return const Text("...");
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // 에피소드
                  FutureBuilder(
                    future: episodes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            for (var episode in snapshot.data!)
                              // 에피소드 하나
                              Episode(
                                episode: episode,
                                webtoonId: widget.id,
                              )
                          ],
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
