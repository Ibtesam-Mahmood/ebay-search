
part of 'search_state.dart';

/*
 
   ____          _                     
  |  _ \ ___  __| |_   _  ___ ___ _ __ 
  | |_) / _ \/ _` | | | |/ __/ _ \ '__|
  |  _ <  __/ (_| | |_| | (_|  __/ |   
  |_| \_\___|\__,_|\__,_|\___\___|_|   
                                       
 
*/

SearchState _searchableFeedReducer(SearchState state, dynamic event){
  if(event is _SearchEvent){
    return SearchState(
      isFocused: _setFocusReducer(state, event), 
      search: _setRedexReducer(state, event), 
      recommendation: _setKeywordRecomendationReducer(state, event), 
      loaded: _setLoadedReducer(state, event),
      controller: state.controller,
    );
  }
  return state;
}

/*
 
   ____        _       ____          _                     
  / ___| _   _| |__   |  _ \ ___  __| |_   _  ___ ___ _ __ 
  \___ \| | | | '_ \  | |_) / _ \/ _` | | | |/ __/ _ \ '__|
   ___) | |_| | |_) | |  _ <  __/ (_| | |_| | (_|  __/ |   
  |____/ \__,_|_.__/  |_| \_\___|\__,_|\__,_|\___\___|_|   
                                                           
 
*/

String _setRedexReducer(SearchState state, _SearchEvent event){
  if(event is _SetRedexEvent){
    return event.redex;
  }
  return state.search;
}

String _setKeywordRecomendationReducer(SearchState state, _SearchEvent event){
  if(event is _SetKeywordRecommendation){
    return event.recommendation;
  }
  else if(event is _SetLoadingEvent){
    return '';
  }
  return state.search;
}

bool _setLoadedReducer(SearchState state, _SearchEvent event){
  if(event is _SetLoadingEvent){
    return false;
  }
  else if(event is _SetLoadedEvent){
    return true;
  }
  return state.loaded;
}

bool _setFocusReducer(SearchState state, _SearchEvent event){
  if(event is UpdateFocusEvent){
    return event.focus;
  }
  return state.isFocused;
}