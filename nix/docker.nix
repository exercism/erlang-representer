{ pkgs, self, system, dockerTools, erlang-representer, bash }:

let
  tag = erlang-representer.version;

  run_sh = pkgs.writeScriptBin "run.sh" ''
    #!${bash}/bin/bash

    ${erlang-representer}/bin/erl_representer $1 $2 $3
  '';

  representer = self.packages.${system}.erlang-representer;
in dockerTools.buildLayeredImage {
  name = builtins.trace (system) "erlang-representer-docker";

  contents = [ erlang-representer run_sh ];

  extraCommands = ''
    mkdir -p opt/representer/bin
    ln -s ${run_sh}/bin/run.sh opt/representer/bin/run.sh
  '';

  config.Entrypoint = [ "/opt/representer/bin/run.sh" ];
}
