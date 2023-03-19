with config.pattern('google.com/search') as p:
    p.content.javascript.enabled = False
with config.pattern('reddit.com') as p:
    p.content.javascript.enabled = False
with config.pattern('stackoverflow.com') as p:
    p.content.javascript.enabled = False
