{
  ...
}:

{
  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
    control = "sufficient";
    challengeResponsePath = null; # TODO
  };

}