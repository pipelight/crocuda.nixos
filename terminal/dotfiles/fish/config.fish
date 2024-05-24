# Disbale welcome message
set fish_greeting
# Source aliases
source ~/.aliases

# Vim mod Colemak-DH keybindings
set -g fish_key_bindings fish_vi_key_bindings

## Plugins
direnv hook fish | source
atuin init fish | source
zoxide init fish | source

## FZF configuration
# Keybindings
fzf_configure_bindings --directory=\ck
# Options
set fzf_preview_dir_cmd ls -alh --color=always
set fzf_preview_file_cmd nvim
set --export FZF_DEFAULT_OPTS \
  '--cycle --layout=reverse --border --height=40% --preview-window=wrap --marker="*" --preview=""'

# Abrev-tips config
set -U ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"
set -U ABBR_TIPS_ALIAS_WHITELIST # Not set
set -U ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)' '(^( ?\w+){3}).*' '(^( ?\w+){2}).*' '(^( ?\w+){1}).*'
