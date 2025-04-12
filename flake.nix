{
  description = "Basic nodejs template";

  inputs.nixpkgs.url = "nixpkgs";

  outputs = {nixpkgs, ...}: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

    nixpkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
      });
  in {
    packages = forAllSystems (system: {});

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodePackages_latest.nodejs
            nodePackages_latest.prettier
            nodePackages_latest.typescript
            nodePackages_latest.pnpm
            nodePackages_latest.vercel
          ];
        };
      }
    );
  };
}
