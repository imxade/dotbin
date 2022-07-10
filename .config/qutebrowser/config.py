config.load_autoconfig(False)

c.content.webgl = False
c.content.autoplay = False
c.content.geolocation = False
c.content.canvas_reading = False
c.content.javascript.enabled = False
c.content.pdfjs = True
c.tabs.background = True
c.url.open_base_url = True
c.auto_save.session = True
c.input.insert_mode.auto_load = True
c.content.headers.do_not_track = True
c.content.notifications.enabled = True
c.colors.webpage.darkmode.enabled = True
c.tabs.show = 'always'
c.statusbar.show = 'always'
c.content.blocking.method = 'both'
c.content.headers.referer = 'same-domain'
#c.content.proxy = 'socks://localhost:9050/'
c.tabs.title.format_pinned = '{index} {audio}'
c.qt.args.append('widevine-path=widevine/libwidevinecdm.so')
c.content.webrtc_ip_handling_policy = 'disable-non-proxied-udp'
#c.content.webrtc_ip_handling_policy = 'default-public-interface-only'
c.content.headers.custom = {'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'}

config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

c.url.searchengines = {
        'DEFAULT': 'https://paulgo.io/search?q={}',
        'dd': 'https://duckduckgo.com/?q={}',
        'tw': 'https://twitch.tv/{}',
        'go': 'https://www.google.com/search?q={}', 
        'yt': 'https://www.youtube.com/results?search_query={}', 
        }

c.content.blocking.adblock.lists = [
        "https://easylist.to/easylist/easylist.txt",
        "https://easylist.to/easylist/easyprivacy.txt",
        "https://easylist.to/easylist/fanboy-social.txt",
        "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
        "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
        "https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
        #"https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt",
        #"https://www.i-dont-care-about-cookies.eu/abp/",
        #"https://gitlab.com/curben/urlhaus-filter/-/raw/master/urlhaus-filter.txt",
        ]

config.set('content.javascript.enabled', True, 'file:*')
config.set('content.javascript.enabled', True, 'https://127.0.0.1:*')
config.set('content.javascript.enabled', True, 'https://webtor.io/*')
config.set('content.javascript.enabled', True, 'https://gitlab.com/*')
config.set('content.javascript.enabled', True, 'https://amazon.com/*')
config.set('content.javascript.enabled', True, 'https://discord.com/*')
config.set('content.javascript.enabled', True, 'https://meet.jit.si/*')
config.set('content.javascript.enabled', True, 'https://fluffychat.im/*')
config.set('content.javascript.enabled', True, 'https://distrotest.net/*')
config.set('content.javascript.enabled', True, 'https://app.element.io/*')
config.set('content.javascript.enabled', True, 'https://animixplay.to/*')
config.set('content.javascript.enabled', True, 'https://www.youtube.com/*')
config.set('content.javascript.enabled', True, 'https://www.hotstar.com/*')
config.set('content.javascript.enabled', True, 'https://search.nixos.org/*')
config.set('content.javascript.enabled', True, 'https://drive.google.com/*')
config.set('content.javascript.enabled', True, 'https://web.telegram.org/*')
config.set('content.javascript.enabled', True, 'https://piped.kavin.rocks/*')

# Key-Binds
config.bind('pt', 'tab-pin')
config.bind('ee', 'spawn --userscript qute-pass')
config.bind('eo', 'spawn --userscript qute-pass --otp-only')
config.bind('xt', 'config-cycle tabs.show always never')
config.bind('xb', 'config-cycle statusbar.show always never')
config.bind('xj', 'config-cycle content.javascript.enabled True False')
config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')
config.bind(';W', 'spawn --detach mpv --force-window yes {url}')
config.bind('ep', 'spawn --userscript qute-pass --password-only')
config.bind('eu', 'spawn --userscript qute-pass --username-only')
config.bind(';w', 'hint links spawn --detach mpv --force-window yes {hint-url}')
config.bind(';;', ':jseval --world main VAR_SPEED = parseFloat(prompt("Enter global speed"))')
config.bind(';s', ':jseval document.querySelector("video, audio").playbackRate = parseFloat(prompt("Enter local speed"))')


# Font
c.fonts.default_family = '"Hurmit Nerd Font"'
c.fonts.default_size   = '14pt'

# Theme
config.source('themes/minimal/base16-horizon-dark.config.py') 
