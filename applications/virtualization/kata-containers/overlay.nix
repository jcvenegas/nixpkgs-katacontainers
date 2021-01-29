self: super:
let
  version = "1.13.0-alpha0";
  # prepare source to have a structure of GOPATH
  setSourceRoot = ''
  mkdir -p "go/src/$(dirname "$goPackagePath")"
  cp -R source "go/src/$goPackagePath"
  export sourceRoot="go/src/$goPackagePath"
  '';
   # default make flags, set GOPATH, GOCACHE and install prefix
   makeFlags = [
     "GOPATH=$(NIX_BUILD_TOP)/go"
     "GOCACHE=$(TMPDIR)/go-cache"
     "PREFIX=$(out)"
   ];

in
{
  agent = super.stdenv.mkDerivation {
    name = "kata-agent";

    src = super.fetchFromGitHub {
      owner = "kata-containers";
      repo = "agent";
      rev = version;
      sha256 = "026xmk6c1k5yvrk5rnqp8ac41ynv37x8szjxw884a9f57hnsa1p3";

    };

    goPackagePath = "github.com/kata-containers/agent";

    inherit setSourceRoot;

    nativeBuildInputs = [ self.pkgconfig self.go  ];
    buildInputs = [ self.libseccomp ];

    makeFlags = makeFlags ++ [
      "UNIT_DIR=$(out)/lib/systemd/system"
      "SECCOMP=yes"
    ];

  };

}
