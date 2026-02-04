{ lib, config, ... }:

{
  options.globals.username = lib.mkOption {
    type = lib.types.str;
    description = "Primary user name";
    default = "gabriel";
  };
  options.globals.diskid = lib.mkOption {
    type = lib.types.str;
    description = "Primary disk";
    default = "58171d78-2e10-4597-a346-f04a6778863a";
  };
  options.globals.syncnixos = lib.mkOption {
    type = lib.types.str;
    description = "Location of the Sync/ Folder";
    default = "Nomad-USB";
  };
}
