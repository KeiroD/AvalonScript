;Shows a link to the script when you right click a status, query or channel window
menu status,query,channel {
  AvalonScript Nick System:/showacji
}

;Calls the dialog window initialisation and loads the first server
alias showacji dialog -m acji acji

;Initialises the dialog window
dialog acji {
  title "Auto Connect/Join/Identify v3"
  size -1 -1 355 425

  ; type | text                                | id |  x   y   w   h  | style

  text     "Change settings for:",                1,   5   8  100  20
  combo                                           2,  110  5  240  20,  drop

  text     "Servers address",                     3,   15  30 160  12
  edit     "",                                    4,   15  45 132  20,  autohs
  text     "Server network",                      5,  153  30 160  12
  edit     "",                                    6,  153  45 132  20,  autohs
  check    "Enabled",                            29,  290  40  55  20

  text     "Add nickname",                        7,   22  85  70  20
  edit     "",                                    8,   20  99  72  21,  autohs
  text     "Group password",                      9,   99  85  78  20
  edit     "",                                   10,   99  99  76  21,  autohs pass 
  button   "Add nickname",                       11,   20 125 155  25
  text     "View/delete existing nicknames",     12,  182  85 150  20
  combo                                          13,  180  99 155  20,  drop
  button   "Delete nickname",                    14,  180 125 155  25

  text     "Add channel to this server",         15,   22 180 140  20
  edit     "",                                   16,   20 194 155  21,  autohs
  button   "Add channel",                        17,   20 220 155  25
  text     "View/delete existing channels",      18,  182 180 150  20
  combo                                          19,  180 194 155  20,  drop
  button   "Delete channel",                     20,  180 220 155  25

  button   "Add/Save server",                    21,   20 275 100  25
  button   "Delete server",                      22,  125 275 100  25
  button   "Close manager",                      23,  230 275 100  25,  cancel

  box      "",                                   24,   5   22 345 245
  box      "Grouped nicknames",                  25,   15  70 325  90
  box      "Channels",                           26,   15 165 325  90
  box      "Hover over buttons/boxes for help.", 27,   5  305 345 110
  text     "",                                   28,   10 318 325  92,  multi
  ; type | text                                | id |  x   y   w   h  | style
}

;On initialisation, display default help text and load first tab
on 1:dialog:acji:init:*: acji.loadgui $iif($gettok($rs(0, Order), 1, 46) != $null, $ifmatch, 1)

;loads the gui with the information for the requested server (called with $1 being server number in acjiSettings.ini)
alias -l acji.loadgui {
  acji.resetgui 

  set %n 1
  while (%n <= $rs(0,Servers)) {
    did -a acji 2 $+(%n, :) $rs($gettok($rs(0, Order), %n, 46), Server)
    inc %n
  }
  did -a acji 2 Add a new server
  did -c acji 2 $iif($findtok($rs(0, Order), $1, 46) != $null, $ifmatch, $did(2).lines)


  ;If no servers are set up, or if "Add a new server" is selected, disable some entry fields and rename buttons.
  if $did(2).sel == $did(2).lines {
    did -b acji 8,10,11,13,14,16,17,19,20,22,29 
    did -ra acji 21 Add Server
  }
  ;Enable them otherwise
  else {
    did -e acji 8,10,11,13,14,16,17,19,20,22,29
    did -ra acji 21 Save Server
  }


  did -a acji 4 $rs($1, Server)
  did -a acji 6 $rs($1, Network)
  did $iif($rs($1, Enabled) == 1, -c, -u) acji 29

  set %n 1
  while (%n <= $rs($1,Nicks)) {
    did -a acji 13 $rs($1, Nick $+ %n)
    inc %n
  }
  did -a acji 10 $rs($1, Password)

  set %n 1
  while (%n <= $rs($1,Channels)) {
    did -a acji 19 $rs($1, Channel $+ %n)
    inc %n
  }

  unset %n
}

alias -l acji.resetgui {
  did -r acji 2,4,6,8,10,13,16,19
  did -u acji 29
}

;Listens for clicks on the gui
on 1:dialog:acji:sclick:*: {
  if ($did(2).sel != $did(2).lines) {
    set %sID $gettok($rs(0, Order), $did(2).sel, 46)
  } 
  else set %sID $did(2).lines

  ;If combo box changed, update gui with details of the correct server
  if ($did == 2) {
    acji.loadgui %sID
  }

  ;If the save button is clicked, save all information into the acjiSettings.ini file
  if ($did == 21) {
    ;If the last line of combo box is selected, add a new server
    if ($did(2).sel == $did(2).lines) {
      set %servers $calc($rs(0,Servers) + 1)
      $wsdata(0, Servers, %servers)

      ;Determine next free token, then save the settings into the correct server position
      set %n 1
      while (%n <= %servers) {
        if (!$istok($rs(0,Order,46), %n, 46)) {
          $wsdata(0, Order, $addtok($rs(0,Order,46), %n, 46)))
        }
        inc %n
      }
      unset %n
      $ws(%sID, Server, 4)
      $ws(%sID, Network, 6)
    }

    if ($did(10).text != $null) { $ws(%sID, Password, 10) }
    else { $rms(%sID, Password) }
    $wsdata(%sID, Enabled, $did(29).state)
    acji.loadgui %sID
  }

  ;If the add nick button is pressed, add a nick to the current server (and save password if entered)
  if ($did == 11) {
    if ($did($dname, 8).text != $null) { 
      $wsdata(%sID, Nicks, $calc($rs(%sID, Nicks) + 1))
      $ws(%sID, Nick $+ $rs(%sID, Nicks), 8)
      did -r acji 8
      if ($did(10).text != $null) { $ws(%sID, Password, 10) }
      else { $rms(%sID, Password) }
      acji.loadgui %sID
    }
  }

  ;If the add channel button is pressed, add a channel to the current server
  if ($did == 17) {
    if ($did($dname, 16).text != $null) { 
      $wsdata(%sID, Channels, $calc($rs(%sID, Channels) + 1))
      $ws(%sID, Channel $+ $rs(%sID, Channels), 16)
      did -r acji 16
      acji.loadgui %sID
    }
  }

  ;If the delete nickname button is pressed, delete the current nickname and move all those after it up a spot
  if ($did == 14) {
    if ($did(13).sel != $null) {
      set %nicks $rs(%sID, Nicks)
      set %n $did(13).sel
      $rms(%sID, Nick $+ %n)
      dec %nicks
      set %s %n
      while (%n <= %nicks) {
        inc %s
        $wsdata(%sID, Nick $+ %n, $rs(%sID, Nick $+ %s))
        inc %n
      }
      $rms(%sID, Nick $+ %n)
      $wsdata(%sID, Nicks, %nicks)
      unset %s | unset %n | unset %nicks
    }
    acji.loadgui %sID
  }

  ;If the delete channel button is pressed, delete the current channel and move all those after it up a spot
  if ($did == 20) {
    if ($did(19).sel != $null) {
      set %channels $rs(%sID, Channels)
      set %n $did(19).sel
      $rms(%sID, Channel $+ %n)
      dec %channels
      set %s %n
      while (%n <= %channels) {
        inc %s
        $wsdata(%sID, Channel $+ %n, $rs(%sID, Channel $+ %s))
        inc %n
      }
      $rms(%sID, Channel $+ %n)
      $wsdata(%sID, Channels, %channels)
      unset %s | unset %n | unset %channels

    }
    acji.loadgui %sID
  }

  ;If the delete server button is pressed, delete the current server's token from the "Order" field
  if ($did == 22) {
    ;Remove the entire section
    $rms(%sID,)
    ;Remove the servers token from the Order field
    $iif($deltok($rs(0, Order), $did(2).sel, 46) != $null, $wsdata(0, Order, $ifmatch), $rms(0,Order))
    $wsdata(0, Servers, $calc($rs(0, Servers) - 1))
    acji.loadgui $gettok($rs(0, Order), 1, 46)
  }
  unset %sID
}

;When mIRC starts, connect to each of the servers in the Settings.ini file with the primary nick supplied, if there is one.
on *:Start: {
  set %n 1
  while (%n <= $rs(0, Servers)) {
    if ($rs($gettok($rs(0, Order),%n,46), Enabled) == 1) {
      server $iif(%n == 1,,-m) $rs($gettok($rs(0, Order),%n,46), Server) -i $rs(%n, Nick1),)
      inc %n
    }
    else inc %n
  }
  unset %n
}

;When you connect to a server, check that it's one in the Settings.ini file and then connect to the supplied channels
on *:Connect: {
  set %n 1
  while (%n <= $rs(0, Servers)) {
    if ($rs(%n, Network) == $network) { 
      set %c 1
      while (%c <= $rs(%n, Channels)) {
        join $rs(%n, Channel $+ %c)
        inc %c
      }
      unset %c
      if ($rs(%n, Password) != $null) nickserv identify $rs(%n, Password)
    }
    inc %n
  }
  unset %n
}

;When nickserv asks to identify, do so with the supplied password from the acjiSettings.ini file
on *:notice:*nickname is registered and protected*:?: {
  if ($nick == nickserv) { 
    set %n 1
    while (%n <= $rs(0, Servers)) {
      if ($rs(%n, Network) == $network) {
        nickserv identify $rs(%n, Password)
      }
      inc %n
    }
    unset %n
  }
}

;If the nickname is currently being used, attempt to connect with the first free nickname saved for the server
;-- $2 is the current nickname, find it in tokens and try the next one.
raw 433:*:{
  set %n 1
  while (%n <= $rs(0, Servers)) {
    if ($rs(%n, Server) == $server) {
      set %c 1
      while (%c <= $rs(%n, Nicks)) {
        $iif($rs(%n, Nick $+ %c) != $2, nick $ifmatch,)
        inc %c
      }
    }
    inc %n
  }
  unset %c
  unset %n
}

;When hovering over any of the edit boxes or buttons, the help label will display help information for that element
on 1:dialog:acji:mouse:*: {
  if     ($did == 2)  { did -ra $dname 28 Select the server you wish to change details for. If empty, proceed to add a server by filling out the form below. }
  elseif ($did == 4)  { did -ra $dname 28 Enter the server address here. e.g. irc.darkmyst.org If you wish to connect to a server with a non-default port, simply add a colon and a port number after the server. e.g. irc.darkmyst.org:6667 }
  elseif ($did == 6)  { did -ra $dname 28 Enter the servers network here. $crlf $+ Find this out by typing '//echo -a $+($,network') whilst connected the the server. e.g. DarkMyst }
  elseif ($did == 8)  || ($did == 11) { did -ra $dname 28 Enter a nickname and then click the Add button to add that nickname to this servers autoidentify list. }
  elseif ($did == 10) { did -ra $dname 28 Enter the password to the group of nicknames set for this server. You will automatically identify when nickserv asks for the password. }
  elseif ($did == 13) || ($did == 14) { did -ra $dname 28 Use the dropdown menu to view the nicknames set to automatically attempt to connect with. If you wish to delete one, pick it from the list then click the Delete button. }
  elseif ($did == 16) || ($did == 17) { did -ra $dname 28 Enter a channel name and then click the Add button to add that channel to this servers autojoin list. If the channel has a password, enter it after the channel. $crlf e.g. #channel password }
  elseif ($did == 19) || ($did == 20) { did -ra $dname 28 Use the dropdown menu to view the channels set to automatically join when this server starts. If you wish to delete one, pick it from the list then click the Delete button. }
  elseif ($did == 21) { did -ra $dname 28 By clicking this button all the info in the edit boxes will be saved for this server. }
  elseif ($did == 22) { did -ra $dname 28 By clicking this button all changes will be lost. Be sure to click the Set button if you want to save this configuration. }
}

;called by $rs(server number, item) - if server number is 0, then general settings are stored.
alias -l rs return $readini(acjiSettings.ini, Server $+ $1, $2)

;called by $wsdata(server number, data name, data)
alias -l wsdata writeini acjiSettings.ini Server $+ $1 $2 $3

;called by $ws(server number, data name, dialog item id to read from)
alias -l ws writeini acjiSettings.ini Server $+ $1 $2 $did($3).text

;called by $rms(server number, item)
alias -l rms remini acjiSettings.ini Server $+ $1 $2
}
