alias ShowError {
  dialog -m AMSGError AMSGError
}
dialog AMSGError {
  title "Error"
  option dbu
  size 80 95 80 38
  box "",9, 1 0 78 22
  button "Ok",10, 1 24 78 12, cancel
  text %AMSGError,11, 3 5 74 16, center
}
on 1:open:?:{
  if (%QueryControl == off) halt
  haltdef 
  if (($readini(ExceptionList.ini,Nick,$nick)) || ($readini(ExceptionList.ini,Address,$address($nick,2)) != $null)) return
  close -m $nick
  if (($readini(ExceptionList.ini,INick,$nick)) || ($readini(ExceptionList.ini,IAddress,$address($nick,2)) != $null)) return
  if (($dialog(QueryControl)) && (%NotifyOtherPM == 1)) { echo -a 12[4AV2 Query Control12]10 $nick sent you a query while the PM Blocker dialog has already opened. | return }
  set %QueryNick $nick
  if ($comchan($nick,0) == 0) set %QueryAddress UnknownAddress
  else set %QueryAddress $address($nick,2)
  set %QueryMessage $1-
  set %QueryTime $($Timestamp,2)
  writenextini QueryControl.ini All %QueryNick said: %QueryMessage at $fulldate
  msg $nick 12[4AvalonScript Message Manager12]10 $+ $iif(%OnOpen,%OnOpen,You have activated my Query Control $+ $chr(44) please wait for a response.)
  dialog -m QueryControl QueryControl
  if (%AutoReject == on) { .timerReject $+ $Nick 1 %QueryInterval QueryReject $nick }
}
Alias QueryReject {
  close -m $1
  if (%AutoRejectReason) msg $1 12[4AvalonScript Message Manager12]10 Your message got rejected reason being: %AutoRejectReason $+ .)
  else msg $1 12[4AvalonScript Message Manager12]10 Your message got rejected $+ $iif(%RejectReason,$chr(44) the reason being: %RejectReason,.)
  if ($dialog(QueryControl)) { UnsetQuery | dialog -x QueryControl }
}
dialog QueryControl {
  title "AvalonScript Message Manager"
  option dbu
  size 160 175 140 155
  box "User",1, 1 1 47 22
  edit %QueryNick,2, 5 9 40 10, read autohs
  box "Address",3, 60 1 81 22
  edit %QueryAddress,4, 63 9 72 10, read autohs
  box "Message",5, 1 25 140 22
  edit %QueryMessage,6, 5 33 130 10, read autohs
  button "Accept",7, 5 53 25 12
  button "Reject",8, 40 53 25 12
  button "Ignore",9, 75 53 25 12
  button "Silence",10, 110 53 25 12
  box "",11,1 48 140 20
  box "Exception list",12,1 73 62 20
  button "Add nick",13, 5 80 25 10
  button "Add host",14, 35 80 25 10
  box "Query Ignore",15,78 73 62 20
  button "Nick",16, 82 80 25 10
  button "Host",17, 112 80 25 10
  check "Enable",18, 5 103 25 8
  text "Interval (seconds):",19,63 103 55 10
  combo 20, 111 101 25 10, drop
  box "Auto reject",21,1 95 139 20
  button "Ok",22, 5 135 25 13
  button "Logs",28, 42 135 25 13
  button "Options",23, 78 135 25 13
  button "Cancel",24, 112 135 25 13, cancel
  box "",25,1 130 140 20
  edit %RejectReason,26,5 119 130 10
  box "",27,1 113 140 19
}
on 1:dialog:QueryControl:init:0:{ 
  did -i QueryControl 20 1 10 | did -i QueryControl 20 2 20 |  did -i QueryControl 20 3 30 | did -i QueryControl 20 4 45 | did -i QueryControl 20 5 60 | did -i QueryControl 20 6 90 | did -i QueryControl 20 7 180 | did -i QueryControl 20 8 300 | did -i QueryControl 20 9 600 
  if (%AutoReject == on) { did -c QueryControl 18 | did -e QueryControl 20 | did -c QueryControl 20 %IntervalNum }
  else did -b QueryControl 20
}
on *:dialog:QueryControl:sclick:*:{
  if ($did == 7) { .timerReject $+ %Querynick off | set %RejectReason $did(26) | query %QueryNick | echo %QueryNick %QueryTime < $+ %QueryNick $+ > %QueryMessage | msg %QueryNick 12[4AvalonScript Message Manager12]10 Your message has been accepted, you may proceed. | UnsetQuery | dialog -x QueryControl }
  if ($did == 8) { set %RejectReason $did(26) | msg %QueryNick 12[4AV2 Query Control12]10 Your message got rejected $+ $iif(%RejectReason,$chr(44) the reason being:11 %RejectReason, $+ .) | .timerReject $+ %QueryNick off | UnsetQuery | dialog -x QueryControl }
  if ($did == 9) { ignore %QueryAddress | .timer $+ %QueryNick $+ Ignore 1 600 ignore -r %QueryAddress }
  if ($did == 10) { silence + $+ %QueryAddress | .timer $+ %QueryNick $+ Silence 1 600 silence - $+ %QueryAddress }
  if ($did == 13) { 
    if ($readini(ExceptionList.ini,Nick,%QueryNick) == $null) {  writeini -n ExceptionList.ini Nick %QueryNick $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt) | msg %QueryNick 12[4AvalonScript Message Manager12]10 Your nick has been added to my exception list, fell free to talk now. }
    else { set %AMSGError That nick is already excempt from the Query Control. | ShowError | return } 
  }
  if ($did == 14) { 
    if (%QueryAddress == Unknown due to lack of common channels) { set %AMSGError The address is unknown; therefore, you cannot add it. | ShowError | return }
    if ($readini(ExceptionList.ini,Address,%QueryAddress) == $null) { writeini -n ExceptionList.ini Address %QueryAddress $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt) | msg %QueryNick 12[4AvalonScript Message Manager12]10 Your host has been added to my exception list, fell free to talk now. }
    else { set %AMSGError That host is already excempt from the Query Control. | ShowError | return } 
  }
  if ($did == 16) { 
    if ((!%QueryNick) && (!%QueryAddress)) { set %AMSGError There is nothing to ignore. | ShowError | return }
    did -b $dname 16 | if ($readini(ExceptionList.ini,INick,%QueryNick) == $null) {  writeini -n ExceptionList.ini INick %QueryNick $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt) }
  }
  if ($did == 17) { 
    if ((!%QueryNick) && (!%QueryAddress) && (!%QueryMessage)) { set %AMSGError There is nothing to log. | ShowError | return }
    did -b $dname 17 | $readini(ExceptionList.ini,IAddress,%QueryAddress) == $null) { writeini -n ExceptionList.ini IAddress %QueryAddress $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt) }
  }
  if ($did == 18) {
    if ($did(18).state == 1) { did -e QueryControl 20 | set %AutoReject on }
    else { did -b QueryControl 20 | set %AutoReject off | unset %IntervalNum }
  }
  if ($did == 22) {
    if (%OkButton == QuietClose) dialog -x $dname
    if ((%AutoReject == on) && ($did(20) == $null)) { set %AMSGError You must specify an interval to auto-reject incoming queries. | ShowError | return }
    set %RejectReason $did(26) | set %QueryInterval $did(20) 
    if ($did(20) < 40) set %IntervalNum $calc($did(20) /10)
    elseif ($did(20) == 45) set %IntervalNum 4
    elseif ($did(20) == 60) set %IntervalNum 5
    elseif ($did(20) == 90) set %IntervalNum 6
    elseif ($did(20) == 180) set %IntervalNum 7
    elseif ($did(20) == 300) set %IntervalNum 8
    elseif ($did(20) == 600) set %IntervalNum 9
    if (%OkButton == Apply) { UnsetQuery | dialog -x QueryControl }
    elseif (%OkButton == QuietOpen) { query %QueryNick | echo %QueryNick %QueryTime < $+ %QueryNick $+ > %QueryMessage } 
    elseif (%OkButton == Random) {
      set %RandVar $r(1,3)
      if (%RandVar == 1) { query %QueryNick | echo %QueryNick %QueryTime < $+ %QueryNick $+ > %QueryMessage }
      elseif %RandVar == 2) { dialog -x $dname }
      else { UnsetQuery | dialog -x QueryControl }
    }
    else { UnsetQuery | dialog -x QueryControl }
  }
  if ($did == 23) { UnsetQuery | dialog -x Querycontrol | dialog -m QueryControlOptions2 QueryControlOptions2 }
  if ($did == 28) { UnsetQuery | dialog -x Querycontrol | dialog -m QueryControlOptions QueryControlOptions }
}
alias UnsetQuery { unset %QueryNick | unset %QueryAddress | unset %QueryMessage }
dialog QueryControlOptions {
  showrecent
  title "AvalonScript Message Manager Exception and Ignore lists"
  size -1 -1 220 180
  option dbu
  text "Oldest                        To                    Newest                      Nicks:" 1,5 13 26 55
  combo 2,28 11 55 55
  text "Oldest                        To                    Newest                      Hosts:" 3,98 13 26 50
  combo 4,125 11 90 55
  text "Oldest                        To                    Newest                      Nicks:" 5,5 95 26 50
  text "Oldest                        To                    Newest                      Hosts:" 17,98 95 26 50
  combo 6,28 95 55 55, autohs 
  combo 18,125 95 90 55
  button "Add",7,27 65 20 10
  button "Delete",8,63 65 20 10
  button "Add",9,135 65 20 10
  button "Delete",10,180 65 20 10
  button "Add",19,27 150 20 10
  button "Delete",20,63 150 20 10
  button "Add",21,135 150 20 10
  button "Delete",22,180 150 20 10
  box "Exceptions",12, 1 1 217 77
  box "Ignore",13,1 85 217 77
  button "Ok",14,10 165 25 10,cancel
  button "Options"15,95 165 25 10
  button "Cancel",16,185 165 25 10,cancel
}

on 1:dialog:QueryControlOptions:init:0:{ 
  set %x 1
  while ($ini(ExceptionList.ini,Nick,%x)) {
    did -i QueryControlOptions 2 %x $ini(ExceptionList.ini,Nick,%x)
    inc %x
  }
  set %x 1
  while ($ini(ExceptionList.ini,Address,%x)) {
    did -i QueryControlOptions 4 %x $ini(ExceptionList.ini,Address,%x)
    inc %x
  }
  set %x 1
  while ($ini(ExceptionList.ini,INick,%x)) {
    did -i QueryControlOptions 6 %x $ini(ExceptionList.ini,INick,%x)
    inc %x
  }
  set %x 1
  while ($ini(ExceptionList.ini,IAddress,%x)) {
    did -i QueryControlOptions 18 %x $ini(ExceptionList.ini,IAddress,%x)
    inc %x
  }
}
on *:dialog:QueryControlOptions:sclick:*:{
  if ($did == 7) {
    if ($did(2) == $null) { set %AMSGError No user specified to add to the exception list. | ShowError | return }
    if $readini(ExceptionList.ini,Nick,$did(2)) { set %AMSGError That user already appears to be in the exception list. | ShowError | return }
    writeini ExceptionList.ini Nick $did(2) $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt)
    did -r QueryControlOptions 2
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 8) {
    if ($did(2) == $null) { set %AMSGError No user specified to delete from the exception list. | ShowError | return }
    if ($readini(ExceptionList.ini,Nick,$did(2)) == $null) { set %AMSGError That user does not appear to be in the exception list. | ShowError | return }
    remini ExceptionList.ini Nick $did(2)
    did -r QueryControlOptions 2
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 9) {
    if ($did(4) == $null) { set %AMSGError No host specified to add to the exception list. | ShowError | return }
    if ($left($did(4),4) != *!*@) { set %AMSGError The host must be in type 2 format (*!*@Example.com). | ShowError | return }
    if $readini(ExceptionList.ini,Address,$did(4)) { set %AMSGError That host already appears to be in the exception list. | ShowError | return }
    writeini ExceptionList.ini Address $did(4) $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt)
    did -r QueryControlOptions 4
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 10) {
    if ($did(4) == $null) { set %AMSGError No host specified to delete from the exception list. | ShowError | return }
    if ($readini(ExceptionList.ini,Address,$did(4)) == $null) { set %AMSGError That host does not appear to be in the exception list. | ShowError | return }
    remini ExceptionList.ini Address $did(4)
    did -r QueryControlOptions 4
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 11) {
    if ($did(6) == $null) { set %AMSGError No logged message specified to delete from the logs. | ShowError | return }
    if ($InList(Message,$did(6)) == no) { set %AMSGError That message does not appear to be in the log list. | ShowError | return }
    RemoveFromList All $did(6)
    did -r QueryControlOptions 6
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 15) {
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions2 QueryControlOptions2
  }
  if ($did == 19) {
    if ($did(6) == $null) { set %AMSGError No user specified to add to the ignore list. | ShowError | return }
    if $readini(ExceptionList.ini,INick,$did(6)) { set %AMSGError That user already appears to be in the exception list. | ShowError | return }
    writeini ExceptionList.ini INick $did(6) $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt)
    did -r QueryControlOptions 6
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 20) {
    if ($did(6) == $null) { set %AMSGError No user specified to delete from the ignore list. | ShowError | return }
    if ($readini(ExceptionList.ini,INick,$did(6)) == $null) { set %AMSGError That user does not appear to be in the exception list. | ShowError | return }
    remini ExceptionList.ini INick $did(6)
    did -r QueryControlOptions 6
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 14) dialog -x QueryControlOptions
  if ($did == 21) {
    if ($did(18) == $null) { set %AMSGError No host specified to add to the ignore list. | ShowError | return }
    if ($left($did(4),4) != *!*@) { set %AMSGError The host must be in type 2 format (*!*@Example.com). | ShowError | return }
    if $readini(ExceptionList.ini,IAddress,$did(18)) { set %AMSGError That host already appears to be in the exception list. | ShowError | return }
    writeini ExceptionList.ini IAddress $did(18) $asctime($ctime,dddd mmmm dd $+ $chr(44) yyyy  hh:nn:sstt)
    did -r QueryControlOptions 18
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
  if ($did == 22) {
    if ($did(18) == $null) { set %AMSGError No host specified to delete from the ignore list. | ShowError | return }
    if ($readini(ExceptionList.ini,IAddress,$did(18)) == $null) { set %AMSGError That host does not appear to be in the exception list. | ShowError | return }
    remini ExceptionList.ini IAddress $did(18)
    did -r QueryControlOptions 18
    dialog -x QueryControlOptions
    dialog -m QueryControlOptions QueryControlOptions
  }
}
alias RemoveFromList {
  set %x 1
  set %y 0
  while ($ini(QueryControl.ini,$1,%x)) {
    if (%y < $ini(QueryControl.ini,$1,%x)) set %y $ini(QueryControl.ini,$1,%x)
    inc %x
  }
  set %x 1
  while (%x <= %y) {
    if ($readini(querycontrol.ini,$1,%x) == $2-) { remini QueryControl.ini $1 %x | return }
    inc %x
  }
}
alias InList {
  set %x 1
  set %y 0
  while ($ini(QueryControl.ini,$1,%x)) {
    if (%y < $ini(QueryControl.ini,$1,%x)) set %y $ini(QueryControl.ini,$1,%x)
    inc %x
  }
  set %x 1
  while (%x <= %y) {
    if ($readini(querycontrol.ini,$1,%x) == $2-) { return yes }
    inc %x
  }
  return no
}
dialog QueryControlOptions2 {
  showrecent
  title "AvalonScript Message Manager Options"
  size -1 -1 227 105
  option dbu
  text "Ok button function:",1, 5 15 55 10
  combo 2, 57 13 120 10, drop
  text "Auto Reject reason:"3,5 30 55 10
  edit %AutoRejectReason,4,57 28 120 10
  text "Rejection    reason:",5,5 45 55 10
  edit %RejectReason,6,57 43 120 10
  text "Open  query   msg:",7,5 62 50 10
  edit %OnOpen,8,57 60 120 10
  box "Messaging",9,1 1 180 85
  button "Enable",10,182 12 20 10
  button "Disable",11,204 12 22 10
  button "Logs",12,182 27 20 10
  button "Set up",13,204 27 22 10
  button "Clear",14,182 43 20 10
  button "Default",15,204 43 22 10
  button "Help",16,182 60 20 10
  button "About",17,204 60 22 10
  button "Ok",18,10 90 25 10
  button "Cancel",19,195 90 25 10,cancel
  text "Notify you when somebody is PMing while blocker is activated:",20,5 76 155 10
  button "Yes",21,182 75 20 10
  button "No",22,204 75 22 10
}
on 1:dialog:QueryControlOptions2:init:0:{ 
  did -i $dname 2 1 Apply | did -i $dname 2 2 QuietOpen | did -i $dname 2 3 QuietClose | did -i $dname 2 4 Random
  did -c $dname 2 %OkButton
}
on *:dialog:QueryControlOptions2:sclick:*:{
  if ($did == 10) set %QueryControl on
  if ($did == 11) set %QueryControl off
  if ($did == 12) { dialog -x $dname | dialog -m QueryControlLogs QueryControlLogs }
  if ($did == 13) { dialog -x $dname | dialog -m QueryControlOptions QueryControlOptions }
  if ($did == 14) { did -r $dname 4,6,8 }
  if ($did == 15) { set %AutoRejectReason Automatically rejected due to inactivity | set %RejectReason Generic rejection message | set %OnOpen You have activated my Query Control $+ $chr(44) please wait for a response. | dialog -x $dname | dialog -m QueryControlOptions2 QueryControlOptions2 }
  if ($did == 16) { did -b $dname 16 | dialog -m QueryControlHelp QueryControlHelp }
  if ($did == 17) { did -b $dname 17 | dialog -m QueryControlAbout QueryControlAbout }
  if ($did == 18) { set %OkButton $did(1) | set %AutoRejectReason $did(4) | set %RejectReason $did(6) | set %OnOpen $did(8) | dialog -x $dname }
  if ($did == 21) { set %NotifyOtherPM 1 }
  if ($did == 22) { set %NotifyOtherPM 0 }
}
dialog QueryControlHelp {
  showrecent
  title "AvalonScript Message Manager Options Help"
  size -1 -1 200 50
  option dbu
  text "Enable/Disable: Enable and disable the entire query control.",1,7 5 200 10
  text "Logs/Setup: Opens either the logs dialog or the initial on-open dialog.",2,7 12 200 10
  text "Clear/Defult: Clears all text fields, or sets them to the default values.",3,7 19 200 10
  text "Help/About: Gives help about the buttons, or info about the query control.",4,7 26 200 10
  button "Close",5,80 35 25 10
}
on *:dialog:QueryControlHelp:sclick:*:{
  if ($did == 5) { dialog -x $dname | did -e QueryControlOptions2 16 }
}
dialog QueryControlAbout {
  showrecent
  title "About AvalonScript Message Manager"
  size -1 -1 130 50
  option dbu
  text "Created: December 15th, 2013",1,7 5 200 10
  text "Author: Keiro",2,7 12 200 10
  text "Server: DarkMyst, irc.darkmyst.org",3,7 19 200 10
  text "Version: 0.3",4,7 26 200 10
  button "Close",5,50 35 25 10
}
on *:dialog:QueryControlAbout:sclick:*:{
  if ($did == 5) { dialog -x $dname | did -e QueryControlOptions2 17 }
}
alias WriteNextIni {
  set %x 1
  while ($ini(QueryControl.ini,$2,%x)) {
    if (!$readini(QueryControl.ini,$2,%x)) { writeini -n $1 $2 %x $3- | return }
    inc %x
  }
  writeini -n $1 $2 %x $3-
}
alias RemoveFromList2 {
  set %x 1
  while (%x <= %highest)) {
    if ($readini(QueryControl.ini,Message,%x)) == $1) { remini QueryControl.ini | return }
    inc %x
  }
}
dialog QueryControlLogs {
  showrecent
  title "AvalonScript Message Manager Full Logs"
  size -1 -1 220 180
  option dbu
  text "Full logs",111,95 1 20 10
  box "",2,1 5 217 140
  combo 3,5 11 210 135, autohs 
  button "Delete",7,50 149 31 12
  button "Ok",10,10 165 25 10,cancel
  button "Options"11,95 165 25 10
  button "Cancel",12,185 165 25 10,cancel
  button "Clear",13,140 149 31 12
}
on 1:dialog:QueryControlLogs:init:0:{ 
  set %x 1
  set %y 1
  while ($ini(QueryControl.ini,All,%x)) {
    if ($readini(QueryControl.ini,All,%x) != $null) { did -i QueryControlLogs 3 %y $readini(QueryControl.ini,All,%x) }
    inc %x
  }
}
on *:dialog:QueryControlLogs:sclick:*:{
  if ($did == 7) {
    if ($did(3) == $null) { set %AMSGError No message specified to delete from the logs. | ShowError | return }
    if ($InList(All,$did(3)) == no) { set %AMSGError That message does not appear to be in the log list. | ShowError | return }
    RemoveFromList All $did(3)
    did -r QueryControlLogs 3
    dialog -x QueryControlLogs
    dialog -m QueryControlLogs QueryControlLogs
  }
  if ($did == 11) { dialog -x QueryControlLogs | QueryControl }
  if ($did == 13) { .remove QueryControl.ini | dialog -x QueryControlLogs | dialog -m QueryControlLogs QueryControlLogs }
}
alias QueryControl dialog -m QueryControlOptions2 QueryControlOptions2
