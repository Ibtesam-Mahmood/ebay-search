

import 'package:ebay_search/models/ebay_item.dart';
import 'package:ebay_search/util/ebay_api.dart';
import 'package:feed/feed.dart';
import 'package:fort/fort.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

part 'search_events.dart';
part 'search_reducer.dart';

class SearchState extends FortState<SearchState>{

  /// If the text field is focused
  final bool isFocused;

  /// The search regex
  final String search;

  /// The recommended search regex
  final String recommendation;

  /// If the feed is loading
  final bool loaded;

  /// The feed controller for the search feed
  final FeedController controller;

  /// If the state is searching
  bool get searching => search.replaceAll(' ', '').isNotEmpty;

  SearchState({
    required this.isFocused, 
    required this.search, 
    required this.recommendation, 
    required this.loaded,
    required this.controller
  });

  factory SearchState.initial() => SearchState(
    isFocused: false, 
    search: '', 
    recommendation: '', 
    loaded: true,
    controller: FeedController(),
  );

  /// The feed loader for the search feed
  Future<FeedResponse<EbayItem>> loader(int size, [String? token]) async {
    if(!searching) {
      return const FeedResponse([], null);
    }

    final result = await EbayFindingApi.searchItemsByKeywordsFeed(
      keywords: search, 
      size: size, 
      pageToken: token
    );

    return result;
  }
  
  /// The getter that creates the tower
  static Tower<SearchState> get tower => Tower<SearchState>(
    _searchableFeedReducer,
    initialState: SearchState.initial(),
    middleware: [EpicMiddleware<SearchState>(_searchEpic)]
  );

  @override
  FortState<SearchState> copyWith(FortState<SearchState> other) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}

extension SearchableFeedStateStore on Store<SearchState>{

  //Calls the loader and set loading to true
  Future<FeedResponse<EbayItem>> loader(int size, [String? token]) async {
    dispatch(_SetLoadingEvent());

    final response = await state.loader(size, token);

    //Update the loading
    dispatch(_setLoadedAction(response));

    return response;
  }

}