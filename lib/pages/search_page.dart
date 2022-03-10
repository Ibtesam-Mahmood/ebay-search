
import 'dart:ui';

import 'package:ebay_search/models/ebay_item.dart';
import 'package:ebay_search/state/search_state.dart';
import 'package:ebay_search/util/config_reader.dart';
import 'package:ebay_search/util/ebay_api.dart';
import 'package:ebay_search/widgets/item_list_tile.dart';
import 'package:feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

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
  /// The state controller for this page
  late final Tower<SearchState> state = SearchState.tower;

  /// The focus node for the search bar
  late final FocusNode _searchFN = FocusNode()..addListener(() {
    // Update the focus state
    state.dispatch(UpdateFocusEvent(_searchFN.hasFocus));
  });

  /// The search bar text field controller
  late final TextEditingController _searchTextController = TextEditingController()..addListener(() {
    // Perform a search when changed
    state.dispatch(performSearch(_searchTextController.text));
  });

/*
 
     _   _      _                     
    | | | | ___| |_ __   ___ _ __ ___ 
    | |_| |/ _ \ | '_ \ / _ \ '__/ __|
    |  _  |  __/ | |_) |  __/ |  \__ \
    |_| |_|\___|_| .__/ \___|_|  |___/
                 |_|                  
 
*/


/*
 
     ____        _ _     _   _   _      _                     
    | __ ) _   _(_) | __| | | | | | ___| |_ __   ___ _ __ ___ 
    |  _ \| | | | | |/ _` | | |_| |/ _ \ | '_ \ / _ \ '__/ __|
    | |_) | |_| | | | (_| | |  _  |  __/ | |_) |  __/ |  \__ \
    |____/ \__,_|_|_|\__,_| |_| |_|\___|_| .__/ \___|_|  |___/
                                         |_|                  
 
*/

  AppBar _buildSearchAppBar(BuildContext context, bool focused){
    return AppBar(
      backgroundColor: focused ? Colors.white : Colors.orange,
      title: TextField(
        focusNode: _searchFN,
        controller: _searchTextController,
        cursorColor: Colors.blue,
        style: TextStyle(color: focused ? Colors.orange : Colors.white, fontWeight: FontWeight.bold),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          prefixIcon: Icon(Icons.search, color: focused ? Colors.orange : Colors.white,),
          hintText: 'Search EBAY...',
          hintStyle: TextStyle(color: focused ? Colors.orange : Colors.white, fontWeight: FontWeight.normal),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.orange, width: 2)
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.black, width: 1)
          )
        ),
      ),
    );
  }

  /// Builds the individual item within the feed
  Widget _childBuilder(EbayItem item, bool isLast){
    return EbayItemListTile(item: item);
  }

  /// Builds the wrapping widget surrounding the feed
  Widget _buildWrapper(BuildContext context, Widget child, bool focused){
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              StoreConnector<SearchState, String>(
                converter: (store) => store.state.recommendation,
                builder: (context, recommendation) {
                  return recommendation.isEmpty ? const SizedBox.shrink() : GestureDetector(
                    onTap: (){
                      //Updates the search term
                      _searchTextController.text = recommendation;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 16),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: 'Did you mean: '),
                            TextSpan(text: recommendation, style: const TextStyle(color: Colors.blue)),
                            const TextSpan(text: ' instead?'),
                          ], 
                          style: const TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                  );
                }
              ),
              
              child,
            ],
          ),
        ),

        // Handled keyboard dismissing
        focused ? Positioned.fill(
          child: GestureDetector(
            child: Container(
              color: Colors.transparent,
            ),
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onPanDown: (details){
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ) : const SizedBox.shrink()
      ],
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
    return StoreProvider(
      store: state,
      child: StoreConnector<SearchState, bool>(
        converter: (store) => store.state.isFocused,
        builder: (context, focused) {
          return Scaffold(
            appBar: _buildSearchAppBar(context, focused),
            body: SafeArea(
              bottom: true,
              child: Feed(
                controller: state.state.controller,
                loader: (size, [token]) async => (await state.loader(size, token)).item1,
                wrapper: (context, list) => _buildWrapper(context, list, focused),
                childBuilder: (item, isLast) => _childBuilder(item as EbayItem, isLast),
              ),
            )
          );
        }
      ),
    );
  }
}