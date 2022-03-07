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
  });
}