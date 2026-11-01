{ ... }: {
  services.journald = {
    settings.Journal = {
      SystemMaxUse = "100M";
      SystemMaxFileSize = "20M";
      MaxRetentionSec = "7days";
    };
  };
}
