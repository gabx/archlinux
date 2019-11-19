i3-msg "workspace Firefox; append_layout $HOME/.config/i3/layouts/firefox.json"
i3-msg "workspace Chat; append_layout $HOME/.config/i3/layouts/chat.json"
sleep 0.5
(firefox-developer-edition &)
(slack &)

