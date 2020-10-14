if test -e ~/.nix-profile/etc/profile.d/nix.sh
  bass source ~/.nix-profile/etc/profile.d/nix.sh
end
if test -e ~/mdproxy/mdproxy_bash_profile
  bass source ~/mdproxy/mdproxy_bash_profile
end

function fish_greeting; end
function fish_right_prompt; end

