
/* #2c2b00 backgroud color ***/

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
   user_pref("media.gmp-widevinecdm.enabled", true); // 2021 default-inactive in user.js
   user_pref("media.eme.enabled", true); // 2022

/* override recipe: enable WebGL ***/
   user_pref("webgl.disabled", false); //4520

/* enable Dark mode ***/
user_pref("ui.systemUsesDarkTheme", true);
user_pref("widget.content.allow-gtk-dark-theme", true);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("extensions.activeThemeID", firefox-compact-dark@mozilla.org);

/* enable Hardware Acceleration ***/
user_pref("gfx.webrender.all", true);
user_pref("media.ffmpeg.vaapi.enabled", true);

/* Do not warn on quit ***/
user_pref("browser.warnOnQuit", false);

/* 0801: enable Tor proxy
user_pref("network.proxy.type", 1);
user_pref("network.proxy.socks", 127.0.01);
user_pref("network.proxy.socks_port", 9050);
user_pref("network.proxy.socks_version", 5);
user_pref("network.proxy.socks_remote_dns", true);
***/

