import '/widgets/surah.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '/widgets/text_settings.dart';
import '../utils/json.dart';
import '../utils/store.dart';
import '/widgets/theme_toggle_button.dart';
import '../utils/string_locale.dart';

class QuranPage extends StatefulWidget {
  final ScrollController scrollController;

  const QuranPage({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List _chapters = [];
  int _currentPage = -1;

  Future<void> getChapters() async {
    final data =
        await LoadJson().load("assets/json/quran_editions/en.chapters.json");

    if (mounted) {
      setState(() {
        _chapters = data;
        _currentPage = _currentPage < 0 ? 0 : _currentPage;
      });
    }
  }

  String getChapterText(int page) {
    if (page >= 0 && page <= 114) {
      var chapter = _chapters[page];
      return "${toFarsi(chapter['id'])}  -  ${chapter['name']} (${chapter['id']}. ${chapter['translation']})";
    }
    return "Din";
  }

  final ReaderStoreController readerStoreController =
      Get.put(ReaderStoreController());
  final GlobalStoreController globalStoreController =
      Get.put(GlobalStoreController());

  @override
  void initState() {
    super.initState();
    getChapters();
  }

  @override
  Widget build(BuildContext context) {
    void onPageChanged(int page) {
      setState(() {
        _currentPage = page;
      });
      globalStoreController.currentSurah(page);
    }

    PageController pageController = PageController();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).backgroundColor,
      ),
      child: Scaffold(
        body: NestedScrollView(
          controller: widget.scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(
                  getChapterText(_currentPage),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                snap: true,
                floating: true,
                actions: const [TextSettingsAction(), ThemeToggleButton()],
                elevation: 2,
                backgroundColor: Theme.of(context).backgroundColor,
              ),
            ];
          },
          body: PageView(
            reverse: readerStoreController.reverseScrolling.value,
            controller: pageController,
            onPageChanged: onPageChanged,
            children: <Widget>[
              for (var chapter in _chapters)
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 32, left: 8, right: 8),
                          child: Obx(
                            () => Text(
                              "???????????? ?????????????? ???????????????????????? ????????????????????",
                              style: googleFontify(
                                readerStoreController.arabicFont.value,
                                TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: readerStoreController.fontSize * 3,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Surah(
                      chapter: chapter,
                    )
                  ],
                )
            ],
          ),
        ),
        onDrawerChanged: (isOpened) {
          globalStoreController.drawerIsOpen(isOpened);
        },
        drawer: Drawer(
          child: ListView.separated(
            key: const PageStorageKey<String>("quran drawer"),
            itemCount: _chapters.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                pageController.jumpToPage(index);
                Scaffold.of(context).closeDrawer();
              },
              child: Obx(
                () => ListTile(
                  selected: pageController.page == (_chapters[index]["id"] - 1),
                  selectedColor:
                      Theme.of(context).primaryTextTheme.bodyText2?.color,
                  selectedTileColor:
                      Theme.of(context).primaryColor.withAlpha(50),
                  subtitle: Text("${_chapters[index]['translation']}"),
                  leading: Text(
                    readerStoreController.showTranslation.value
                        ? _chapters[index]['id'].toString()
                        : toFarsi(_chapters[index]['id']),
                    style: googleFontify(
                        readerStoreController.arabicFont.value, null),
                  ),
                  title: Text(
                    "${_chapters[index]['name']} - ${_chapters[index]['transliteration']}",
                    style: Theme.of(context).primaryTextTheme.bodyText2,
                  ),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      Text(
                        readerStoreController.showTranslation.value
                            ? _chapters[index]['total_verses'].toString()
                            : toFarsi(_chapters[index]['total_verses']),
                        style: googleFontify(
                          readerStoreController.arabicFont.value,
                          TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText2!
                                .color,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Icon(Icons.my_library_books_rounded,
                          size: 14, color: Colors.grey)
                    ],
                  ),
                ),
              ),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 0),
          ),
        ),
      ),
    );
  }
}
