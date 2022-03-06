import 'package:ebay_search/util/config_reader.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Client ID: ${ConfigReader.getClientID()}'),
          Text('Client Secret: ${ConfigReader.getClientSecret()}'),
          Text('Dev ID: ${ConfigReader.getDevID()}'),
        ],
      ),
    );
  }
}