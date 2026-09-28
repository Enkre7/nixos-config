{ pkgs, ... }:
let
  installer = pkgs.requireFile {
    name = "CiscoPacketTracer_901_Ubuntu_64bit.deb";
    hash = "sha256-NoPdh+d5iFNyrpo1wabllNEvST5knnxpdAhynBRZR5s=";
    url = "https://www.netacad.com/resources/lab-downloads";
  };
in
{
  home.packages = [ pkgs.cisco-packet-tracer_9 ];

  xdg.dataFile."packettracer/CiscoPacketTracer_901_Ubuntu_64bit.deb".source = installer;
}
