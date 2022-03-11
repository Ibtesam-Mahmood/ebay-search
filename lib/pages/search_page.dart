
import 'dart:ui';

import 'package:ebay_search/models/ebay_item.dart';
import 'package:ebay_search/state/search_state.dart';
import 'package:ebay_search/util/animators.dart';
import 'package:ebay_search/util/config_reader.dart';
import 'package:ebay_search/util/ebay_api.dart';
import 'package:ebay_search/widgets/ebay_item_skeleton_list_tile.dart';
import 'package:ebay_search/widgets/item_list_tile.dart';
import 'package:ebay_search/widgets/loader.dart';
import 'package:ebay_search/widgets/recomended_search_list.dart';
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
        onSubmitted: (value){
          // Perform on submission
          state.dispatch(performSearch(value));
        },
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
  
  /// Builds a clickable text that shows the recommended search request
  Widget _buildRecommendedSearch(BuildContext context){
    return StoreConnector<SearchState, String>(
      converter: (store) => store.state.recommendation,
      builder: (context, recommendation) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: AnimationOverLast(animation, 0.8),
              child: SizeTransition(
                sizeFactor: AnimationOverFirst(animation, 0.4),
                child: child
              ),
            );
          },
          child: recommendation.isEmpty ? const SizedBox.shrink() : GestureDetector(
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
          ),
        );
      }
    );
  }

  /// Shows up within the item feed when there are no search results. 
  /// If the state is not searching however, then this displays the [EbayRecommendedList]
  Widget _placeHolderBuilder(BuildContext context){
    return Center(
      child: StoreConnector<SearchState, String>(
        converter: (store) => store.state.search,
        builder: (context, search) {

          bool searching = search.isNotEmpty;

          return !searching ? const EbayRecommendedList() : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

      
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle
                ),
                child: const Center(
                  child: Icon(Icons.search, color: Colors.black, size: 72,),
                ),
              ),
      
              Container(height: 16,),

              //Search result text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: 'No Search results for '),
                      TextSpan(text: search, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: '. try searching something else instead?'),
                    ],
                    style: const TextStyle(color: Colors.grey, fontSize: 14)
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              //Displays the recommendation below if there is one
              StoreConnector<SearchState, String>(
                converter: (store) => store.state.recommendation,
                builder: (context, recommendation) {
                  return recommendation.isEmpty ? const SizedBox.shrink() : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      color: Colors.orange,
                      onPressed: (){
                        //Updates the search term
                        _searchTextController.text = recommendation;
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: 'Did you mean: '),
                            TextSpan(text: recommendation, style: const TextStyle(fontWeight: FontWeight.w900)),
                            const TextSpan(text: ' instead?'),
                          ], 
                          style: const TextStyle(color: Colors.white)
                        ),
                      ),
                    ),
                  );
                }
              ),

            ],
          );
        }
      ),
    );
  }

  /// Builds the individual item within the feed
  Widget _childBuilder(EbayItem item, bool isLast){
    return EbayItemListTile(item: item);
  }

  /// Builds the wrapping widget surrounding the feed
  Widget _buildWrapper(BuildContext context, Widget child, bool focused){

    // Determines whether to show the skeleton list of the items list
    // Shows the skeleton list when the feed is empty
    final list = state.state.controller.list().isEmpty ? SkeletonEbayItemListTile.skeletonBuilder(context, 10) : child;
    final bool endList = state.state.controller.hasMore() == false;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildRecommendedSearch(context),
              
              list,

              Container(height: 10,),

              //Display a text if no more items are available
              Center(
                child: endList ? const Text('End of list.', style: TextStyle(color: Colors.grey),) : const LoadingIndicator(),
              )
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
                placeholder: _placeHolderBuilder(context),
              ),
            )
          );
        }
      ),
    );
  }
}