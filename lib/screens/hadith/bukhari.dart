import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/back_button.dart';
import '/widgets/text_settings.dart';
import '/util/json.dart';
import '/util/store.dart';
import '/util/string_locale.dart';
import '/widgets/theme_toggle_button.dart';

class Bukhari extends StatefulWidget {
  const Bukhari({Key? key}) : super(key: key);

  @override
  State<Bukhari> createState() => _BukhariState();
}

class _BukhariState extends State<Bukhari> {
  List _volumes = [];
  int length = 97;

  Future<void> getVolumes() async {
    var data = await LoadJson().load("assets/json/hadith/bukhari/index.json");
    if (mounted) {
      setState(() {
        _volumes = data;
      });
    }
  }

  final ReaderStoreController readerStoreController =
      Get.put(ReaderStoreController());

  @override
  void initState() {
    super.initState();
    getVolumes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sahih Bukhari"),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          /*
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(context: context, delegate: BukhariSearch());
            },
          ),*/
          const ThemeToggleButton(),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _volumes.length,
        itemBuilder: (context, index) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "${_volumes[index]['name']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            for (var book in _volumes[index]['books'])
              Obx(
                () => Card(
                  child: ListTile(
                    title: Text(
                      "${book['name']}",
                    ),
                    trailing: Text(
                      readerStoreController.showTranslation.value
                          ? "${book['length']}"
                          : toFarsi(book['length']),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => BukhariHadiths(
                            book: book,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class BukhariSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}

class BukhariHadiths extends StatefulWidget {
  final book;
  const BukhariHadiths({Key? key, required this.book}) : super(key: key);

  @override
  State<BukhariHadiths> createState() => _BukhariHadithsState();
}

class _BukhariHadithsState extends State<BukhariHadiths> {
  var _hadiths = [];
  Future<void> getHadiths() async {
    var data = await LoadJson()
        .load("assets/json/hadith/bukhari/${widget.book['id']}.json");
    if (mounted) {
      setState(() {
        _hadiths = data['hadiths'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHadiths();
  }

  @override
  Widget build(BuildContext context) {
    final ReaderStoreController readerStoreController =
        Get.put(ReaderStoreController());
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.book['name']}"),
          leading: const CustomBackButton(),
          actions: const [TextSettingsAction(), ThemeToggleButton()],
          titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSecondary),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _hadiths.length,
          itemBuilder: (context, index) => Card(
            child: Obx(
              () => ListTile(
                leading: Text(
                  readerStoreController.showTranslation.value
                      ? _hadiths[index]['id'].toString()
                      : toFarsi(_hadiths[index]['id']),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: readerStoreController.fontSize.value),
                ),
                title: Text(
                  _hadiths[index]['by'],
                  style:
                      TextStyle(fontSize: readerStoreController.fontSize.value),
                ),
                subtitle: Text(
                  _hadiths[index]['text'],
                  style:
                      TextStyle(fontSize: readerStoreController.fontSize.value),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
