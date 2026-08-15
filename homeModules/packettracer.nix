{ pkgs, ... }:
let
  packettracer = pkgs.cisco-packet-tracer_9.override {
    requireFile = _: ../dotfiles/CiscoPacketTracer_900_Ubuntu_64bit.deb;
  };
in
{
  home.packages = [ packettracer ];
}
