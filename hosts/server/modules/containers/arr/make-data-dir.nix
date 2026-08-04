{ config, ... }: {
  systemd.tmpfiles.rules = [
    "d ${config.settings.server.containerData} 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerData}/torrents 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerData}/torrents/movies 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerData}/torrents/music 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerData}/torrents/tv 0755 ${config.settings.user.username} users -"

    "d ${config.settings.server.containerData}/media 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerData}/media/movies 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerData}/media/music 0755 ${config.settings.user.username} users -"
    "d ${config.settings.server.containerData}/media/tv 0755 ${config.settings.user.username} users -"
  ];
}
