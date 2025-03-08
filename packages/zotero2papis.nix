{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "zotero2papis";
  version = "latest";  # Could use a specific version tag if available

  src = fetchFromGitHub {
    owner = "nicolasshu";
    repo = "zotero2papis";
    rev = "main";  # Change to a commit hash or tag for reproducibility
    hash = "sha256-D4rOlI5i7LdtgiIAXwms0pPewZH7iVw26qDWc7ijCRc=";  # Replace this after running nix-prefetch-url
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    beautifulsoup4
    papis
    python-dateutil
  ];

  doCheck = false;  # No tests specified in the repo

  meta = with lib; {
    description = "Convert Zotero library to Papis format";
    homepage = "https://github.com/nicolasshu/zotero2papis";
    # license = licenses.mit;
    # maintainers = with maintainers; [ ];
  };
}
