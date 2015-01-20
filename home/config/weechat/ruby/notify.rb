def weechat_init                                                                                                                                                                                                                             
  Weechat.register("notify.rb", "madhatter", "0.1", "GPL3", "Notifications via libnotify", "", "")
  Weechat.hook_print("", "", "", 1, "notify_msg", "")
  return Weechat::WEECHAT_RC_OK
end
  
def notify_msg(data, buffer, date, tags, visible, highlight, nick, message)
   
  # Get the channel's metadata.
  data = {} 
  %w[ away type channel server ].each do |meta|
    data[meta.to_sym] = Weechat.buffer_get_string(buffer, "localvar_#{meta}");
  end  
  data[:away] = !data[:away].empty?
  
  # Remember the own nick name to ignore it in private messages
  my_nick = Weechat.info_get('irc_nick', data[:server])

  # If it is a highlight, a private message and not myself notify me.
  return Weechat::WEECHAT_RC_OK if highlight.to_i.zero? && data[:type] != 'private' or nick == my_nick
  
  `notify-send -i /usr/share/pixmaps/weechat.xpm "#{nick}" "#{message}"`
 
  return Weechat::WEECHAT_RC_OK
end
