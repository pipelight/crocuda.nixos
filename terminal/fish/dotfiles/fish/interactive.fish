# Disbale welcome message
set fish_greeting

## Fix reflow bug
# set -Ux fish_handle_reflow 0

# Vim mod Colemak-DH keybindings
set -g fish_key_bindings fish_vi_key_bindings

# Before exec boulette execution


function fish_user_key_bindings

  # function bouletteproof_execute
  #   echo $argv
  #   boulette $argv
  # end
  # set -g bouletteproof_execute
  # bind -M insert \n "bouletteproof_execute $(commandline)"
  # bind -M insert \r "bouletteproof_execute $(commandline)"

  # Rebind Ctrl-L (clear)
  ## Push prompt to bottom
  bind -M default \f 'clear -x; tput cup (math round "$LINES * 3/4") 0; commandline -f repaint-mode'
  bind -M insert \f 'clear -x; tput cup (math round "$LINES * 3/4") 0; commandline -f repaint-mode'
end
set -g fish_user_key_bindings

## Plugins
direnv hook fish | source
atuin init fish | source
zoxide init fish | source

## FZF configuration
# Keybindings
fzf_configure_bindings --directory=\cf --history= --variable=

# Options
set fzf_preview_dir_cmd ls -alh --color=always
set fzf_preview_file_cmd nvim
set --export FZF_DEFAULT_OPTS \
  '--cycle --layout=reverse --border --height=40% --preview-window=wrap --marker="*" --preview=""'

# Abrev-tips config
# set -U ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"
# set -U ABBR_TIPS_ALIAS_WHITELIST # Not set
# set -U ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)' '(^( ?\w+){3}).*' '(^( ?\w+){2}).*' '(^( ?\w+){1}).*'

## Prompt
starship init fish | source
enable_transience

## Push prompt to bottom
tput cup (math round "$LINES * 3/4") 0

