{
  ...
}:
{
  # A module to disconnect Bluetooth and Wi-Fi on sleep, and reconnect on wakeup.

  flake.modules.darwin.macos-disconnect-on-sleep =
    { pkgs, ... }:
    let
      stateDir = "/tmp/disconnect-on-sleep";

      mkdir = "${pkgs.coreutils}/bin/mkdir";
      touch = "${pkgs.coreutils}/bin/touch";
      rm    = "${pkgs.coreutils}/bin/rm";
      awk   = "${pkgs.gawk}/bin/awk";
      blueutil = "${pkgs.blueutil}/bin/blueutil";
      networksetup = "/usr/sbin/networksetup";
      sleepwatcher = "${pkgs.sleepwatcher}/bin/sleepwatcher";

      sleepScript = pkgs.writeShellScript "sleep-handler" ''
        ${mkdir} -p ${stateDir}

        # Bluetooth
        status=$(${blueutil} --power)
        if [ "$status" = "1" ] && [ ! -e ${stateDir}/bt-keep ]; then
          ${blueutil} --power off
          ${touch} ${stateDir}/bt-restore
        fi

        # Wi-Fi
        WIFI_INT=$(${networksetup} -listallhardwareports | ${awk} '/Hardware Port: Wi-Fi/{getline; print $2}')
        if [ -n "$WIFI_INT" ]; then
          status=$(${networksetup} -getairportpower "$WIFI_INT")
          if [[ "$status" == *"On"* ]] && [ ! -e ${stateDir}/wifi-keep ]; then
            ${networksetup} -setairportpower "$WIFI_INT" off
            ${touch} ${stateDir}/wifi-restore
          fi
        fi
      '';

      wakeupScript = pkgs.writeShellScript "wakeup-handler" ''
        WIFI_INT=$(${networksetup} -listallhardwareports | ${awk} '/Hardware Port: Wi-Fi/{getline; print $2}')

        if [ -e ${stateDir}/bt-restore ]; then
          ${blueutil} --power on
          ${rm} -f ${stateDir}/bt-restore
        fi

        if [ -e ${stateDir}/wifi-restore ] && [ -n "$WIFI_INT" ]; then
          ${networksetup} -setairportpower "$WIFI_INT" on
          ${rm} -f ${stateDir}/wifi-restore
        fi
      '';

      launchScript = pkgs.writeShellScript "sleepwatcher-launcher" ''
        export PATH="${pkgs.coreutils}/bin:${pkgs.blueutil}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        exec ${sleepwatcher} -V -s ${sleepScript} -w ${wakeupScript}
      '';
    in
    {
      # Service definition
      launchd.user.agents.sleepwatcher = {
        serviceConfig = {
          Label = "org.nixos.sleepwatcher";
          Program = "${launchScript}";
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "${stateDir}/sleepwatcher.log";
          StandardErrorPath = "${stateDir}/sleepwatcher.err";
        };
      };

      # Shell aliases (cleaned up)
      environment.interactiveShellInit = ''
        _toggle_state() {
          local file="${stateDir}/$1"; mkdir -p "${stateDir}"
          if [ -e "$file" ]; then rm "$file"; echo "✅ $2 will DISCONNECT on sleep.";
          else touch "$file"; echo "🚀 $2 will STAY CONNECTED."; fi
        }
        wifi-keep() { _toggle_state "wifi-keep" "Wi-Fi"; }
        bt-keep()   { _toggle_state "bt-keep" "Bluetooth"; }
      '';
    };
}