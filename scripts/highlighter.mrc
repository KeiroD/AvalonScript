/*
{

  jaytea's Highlight Thing

  Builds upon mIRC's own highlight system by providing a window
  to display all highlights and easily view them in context.

  Activate the script by using the channel or status window popup,
  or use the command /hl_start anywhere.

  Once activated, all highlights will be added to a window named
  @Highlights visible at the end of your switchbar or treebar.
  You may single click on any of those lines to activate the 
  window and automatically scroll back to the original message.

  If the message no longer exists in the source window buffer then
  it will not be clickable in @Highlights.

}
*/

; Change the return value to reflect the colour you would
; like moused over lines to switch to in @Highlights.
alias -l highlightCol return 4

menu @Highlights {
  &Clear:{
    hl_init
  }
  &Close:{
    close -@ @Highlights
  }
}

menu channel,status {
  Highlight Manager:{
    hl_start
  }
}

alias -l tab return $chr(9)
alias -l ellipsis {
  return $iif($version < 7, $&
    $utfdecode($+($chr(226), $chr(128), $chr(166))), $&
    $chr(8230))
}

on *:text:*:*:{
  hl_checkHL $cid $iif(#, #, $nick) $1-
}

on *:action:*:*:{
  hl_checkHL $cid $iif(#, #, $nick) $1-
}

on *:close:@Highlights:{
  if ($hget(hl)) hfree hl
}

on *:input:@Highlights:{
  if ($1 == /clear) {
    hl_init
    haltdef
  }
}

alias hl_checkHL {
  if ($3- isnum) || (!$window(@Highlights)) || (!$highlight($3-)) halt
  hl_addLine $1-
}

alias hl_start {
  if ($window(@Highlights)) window -c @Highlights

  window -ezin -t2,18,40  @Highlights

  hl_init
  echo -egac info2 * jaytea's Highlight Thing started. See documentation for information.
}

alias hl_init {
  if ($hget(hl)) hfree hl
  hmake hl
  clear @Highlights
  echo @Highlights $+($tab, $chr(31), Network, $tab, Window, $tab, Message)
  echo @Highlights $tab
}

on ^*:hotlink:*:@Highlights:{
  var %l = $gettok($hotlinepos, 2, 32)
  if (!$hget(hl, %l)) halt
  if ($mouse.key & 1) {
    hl_switchTo %l
    halt
  }
  if ($hget(hl, hlp) != $hotlinepos) { 
    hadd hl hlp $v2
    if ($hget(hl, ln) != %l) {
      hl_unHL $v1
      if (!$hl_hlLine(%l)) halt 
    }
    if ($mid($1, -1) == $ellipsis) && ($int($hotlinepos) < 3) {
      editbox @Highlights $gettok($hget(hl, %l), $calc(1 + $v1), 32)
    }
  }
  elseif ($timer(hl)) hl_timer
  else halt
}

; /hl_addLine <cid> <window> <message>

alias hl_addLine {
  scid $1
  var %ln = $line($2, 0), %col = $mid(0 $+ $line($2, %ln).color, -2), $&
    %net = $network, %name = $2, %l = $line($2, %ln)

  hadd hl $calc(1 + $line(@Highlights, 0)) $1 %net $2 %l
  echo -i41 @Highlights $+($tab, $&
    $left(%net, 12), $iif($len(%net) > 12, $ellipsis), $tab, $&
    $left(%name, 18), $iif($len(%name) > 18, $ellipsis), $tab, $&  
    %l) | ; %col could be incorporated here, though it looks slightly worse.
  echo @Highlights $tab
  scid -r
}

alias hl_switchTo {
  tokenize 32 $hget(hl, $1)
  if ($hl_findLine($1, $3, $4-)) {
    scid $1
    window -a $3
    findtext $4-
    scid -r
  }
}

alias hl_unHL {
  if ($1) || ($hget(hl, ln)) {
    rline $color(normal) @Highlights $v1 $line(@Highlights, $v1)
  }
}

alias hl_clear {
  hl_unHL
  hdel hl ln
  hdel hl hlp
  editbox @Highlights
}

alias hl_hlLine {
  tokenize 32 $1 $hget(hl, $1)
  hadd hl ln $1
  if ($hl_findLine($2, $4, $5-)) {
    rline $highlightCol @Highlights $1 $line(@Highlights, $1)
    hl_timer
    return $true
  }
}

alias hl_findLine {
  scid $1
  return $fline($2, $replace($3, *, ?), 1)
  scid -r
}

alias hl_timer {
  hadd hl mp $mouse.x $mouse.y
  .timerhl -m 0 50 if ($mouse.x $!mouse.y == $!hget(hl, mp)) return $(|) $&
    hl_clear $(|) .timerhl off
}
