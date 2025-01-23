#!/usr/bin/env sh
# set -x

# Remove unused certificates in /letsencrypt

LETSENCRYPT_DIR="/etc/letsencrypt"

# Get cert names in required directories
get_cert_list(){
  #Args
  domain=$1
  directory=$2

  declare -a files=("")
  symlinks=$(eval "ls -d $LETSENCRYPT_DIR/$directory/$domain/*")
  for symlink in ${symlinks[@]}; do
    files+=" "$(basename $(readlink -f $symlink))
  done
  echo ${files[@]}
}

# Compare certificate names between /archive and /live directorise.
# Gather every certificate that is not live (unused)
compare_cert_lists(){
  #Args
  domain=$1

  archive=$(get_cert_list $domain "archive")
  # echo ${archive[@]}
  live=$(get_cert_list $domain "live")
  # echo ${live[@]}
  unused=$(echo ${archive[@]} ${live[@]} | tr ' ' '\n' | sort | uniq -u)
  for filename in ${unused[@]}; do
    path="$LETSENCRYPT_DIR/archive/$domain/$filename"
    echo $path
  done

}

main(){
  compare_cert_lists "areskul.com"
}

main
