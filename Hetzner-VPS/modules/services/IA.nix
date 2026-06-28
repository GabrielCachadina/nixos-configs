{ config, pkgs, ... }:

{
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				AI
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-

  services.ollama = {
    enable = false;
    # Optional: preload models, see https://ollama.com/library
    #loadModels = [
	#"phi3:3.8b" # Super small model
    #];
  };
}
