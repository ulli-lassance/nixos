{ config, ... }:

{
  programs.mpv.scriptOpts.uosc = with config.lib.stylix.colors; {
    # timeline
    timeline_style = "bar";
    timeline_line_width = 2;
    timeline_size = 25;
    timeline_persistency = "paused";
    timeline_border = 1;
    timeline_step = 5;
    timeline_cache = true;

    # progress Bar
    progress = "windowed";
    progress_size = 2;
    progress_line_width = 20;

    # controls
    controls = "menu,open-file,command:history:script-binding memo-history?,gap,command:analytics:script-binding stats/display-stats-toggle?Statistics,stream-quality,<audio,has_image>command:image:script-binding uosc/video#video?Cover,<has_many_edition>editions,video,<has_audio,audio>audio,<has_sub>subtitles,<has_chapter>chapters,gap,space,speed,space,gap,<has_playlist>prev,<has_playlist>playlist,<has_playlist>next";
    controls_size = 37;
    controls_margin = 8;
    controls_spacing = 2;
    controls_persistency = "";

    # volume & speed
    volume = "right";
    volume_size = 39;
    volume_border = 1;
    volume_step = 1;
    volume_persistency = "";
    speed_step = 0.05;
    speed_step_is_factor = false;
    speed_persistency = "";

    # menu
    menu_item_height = 35;
    menu_min_width = 290;
    menu_padding = 4;
    menu_type_to_search = true;

    # top bar
    top_bar = "no-border";
    top_bar_size = 45;
    top_bar_controls = false;
    top_bar_title = true;
    top_bar_alt_title = "\${filename}";
    top_bar_alt_title_place = "toggle";
    top_bar_flash_on = "video,audio";
    top_bar_persistency = "";

    # window & border
    window_border_size = 1;
    autoload = false;
    shuffle = false;

    # UI scale & style
    scale = 1;
    scale_fullscreen = 1;
    font_scale = 1.18;
    text_border = 1.2;
    border_radius = 2;
    color = "foreground=${base0D},foreground_text=${base00},background=${base01},background_text=${base05},curtain=${base00}2,success=${base0B},error=${base08},match=${base03}";
    opacity = "timeline=0.8,speed=0,menu=0.84,title=0,tooltip=0.8,curtain=0.2,playlist_position=0.15";
    refine = "text_width";

    # animation & behavior
    animation_duration = 100;
    flash_duration = 1000;
    proximity_in = 40;
    proximity_out = 120;
    font_bold = true;
    destination_time = "total";
    time_precision = 0;
    buffered_time_threshold = 60;
    autohide = false;
    pause_indicator = "flash";

    # file types & streaming
    stream_quality_options = "4320,2160,1440,1080,720,480,360,240,144";
    video_types = "3g2,3gp,asf,avi,f4v,flv,h264,h265,m2ts,m4v,mkv,mov,mp4,mp4v,mpeg,mpg,ogm,ogv,rm,rmvb,ts,vob,webm,wmv,y4m";
    audio_types = "aac,ac3,aiff,ape,au,cue,dsf,dts,flac,m4a,mid,midi,mka,mp3,mp4a,oga,ogg,opus,spx,tak,tta,wav,weba,wma,wv";
    image_types = "apng,avif,bmp,gif,j2k,jp2,jfif,jpeg,jpg,jxl,mj2,png,svg,tga,tif,tiff,webp";
    subtitle_types = "aqt,ass,gsub,idx,jss,lrc,mks,pgs,pjs,psb,rt,sbv,slt,smi,sub,sup,srt,ssa,ssf,ttxt,txt,usf,vt,vtt";
    playlist_types = "m3u,m3u8,pls,url,cue";
    load_types = "video,audio,image";

    # directory navigation
    default_directory = "~/";
    show_hidden_files = false;
    use_trash = false;

    # OSD & chapters
    adjust_osd_margins = true;
    chapter_ranges = "openings:30abf964,endings:30abf964,intros:3fb95080,outros:3fb95080,ads:c54e4e80";
    chapter_range_patterns = "openings:オープニング$;endings:^end$,^End$,エンディング$;intros:preview$, Notice$;outros:credits$";

    # languages & misc
    languages = "slang,en";
    subtitles_directory = "~~/subtitles";
    disable_elements = "";
  };
}
