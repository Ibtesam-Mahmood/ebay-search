
part of 'search_state.dart';

/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

abstract class _SearchEvent{}

//Starts a search
class _SetRedexEvent extends _SearchEvent{
  final String redex;

  _SetRedexEvent(this.redex);
}

class _SetLoadingEvent extends _SearchEvent{}

class _SetLoadedEvent extends _SearchEvent{}

///updates the focus
class UpdateFocusEvent extends _SearchEvent{
  
  final bool focus;

  UpdateFocusEvent(this.focus);
}

///updates the focus
class _SetKeywordRecommendation extends _SearchEvent{
  
  final String recommendation;

  _SetKeywordRecommendation(this.recommendation);
}

/*
 
      _        _   _                 
     / \   ___| |_(_) ___  _ __  ___ 
    / _ \ / __| __| |/ _ \| '_ \/ __|
   / ___ \ (__| |_| | (_) | | | \__ \
  /_/   \_\___|\__|_|\___/|_| |_|___/
                                     
 
*/

ThunkAction<SearchState> performSearch(String search){
  return (Store<SearchState> store) async {
    if(search.replaceAll(' ', '') != store.state.search.replaceAll(' ', '')){
      store.dispatch(_SetLoadingEvent());
      store.dispatch(_SetRedexEvent(search));
    }
  };
}

///Sets loaded to true and updates the feed of items
ThunkAction<SearchState> _setLoadedAction(FeedResponse<EbayItem> result){
  return (Store<SearchState> store) async {

    store.dispatch(_SetLoadedEvent());
  };
}

/*
  
   _____       _      
  | ____|_ __ (_) ___ 
  |  _| | '_ \| |/ __|
  | |___| |_) | | (__ 
  |_____| .__/|_|\___|
        |_|           
 
*/

///Epic middleware used to perform a search the search action
Stream<dynamic> _searchEpic(
  Stream<dynamic> actions,
  EpicStore<SearchState> store,
) {
  return actions
      .whereType<_SetRedexEvent>()
      .debounceTime(const Duration(milliseconds: 300))
      .switchMap((action) {
        return Stream.fromFuture(_searchHelper(store.state)
        .then((result) {

          //Update the feed
          store.state.controller.setState(InitialFeedState(
            hasMore: result.item2 != null,
            pageToken: result.item2,
            items: result.item1
          ));

          //Set loading
          return _setLoadedAction(result);

        }))
        .takeUntil(actions.whereType<_SetLoadingEvent>());
  });
}

/*
 
   _   _      _                 
  | | | | ___| |_ __   ___ _ __ 
  | |_| |/ _ \ | '_ \ / _ \ '__|
  |  _  |  __/ | |_) |  __/ |   
  |_| |_|\___|_| .__/ \___|_|   
               |_|              
 
*/

Future<FeedResponse<EbayItem>> _searchHelper(SearchState state) async {

  //Clears the feed state
  state.controller.clear();

  //Attempts to load the state
  return state.loader(30);
}