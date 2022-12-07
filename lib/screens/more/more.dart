import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/screens/more/about_app.dart';
import '/screens/more/about_developer.dart';
import '/screens/more/appearance.dart';
import '/screens/more/favourites.dart';
import '/screens/more/names.dart';
import '/screens/more/reader_preferences.dart';
import 'translations/translations.dart';
import '/util/network.dart';
import '/widgets/icons.dart';
import '/widgets/theme_toggle_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    void push(Widget page) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        actions: const [ThemeToggleButton()],
        // backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Inspiration"),
            subtitle: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.stars_rounded),
                  title: const Text("99 Names"),
                  subtitle: const Text(
                      "99 Names of Allah and the prophet Muhammad (ﷺ.)"),
                  onTap: () => push(const Names()),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded),
                  title: const Text("Favourites"),
                  subtitle: const Text("Favourite verses"),
                  onTap: () => push(const Favourites()),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Customisation"),
            subtitle: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text("Appearance"),
                  subtitle: const Text("Theme modes, accent colors"),
                  onTap: () => push(const Appearance()),
                ),
                if (kDebugMode) // TODO add feature
                  ListTile(
                    leading: const Icon(Icons.translate_rounded),
                    title: const Text("Translations"),
                    subtitle: const Text("en, fr, ru, bg ..."),
                    onTap: () => push(Translations()),
                  ),
                ListTile(
                  leading: const Icon(Icons.text_format_rounded),
                  title: const Text("Reader preferences"),
                  subtitle: const Text("Size, text display format"),
                  onTap: () => push(ReaderPreferences()),
                ),
                if (kDebugMode) // TODO add feature
                  ListTile(
                    enabled: false,
                    leading: const Icon(Icons.notifications),
                    title: const Text("Notifications"),
                    subtitle: const Text("Prayer times, fasting, holidays"),
                    onTap: () {},
                  ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Review and Share"),
            subtitle: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.share_rounded),
                  title: const Text("Share"),
                  onTap: () async {
                    await FlutterShare.share(
                      title: 'Share the app',
                      linkUrl:
                          'https://play.google.com/store/apps/details?id=com.tallestlegacy.din_dt',
                      chooserTitle: 'Share the app',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.thumbs_up_down_rounded),
                  title: const Text("Rate the app"),
                  onTap: () {
                    openLink(
                        "https://play.google.com/store/apps/details?id=com.tallestlegacy.din_dt");
                  },
                  trailing: linkIcon,
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer_rounded),
                  title: const Text("Help and Feedback"),
                  subtitle: const Text("Contact, recommendations"),
                  onTap: () => openLink(
                    "mailto:tallestlegacy@gmail.com?subject=Din > Help and Feedback",
                  ),
                  trailing: linkIcon,
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("App details"),
            subtitle: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text("About the app"),
                  onTap: () => push(const AboutApp()),
                ),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text("Meet the developer"),
                  onTap: () => push(const AboutDeveloper()),
                ),
                ListTile(
                  leading: const Icon(Icons.code_rounded),
                  title: const Text("Sources and Licencing"),
                  onTap: () =>
                      openLink("https://github.com/tallestlegacy/din_dt"),
                  trailing: linkIcon,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _packageInfo.version,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
