{ mkDerivation, aeson, base, conduit, conduit-combinators
, conduit-extra, filepath, hjsonschema, resourcet, stdenv, text
, transformers, vector
}:
mkDerivation {
  pname = "couch-schema";
  version = "0.0.0.0";
  src = ./.;
  libraryHaskellDepends = [
    aeson base conduit conduit-combinators conduit-extra filepath
    hjsonschema resourcet text transformers vector
  ];
  testHaskellDepends = [
    base conduit conduit-combinators resourcet
  ];
  homepage = "https://github.com/mdorman/couch-schema";
  description = "Schema files for validating CouchDB output";
  license = stdenv.lib.licenses.mit;
}
