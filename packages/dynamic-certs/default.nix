{ lib, buildGoModule }:

buildGoModule {
  pname = "dynamic-certs";
  version = "0.1.0";

  src = ./.;

  vendorHash = "sha256-AkoNyDJlK/P9rJFIw4iavgdSjMDpq5sxHb53Tsn+Pms=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    mainProgram = "dynamic-certs";
    description = "Dynamic certificate authority bundle manager";
    license = licenses.mit;
    maintainers = [ ];
  };
}
