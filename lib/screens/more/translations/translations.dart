import '/screens/more/translations/translation.dart';
import '/utils/store.dart';
import '/widgets/back_button.dart';
import '/widgets/theme_toggle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Translations extends StatelessWidget {
  const Translations({super.key});

  @override
  Widget build(BuildContext context) {
    List languages = [
      Language(emoji: "🇸🇦", abbrev: "ar", language: "عربى"),
      Language(emoji: "🇦🇿", abbrev: "az", language: "Azərbaycan"),
      Language(emoji: "🇧🇬", abbrev: "bg", language: "български"),
      Language(emoji: "🇧🇩", abbrev: "bn", language: "Bengali"),
      Language(emoji: "🇧🇦", abbrev: "bs", language: "bosanski"),
      Language(emoji: "🇨🇿", abbrev: "cs", language: "čeština"),
      Language(emoji: "🇬🇧", abbrev: "en", language: "English"),
      Language(emoji: "🇮🇷", abbrev: "fa", language: "فارسی"),
      Language(emoji: "🇫🇷", abbrev: "fr", language: "Français"),
      Language(emoji: "🇹🇩", abbrev: "ha", language: "Hausa"),
      Language(emoji: "🇮🇳", abbrev: "hi", language: "हिन्दी"),
      Language(emoji: "🇮🇩", abbrev: "id", language: "Indonesia"),
      Language(emoji: "🇮🇹", abbrev: "it", language: "Italiano"),
      Language(emoji: "🇯🇵", abbrev: "ja", language: "日本"),
      Language(emoji: "🇰🇷", abbrev: "ko", language: "한국인"),
      Language(emoji: "🇹🇷", abbrev: "ku", language: "Kurdî"),
      Language(emoji: "🇰🇵", abbrev: "ml", language: "മലയാളം"),
      Language(emoji: "🇳🇱", abbrev: "nl", language: "Nederlands"),
      Language(emoji: "🇳🇴", abbrev: "no", language: "norsk"),
      Language(emoji: "🇵🇱", abbrev: "pl", language: "Pusse"),
      Language(emoji: "🇵🇹", abbrev: "pt", language: "Português"),
      Language(emoji: "🇷🇴", abbrev: "ro", language: "Română"),
      Language(emoji: "🇷🇺", abbrev: "ru", language: "Русский"),
      Language(emoji: "🇵🇰", abbrev: "sd", language: "سنڌي"),
      Language(emoji: "🇸🇴", abbrev: "so", language: "Soomaali"),
      Language(emoji: "🇦🇱", abbrev: "sq", language: "shqiptare"),
      Language(emoji: "🇸🇪", abbrev: "sv", language: "svenska"),
      Language(emoji: "🇹🇿", abbrev: "sw", language: "Kiswahili"),
    ];

    final TranslationsStoreController translationsStoreController =
        Get.put(TranslationsStoreController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Translations"),
        leading: const CustomBackButton(),
        actions: const [ThemeToggleButton()],
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: translationsStoreController.updateQuranTranslations,
        child: Obx(
          () => Container(
            child: translationsStoreController.quranTranslations.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(40),
                    children: [
                      Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Icon(FontAwesomeIcons.solidHandBackFist),
                              Icon(Icons.arrow_downward_rounded),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                                "Pull to refresh or press the refresh button.",
                                style: TextStyle(
                                  fontSize: 12,
                                )),
                          ),
                          IconButton(
                              onPressed: translationsStoreController
                                  .updateQuranTranslations,
                              icon: const Icon(Icons.refresh_rounded))
                        ],
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      ListTile(
                        title: const Text("Installed"),
                        subtitle: Obx(
                          () => Column(
                            children: translationsStoreController
                                .downloadedQuranEditions
                                .map((e) {
                              return TranslationRadio(translation: e);
                            }).toList(),
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Available Languages"),
                        subtitle: Column(children: [
                          for (var language in languages)
                            ListTile(
                              leading: Text(language.emoji,
                                  style: const TextStyle(fontSize: 20)),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              title: Text(language.language),
                              subtitle: Text(language.abbrev),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        LanguageScreen(language: language),
                                  ),
                                );
                              },
                            )
                        ]),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class Language {
  String emoji = "🤔";
  String language = "NULL";
  String abbrev = "NULL";

  Language({required this.emoji, required this.language, required this.abbrev});
}

class LanguageScreen extends StatelessWidget {
  final Language language;

  LanguageScreen({super.key, required this.language});

  final TranslationsStoreController translationsStoreController =
      Get.put(TranslationsStoreController());

  @override
  Widget build(BuildContext context) {
    List editions = translationsStoreController.quranTranslations.firstWhere(
        (element) => element["language"] == language.abbrev)["editions"];

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(language.language),
      ),
      body: ListView(
        children: [
          for (String edition in editions)
            Translation(
              edition: edition,
              language: language.abbrev,
            )
        ],
      ),
    );
  }
}
