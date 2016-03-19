[script] 
on 1!:PART:#: { writeini nicks.log entrance $site $nick | rnickbuf } 
on 1!:QUIT: { writeini nicks.log entrance $site $nick | rnickbuf } 
on 1:KICK:#: { writeini nicks.log entrance $remove($address($knick,2),*!*@) $knick | rnickbuf } 
alias RNICKBUF if ($lof(nicks.log) > 40000) { write -c nicks.log | echo 12 -se < clearing register entries > } 
on ^1!:JOIN:#: {  
  if (%avon == on) { r1nick $site $nick }  
  echo $color(join) -t # * $nick ( $+ $address $+ ) has joined #  $result | halt 
} 

alias r1nick {  
  set %anic $readini nicks.log entrance $$1  
  if ( %anic != $null ) && ( $$2 != %anic ) { 
    if %anic !isin %tclon {
      ;When using the white version, you will want to switch to the second line below. Remove the ; from the second line, then place the ; in front of the first line like so.
      set %texto 2[14 This user was also known as 4 %anic 14 in $chan $+ . 2]  2[10AvalonScript2] | unset %anic | return %texto
      ;set %texto 2[3 This user was also known as 6 %anic 3 in $chan $+ . 2]  2[3AvalonScript2] | unset %anic | return %texto
    } 
  } 
  unset %anic 
}

menu menubar,channel,nicklist { 
  Entrance Script.... on/off 
  .On:/set %avon on | echo -a 10,14 Entrance Script has been activated!
  .Off:/set %avon off | echo -a 10,14 Entrance Script has been turned off!
} 
