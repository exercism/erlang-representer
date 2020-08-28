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

  patchPhase = ''
    substituteInPlace src/erl_representer.app.src \
      --replace "{vsn, \"dev\"}" "{vsn, \"${version}\"}"
  '';

  buildPhase = ''
    rebar3 escriptize
  '';

  installPhase = ''
    mkdir -p $out/bin
    install _build/default/bin/erl_representer $out/bin/erl_representer
  '';
}
