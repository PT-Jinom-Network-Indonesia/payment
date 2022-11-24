class Config {
  static bool DEBUG = true;

  static String DEBUG_URL = "https://va.sandbox.jinom.net"; 
  static String PRODUCTION_URL = "https://payment.jinom.net"; 


  static String getUrl() {
    return DEBUG ? DEBUG_URL : PRODUCTION_URL;
  }
}