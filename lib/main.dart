import 'package:ebay_search/pages/search_page.dart';
import 'package:ebay_search/util/config_reader.dart';
import 'package:flutter/material.dart';

void main() {
  mainCommon();
}

///Ensures that the config reader is initialized before the application is run
void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigReader.initialize();

  runApp(const EbaySearchApp());
}

/// Root of the application
class EbaySearchApp extends StatelessWidget {
  const EbaySearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebay Search',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SearchPage(),
    );
  }
}
