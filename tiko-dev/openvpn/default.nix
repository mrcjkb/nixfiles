# TODO: Move this to a private tiko GitLab repo and encrypt secrets with SOPS?
{ nixUser, openvpnUser }: 
{
  services = {
    openssh = {
      enable = true;
      # Authenticate using file specified in ses-admin.ovpn
      passwordAuthentication = false;
    };
    openvpn.servers = {
      officeVPN = { 
        config = '' config /home/${nixUser}/.sec/openvpn/${openvpnUser}/ses-admin.ovpn ''; 
        updateResolvConf = true;
        autoStart = false;
      };
    };
  };
}
