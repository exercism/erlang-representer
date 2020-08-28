{ pkgs, self, buildRebar3 }:

let
  version = if self ? shortRev then
    "${self.lastModifiedDate}-${self.shortRev}"
  else
    "${self.lastModifiedDate}-dirty";
in buildRebar3 {
  name = "erlang-representer";
  inherit version;

  src = self;

  beamDeps = [ ];

  patchPhase = "exit 1";
}
