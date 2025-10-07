{
  slib,
  config,
}: let
  res = slib.user_add_many config.crocuda.users;
in
  res
