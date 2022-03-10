import 'package:ebay_search/util/config_reader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tuple/tuple.dart';

import '../models/ebay_item.dart';

///The output type for FeedRequests
typedef FeedResponse<T> = Tuple2<List<T>, String?>;

/// Makes use of the Ebay Finding API to provide search results in a paginated HTTP request.
/// Provides a static interface to make API requests
class EbayFindingApi {

/*
 
     ____                            _       
    |  _ \ ___  __ _ _   _  ___  ___| |_ ___ 
    | |_) / _ \/ _` | | | |/ _ \/ __| __/ __|
    |  _ <  __/ (_| | |_| |  __/\__ \ |_\__ \
    |_| \_\___|\__, |\__,_|\___||___/\__|___/
                  |_|                        
 
*/

  /// Returns a list of recommended search results relative to the inputted keyword, along with the pagination output.
  /// The pagination is controlled through the page token which is a stringified representation of the page number
  static Future<FeedResponse<EbayItem>> searchItemsByKeywordsFeed({
    int size = 10,
    String keywords = '',
    String? pageToken,
  }) async {
    
    //Parse the pagination params
    final Map<String, dynamic> paginationInput = {
      'entriesPerPage': size,
    };
    if(pageToken != null){
      //Append page token
      paginationInput['pageNumber'] = pageToken;
    }

    //Create the inputs
    final uri = getURI({
      'keywords': keywords,
      'paginationInput': paginationInput
    });
    final headers = getHeaders('findItemsByKeywords');

    //Send request
    http.Response response = await http.get(uri, headers: headers);

    //Parse output
    if(response.statusCode == 200){
      final responseBody = jsonDecode(response.body)['findItemsByKeywordsResponse'][0];

      //Extract output items
      final searchResponse = responseBody['searchResult'][0];
      final paginationOutput = responseBody['paginationOutput'][0];

      //Extract the list of items
      final itemCount = int.parse(searchResponse['@count']);
      if(itemCount == 0){
        return const FeedResponse([], null); //Return back no items
      }

      final jsonItems = searchResponse['item'];
      final parsedItems = jsonItems.map<EbayItem>((json) => EbayItem.fromJson(json)).toList();

      //Extract next page token
      final nextPage = int.parse(paginationOutput['pageNumber'][0]) + 1;
      final maxPages = int.parse(paginationOutput['totalPages'][0]);

      //Assume the list has ended if the max page is reached, or the output size is less than the requested amount
      final listEnded = nextPage > maxPages || size > itemCount;
      final pageToken = listEnded ? null : '$nextPage'; //set to null if the end of the list is reached

      return FeedResponse(parsedItems, pageToken);
    }

    return Future.error('Error Retrieving items');

  }

  /// Returns a list of recommended search results relative to the inputted keyword
  static Future<List<String>> getSearchRecommendation(String keywords) async {

    //Several keywords are treated in an OR fashion
    final keywordInput = keywords.replaceAll(' ', '+');

    //Create the inputs
    final uri = getURI({'keywords': keywordInput});
    final headers = getHeaders('getSearchKeywordsRecommendation');

    //Send request
    http.Response response = await http.get(uri, headers: headers);

    //Parse output
    final List<String> recommendations = [];
    if(response.statusCode == 200){
      final responseBody = jsonDecode(response.body)['getSearchKeywordsRecommendationResponse'][0];
      recommendations.addAll(responseBody['keywords'].cast<String>());
    }

    //Return recommendations, defaulted to empty array
    return recommendations;

  }

/*
 
     _   _      _                     
    | | | | ___| |_ __   ___ _ __ ___ 
    | |_| |/ _ \ | '_ \ / _ \ '__/ __|
    |  _  |  __/ | |_) |  __/ |  \__ \
    |_| |_|\___|_| .__/ \___|_|  |___/
                 |_|                  
 
*/

  /// The API end point
  static String get endpoint => ConfigReader.getApiUrl();

  /// Creates a uri for a request to the finding API. the inputted params are parsed into query strings
  static Uri getURI([Map<String, dynamic> params = const {}]){
    var url = endpoint;

    //Add params if there are any
    if(params.isNotEmpty){
      url += '?'; //Query selector is appended
      for (var param in params.keys) {

        url += _parseURIField(param, params[param]);
      }
      url = url.substring(0, url.length - 1); // Remove the trailing & at the end
    }

    return Uri.parse(url);
  }

  /// parse the url element by checking its type
  /// Appends trailing & to continue the mappings
  static String _parseURIField(String name, dynamic value){
    
    if(value is Map){
      return value.map<String, dynamic>((key, value) => MapEntry(_parseURIField('$name.$key', value), null)).keys.join();
    }
    if(value is List){
      return List.generate(value.length, (i) => i).map((i) => _parseURIField('$name($i)', value[i])).join();
    }

    //Base case
    if(value is String){
      return '$name=${value.replaceAll(' ', '%20')}&'; //Parses any spaces present within the value
    }

    return '$name=$value&';
  }

  /// Creates a header object with default headers, and adds the map of additional headers
  /// The [operation] is a required parameter that defines the current api operation within the Finding API
  static Map<String, String> getHeaders(String operation, [Map<String, String> additionalHeaders = const {}]) {
    
    //Default Headers
    final headers = {

      // The SOA operation within the Finding API
      'X-EBAY-SOA-OPERATION-NAME': operation, 
      'X-EBAY-SOA-SERVICE-NAME': 'FindingService',
      'SERVICE-VERSION': '1.0.0',


      // Client APP ID
      'X-EBAY-SOA-SECURITY-APPNAME': ConfigReader.getClientAppID(), 

      // Input and Output formats
      'X-EBAY-SOA-REQUEST-DATA-FORMAT': 'NV',
      'X-EBAY-SOA-RESPONSE-DATA-FORMAT': 'JSON',

      //Localization
      'X-EBAY-SOA-GLOBAL-ID': 'EBAY-ENCA',
      'X-EBAY-C-MARKETPLACE-ID': 'EBAY_CA',
      'Accept-Language': 'en-CA',
      'Access-Control-Allow-Origin': '127.0.0.1:12345',
      'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE, HEAD',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    };

    //Adds all additional headers, these headers can override the default ones
    headers.addAll(additionalHeaders);

    return headers;
  }


}