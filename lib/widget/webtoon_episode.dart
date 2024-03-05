import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Episode extends StatelessWidget {
  const Episode({
    super.key,
    required this.episode,
    required this.webtoonId,
  });

  final WebtoonEpisodeModel episode;
  final String webtoonId;

  onButtonTap() async {
    final url = Uri.parse(
        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}");
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).textTheme.displayLarge!.color,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(6, 6),
                color: Colors.black.withOpacity(0.4),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                episode.title,
                softWrap: false, // 글씨가 안보이게 됨
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              )),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.background,
              )
            ],
          ),
        ),
      ),
    );
  }
}
