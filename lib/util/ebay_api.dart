import 'package:ebay_search/util/config_reader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  /// Returns a list of recommended search results relative to the inputted keyword
  static Future<List<String>> getSearchRecommendation(String keywords) async {

    //Create the inputs
    final uri = getURI({'keywords': keywords});
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
  static Uri getURI([Map<String, String> params = const {}]){
    var url = endpoint;

    //Add params if there are any
    if(params.isNotEmpty){
      url += '?'; //Query selector is appended
      for (var param in params.keys) {

        //Parses any spaces present within the value
        final value = params[param]!.replaceAll(' ', '%20');

        url += '$param=$value&'; //Each param is appended with a trailing &
      }
      url = url.substring(0, url.length - 1); // Remove the trailing & at the end
    }

    return Uri.parse(url);
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

      // // Input and Output formats
      'X-EBAY-SOA-REQUEST-DATA-FORMAT': 'NV',
      'X-EBAY-SOA-RESPONSE-DATA-FORMAT': 'JSON',
    };

    //Adds all additional headers, these headers can override the default ones
    headers.addAll(additionalHeaders);

    return headers;
  }


}