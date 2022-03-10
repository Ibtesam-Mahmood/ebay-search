import 'package:ebay_search/models/ebay_item.dart';
import 'package:ebay_search/util/config_reader.dart';
import 'package:ebay_search/util/ebay_api.dart';
import 'package:ebay_search/widgets/item_list_tile.dart';
import 'package:feed/feed.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

/*
 
     ____  _        _       
    / ___|| |_ __ _| |_ ___ 
    \___ \| __/ _` | __/ _ \
     ___) | || (_| | ||  __/
    |____/ \__\__,_|\__\___|
                            
 
*/

  final FeedController controller = FeedController();

/*
 
     _   _      _                     
    | | | | ___| |_ __   ___ _ __ ___ 
    | |_| |/ _ \ | '_ \ / _ \ '__/ __|
    |  _  |  __/ | |_) |  __/ |  \__ \
    |_| |_|\___|_| .__/ \___|_|  |___/
                 |_|                  
 
*/

  Future<FeedResponse<EbayItem>> _feedLoader(int size, [String? token]) => EbayFindingApi.searchItemsByKeywordsFeed(
    size: size,
    pageToken: token,
    keywords: 'laptop'
  );


/*
 
     ____        _ _     _   _   _      _                     
    | __ ) _   _(_) | __| | | | | | ___| |_ __   ___ _ __ ___ 
    |  _ \| | | | | |/ _` | | |_| |/ _ \ | '_ \ / _ \ '__/ __|
    | |_) | |_| | | | (_| | |  _  |  __/ | |_) |  __/ |  \__ \
    |____/ \__,_|_|_|\__,_| |_| |_|\___|_| .__/ \___|_|  |___/
                                         |_|                  
 
*/

  /// Builds the individual item within the feed
  Widget _childBuilder(EbayItem item, bool isLast){
    return EbayItemListTile(item: item);
  }

  /// Builds the wrapping widget surrounding the feed
  Widget _buildWrapper(BuildContext context, Widget child){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: child,
    );
  }

/*
 
     ____        _ _     _ 
    | __ ) _   _(_) | __| |
    |  _ \| | | | | |/ _` |
    | |_) | |_| | | | (_| |
    |____/ \__,_|_|_|\__,_|
                           
 
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Feed(
          controller: controller,
          loader: _feedLoader,
          wrapper: _buildWrapper,
          childBuilder: (item, isLast) => _childBuilder(item as EbayItem, isLast),
        ),
      )
    );
  }
}