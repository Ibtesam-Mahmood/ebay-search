
import 'dart:convert';
import 'package:flutter/services.dart';

/// The config reader is responsible for loading in application 
/// secrets and storing them statically within a Map object.
/// 
/// A static interface is also available to access secret variables programmatically. 
class ConfigReader{
  static late Map<String, dynamic> _config;

  /// Initializes the config from the file located in the /config folder.
  /// Must be run before retrieving application secrets
  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  /// Retrieves the Ebay application client ID
  static String getClientID(){
    return _config['APP_ID'] as String;
  }

  // Retrieves the Ebay developer ID
  static String getDevID(){
    return _config['DEV_ID'] as String;
  } 

  /// Retrieves the Ebay client certificate/secret
  static String getClientSecret(){
    return _config['CERT_ID'] as String;
  }

}