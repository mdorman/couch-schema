{ mkDerivation, aeson, base, conduit, conduit-combinators
, conduit-extra, hjsonschema, resourcet, stdenv, filepath
, transformers, vector
}:
mkDerivation {
  pname = "couch-schema";
  version = "0.0.0.0";
  src = ./.;
  buildDepends = [
    aeson base conduit conduit-combinators conduit-extra hjsonschema
    resourcet filepath transformers vector
  ];
  testDepends = [ base conduit conduit-combinators resourcet ];
  homepage = "https://github.com/mdorman/couch-schema";
  description = "Schema files for validating CouchDB output";
  license = stdenv.lib.licenses.mit;
}
