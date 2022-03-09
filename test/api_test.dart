import 'dart:io';

import 'package:ebay_search/util/ebay_api.dart';
import 'package:ebay_search/util/config_reader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  
  group('Test Ebay API', () {
    setUp(() async {
        // Initialize config reader and testing overrides
        TestWidgetsFlutterBinding.ensureInitialized();
        HttpOverrides.global = null;
        await ConfigReader.initialize();
    });
    
    test('Test getUri', () {
      
      //retrieve value
      final uri = EbayFindingApi.getURI({
        'param1': '1',
        'param2': 'hello from app'
      });
      
      //Expected value
      final expectedUri = ConfigReader.getApiUrl() + '?param1=1&param2=hello%20from%20app';

      expect(uri.toString(), expectedUri);
    });
    
    test('Test getUri List', () {
      
      //retrieve value
      final uri = EbayFindingApi.getURI({
        'param1': '1',
        'param2': 'hello from app',
        'param3': [
          'a', 'b', 'c'
        ]
      });
      
      //Expected value
      final expectedUri = ConfigReader.getApiUrl() + '?param1=1&param2=hello%20from%20app&param3(0)=a&param3(1)=b&param3(2)=c';

      expect(uri.toString(), expectedUri);
    });
    
    test('Test getUri Map', () {
      
      //retrieve value
      final uri = EbayFindingApi.getURI({
        'param1': '1',
        'param2': 'hello from app',
        'param3': {
          'inner1': 'a',
          'inner2': 'b',
          'inner3': 'c',
        }
      });
      
      //Expected value
      final expectedUri = ConfigReader.getApiUrl() + '?param1=1&param2=hello%20from%20app&param3.inner1=a&param3.inner2=b&param3.inner3=c';

      expect(uri.toString(), expectedUri);
    });
    
    test('Test getUri Complex', () {
      
      //retrieve value
      final uri = EbayFindingApi.getURI({
        'param1': '1',
        'param2': 'hello from app',
        'param3': [
          {
            'inner1': 'a',
            'inner2': 'b',
          },
          {
            'outer1': 'c',
            'outer2': 'd',
          },
        ]
      });
      
      //Expected value
      final expectedUri = ConfigReader.getApiUrl() + '?param1=1&param2=hello%20from%20app&param3(0).inner1=a&param3(0).inner2=b&param3(1).outer1=c&param3(1).outer2=d';

      expect(uri.toString(), expectedUri);
    });
    
    test('Test getHeaders', () {
      
      //retrieve value
      final header = EbayFindingApi.getHeaders('operation', {
        'param1': '1',
        'param2': 'hello from app',
        'X-EBAY-SOA-REQUEST-DATA-FORMAT': 'XML'
      });
      
      //Expected value
      final expectedHeader = {
        'X-EBAY-SOA-OPERATION-NAME': 'operation', 
        'X-EBAY-SOA-SERVICE-NAME': 'FindingService',
        'SERVICE-VERSION': '1.0.0',
        'X-EBAY-SOA-SECURITY-APPNAME': ConfigReader.getClientAppID(), 
        'X-EBAY-SOA-REQUEST-DATA-FORMAT': 'XML',
        'X-EBAY-SOA-RESPONSE-DATA-FORMAT': 'JSON',
        'X-EBAY-SOA-GLOBAL-ID': 'EBAY-ENCA',
        'X-EBAY-C-MARKETPLACE-ID': 'EBAY_CA',
        'Accept-Language': 'en-CA',
        'param1': '1',
        'param2': 'hello from app',
      };

      expect(header, expectedHeader);
    });
    
    test('Test getSearchRecommendation', () async {
      
      //retrieve value
      final List<String> response = await EbayFindingApi.getSearchRecommendation('applices');
      
      //Construct expected
      final List<String> expected = ['appliances'];

      expect(response, expected);
    });

    test('Test searchItemsByKeywordsFeed', () async {

      int expectedSize = 5;
      
      //retrieve value
      final FeedResponse response = await EbayFindingApi.searchItemsByKeywordsFeed(
        keywords: 'appliances',
        size: expectedSize,
      );

      expect(response.item1.length, expectedSize);
      expect(response.item2, '2');
    });
  });
}