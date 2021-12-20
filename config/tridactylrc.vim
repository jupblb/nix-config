" This wipes all existing settings. This means that if a setting in this file
" is removed, then it will return to default. In other words, this file serves
" as an enforced single point of truth for Tridactyl's configuration.
sanitize tridactyllocal tridactylsync

" Run this once to disable all the GUI clutter
" guiset gui none

" But also support Tridactyl search too.
bind / fillcmdline find
bind ? fillcmdline find -?
bind n findnext 1
bind N findnext -1
bind <ESC> nohlsearch

" The default jump of 10 is a bit much.
bind j scrollline 5
bind k scrollline -5
bind <C-e> scrollline 1
bind <C-y> scrollline -1

" Git{Hub,Lab} git clone via SSH yank
bind yg composite js "git clone " + document.location.href.replace(/https?:\/\//,"git@").replace("/",":").replace(/$/,".git") | clipboard yank

" Search engines
set searchurls.ddg https://duckduckgo.com/html?q=%s
set searchurls.hn https://www.google.com/search?q=site%3Anews.ycombinator.com+%s
set searchurls.maps https://www.google.com/maps/search/%s/
set searchurls.r https://www.google.com/search?q=site%3Areddit.com+%s
set searchurls.wiki https://en.wikipedia.org/w/index.php?search=%s
set searchurls.yt https://www.youtube.com/results?search_query=%s
