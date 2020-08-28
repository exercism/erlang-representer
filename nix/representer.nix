{ self, buildRebar3 }:
buildRebar3 {
  name = "erlang-representer";
  version = "${self.shortRev}-${self.lastModifiedDate}";

  src = self;

  beamDeps = [ ];
}
