# if arguments contain `l` (list) boolean flag
if string match -qr -- '(^|[^-])-\w*l' $argv
	set extra '--icons'
else
	set extra '--group-directories-first'
end

exa $extra $argv
