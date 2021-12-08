" This wipes all existing settings. This means that if a setting in this file
" is removed, then it will return to default. In other words, this file serves
" as an enforced single point of truth for Tridactyl's configuration.
sanitize tridactyllocal tridactylsync

" Just use a blank page for new tab. It would be nicer to use the standard
" Firefox homepage, but Tridactyl doesn't support this yet.
set newtab about:blank

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

" Don't run Tridactyl on some web sites because it doesn't work well, or
" because the web site has its own keybindings.
blacklistadd mail.google.com
blacklistadd meet.google.com

" Git{Hub,Lab} git clone via SSH yank
bind yg composite js "git clone " + document.location.href.replace(/https?:\/\//,"git@").replace("/",":").replace(/$/,".git") | clipboard yank
