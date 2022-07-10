/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
  // user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
  // user_pref("places.history.enabled", true); // 0862 required if you had it set as false
user_pref("browser.sessionstore.privacy_level", 0); // 1003 [to restore cookies/formdata if not sanitized]
  // user_pref("network.cookie.lifetimePolicy", 0); // 2801 [DON'T: add cookie + site data exceptions instead]
user_pref("privacy.clearOnShutdown.history", false); // 2811
  // user_pref("privacy.clearOnShutdown.cookies", false); // 2811 optional: default false arkenfox v94
  // user_pref("privacy.clearOnShutdown.formdata", false); // 2811 optional
user_pref("privacy.cpd.history", false); // 2812 to match when you use Ctrl-Shift-Del
  // user_pref("privacy.cpd.cookies", false); // 2812 optional: default false arkenfox v94
  // user_pref("privacy.cpd.formdata", false); // 2812 optional

/* 0801: enable location bar using search ***/
user_pref("keyword.enabled", true); //0801

/* override recipe: enable DRM and let me watch videos ***/
   // user_pref("media.gmp-widevinecdm.enabled", true); // 2021 default-inactive in user.js
   //user_pref("media.eme.enabled", true); // 2022

/* override recipe: enable WebGL ***/
   //user_pref("webgl.disabled", false); //4520
