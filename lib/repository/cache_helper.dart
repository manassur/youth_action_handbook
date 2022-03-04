import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  SharedPreferences? prefs;
   openCache() async {
    prefs = await SharedPreferences.getInstance();
  }
  /*
   * caches any string and key
   */
  void saveAnyStringToCache(String value,String key) async {
    await openCache();
    // check if the key even exists
    prefs!.setString(key,value);
  }

  /*
   * clear cache
   */
  void clearCache() async {
    await openCache();
    // check if the key even exists
    await prefs!.clear();
  }




  // checks shared preferences and fetches the user data saved there
 Future<String?> getAnyStringFromCache(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
      return value;
  }


}