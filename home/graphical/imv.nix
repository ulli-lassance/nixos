{ ... }:

{
  programs.imv = {
    enable = true;
  };

  xdg.configFile."imv/config".text = ''
    [options]
    background=000000
    suppress_default_binds=true

    [binds]
    <Down>=zoom -1
    <Left>=prev
    <Right>=next
    <Shift+G>=goto -1
    <Shift+R>=rotate by 90
    <Up>=zoom 1
    <bracketleft>=prev
    <bracketright>=next
    <minus>=zoom -1
    <period>=next_frame
    <plus>=zoom 1
    <space>=toggle_playing
    a=upscaling next
    c=center
    d=next
    f=fullscreen
    gg=goto 1
    h=pan 50 0
    i=overlay
    j=pan 0 -50
    k=pan 0 50
    l=pan -50 0
    p=exec echo $imv_current_file
    q=quit
    r=reset
    s=prev
    x=zoom -1
    y=exec echo working!
    z=zoom 1
  '';
}
