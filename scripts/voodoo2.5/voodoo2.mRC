;;;;;;;;;;;;;;;;;;;Voodoo² for mIRC 7+;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                     ;;
;; Release 2.5 2013-02-19                              ;;
;;                                                     ;;
;; This script requires colorcombo.dll to be present   ;;
;; in the same directory as the script.                ;;
;;                                                     ;;
;; See README for details                              ;;
;;                                                     ;;
;; Special thanks to Nymphetamine for cracking the     ;;
;; whip, composing the in-script help and writing the  ;;
;; README.                                             ;;
;;                                                     ;;
;; http://www.voodoo-script.com                        ;;
;;                                                     ;; 
;;;;;;;;;;;;;;;;;;;;By: Freakuancy;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Follows is sexy code:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            ;;
;;  Dialog Tables and Events  ;;
;;                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


dialog dlgCharacter {
  ;; Add/Edit Character Dialog Table
  title "Grimoire - Add/Edit Character"
  size -1 -1 234 238
  option dbu
  button "&Save", 3, 152 223 37 12, default ok
  button "+", 4, 45 212 12 8
  button "--", 5, 61 212 12 8
  tab "Formatting", 7, 76 2 154 217
  box "Triggers:", 15, 80 127 145 50, tab 7
  box "Commands:", 23, 80 179 145 37, tab 7
  box "PNick:", 13, 80 100 145 26, tab 7
  box "Cut Options:", 28, 80 49 145 50, tab 7
  check "Auto-Cut Posts", 29, 91 58 50 10, tab 7
  edit "--", 30, 185 71 18 10, tab 7 autohs center
  edit "--", 34, 123 84 18 10, tab 7 autohs center
  edit "", 36, 185 84 18 10, tab 7 autohs center
  edit "--", 32, 123 71 18 10, tab 7 autohs center
  edit "<Nickname>", 16, 146 111 58 10, tab 7 autohs
  check "Use Pnick:", 14, 103 111 34 10, tab 7
  text "Cont.:", 35, 103 85 17 8, tab 7
  text "Next:", 31, 167 72 17 8, tab 7
  text "Begin:", 33, 101 72 17 8, tab 7
  text "End:", 37, 167 85 13 8, tab 7
  text "Dialog:", 17, 103 139 17 8, tab 7
  text "Telepathy:", 18, 103 151 33 8, tab 7
  text "Foreign Language:", 19, 103 163 49 8, tab 7
  edit *, 21, 194 163 10 10, tab 7 center
  edit ~, 20, 194 150 10 10, tab 7 limit 1 center
  edit , 22, 194 138 10 10, tab 7 limit 1 center
  text "OOC Left Bracket:", 24, 104 190 49 8, tab 7
  text "OOC Right Bracket:", 25, 104 202 49 8, tab 7
  edit " ))", 27, 179 200 26 10, tab 7 autohs center
  edit "(( ", 26, 179 188 26 10, tab 7 autohs center
  text "Formatting options for this character. Turn auto-cuts on or off, change the cut brackets or set different triggers for your dialog.", 85, 98 20 105 27, tab 7 center
  tab "Colors", 8
  combo 1, 116 69 20 9, tab 8 size drop
  box "General Colors", 41, 80 59 145 50, tab 8
  text "Default:", 42, 94 69 21 8, tab 8
  text "Action:", 43, 94 82 17 8, tab 8
  combo 39, 116 82 20 9, tab 8 size drop
  combo 40, 116 95 20 9, tab 8 size drop
  text "Dialog:", 44, 94 96 17 8, tab 8
  combo 48, 190 82 20 9, tab 8 size drop
  combo 47, 190 69 20 9, tab 8 size drop
  text "Telepathy:", 46, 164 70 28 8, tab 8
  text "Foreign:", 45, 164 84 25 8, tab 8
  box "Cut Colors:", 49, 80 112 145 37, tab 8
  combo 54, 190 135 20 9, tab 8 size drop
  combo 57, 116 122 20 9, tab 8 size drop
  combo 50, 190 122 20 9, tab 8 size drop
  combo 52, 116 135 20 9, tab 8 size drop
  text "Cont:", 53, 94 135 17 8, tab 8
  text "Next:", 51, 168 122 21 8, tab 8
  text "Begin:", 56, 92 123 17 8, tab 8
  text "End:", 55, 170 137 17 8, tab 8
  check "Auto-Color Posts", 60, 81 48 50 10, tab 8
  combo 59, 190 95 20 9, tab 8 size drop
  text "OOC:", 58, 164 96 25 8, tab 8
  text "Color options for this character. Turn auto-color on or off, or change the color scheme entirely.", 86, 103 21 97 24, tab 8 center
  tab "Notifications", 11
  box "Channels:", 61, 79 57 145 53, tab 11
  check "Enable", 67, 83 67 30 10, tab 11
  text "Delay in Seconds:", 68, 155 68 45 8, tab 11
  check "Inactive Channels Only", 70, 88 81 68 10, tab 11
  check "Except When mIRC is", 71, 88 91 92 10, tab 11
  text "Behind Other Windows", 72, 98 100 57 8, tab 11
  box "Queries:", 73, 79 112 145 53, tab 11
  text "Delay in Seconds:", 74, 155 122 45 8, tab 11
  edit 60, 75, 201 121 18 10, tab 11 limit 1 center
  check "Inactive Queries Only", 76, 88 135 68 10, tab 11
  check "Enable", 77, 83 121 30 10, tab 11
  check "Except When mIRC is", 78, 88 145 92 10, tab 11
  edit 60, 69, 201 67 18 10, tab 11 limit 1 center
  text "Behind Other Windows", 79, 98 154 57 8, tab 11
  text "Notifications alert you whenever somebody posts in your RP channels or queries. You can set how long you want the notification to remain on-screen with the Delay option, with appropriate ranges being between 1 - 60 seconds", 80, 91 20 121 35, tab 11 center
  check "Alert Beep", 81, 175 81 42 10, tab 11
  check "Alert Beep", 82, 174 135 42 10, tab 11
  tab "Details", 84
  edit "Full Name", 63, 149 49 76 10, tab 84 autohs
  edit "Info", 64, 149 63 76 82, tab 84 multi return autovs vsbar
  edit "Description", 65, 80 149 145 68, tab 84 multi return autovs vsbar
  icon 62, 80 49 63 87, $mircexe, 0, tab 84
  button "Set", 66, 131 125 13 12, tab 84
  link "Open Notes", 83, 81 139 30 8, tab 84
  text "Optional details about this character. You can send this information to a query or channel with a single click or command.", 12, 95 20 113 22, tab 84 center
  text "Select a character below and edit their respective properties to the right. The Standard profile acts as an editable template for your new characters.", 38, 7 7 65 40
  list 6, 4 49 69 160, size vsbar
  button "&Okay", 9, 193 223 37 12, default ok
  button "&Cancel", 2, 111 223 37 12, default cancel
  button "~", 10, 5 212 12 8
}

dialog dlgOptions {
  ;; Script Options Dialog Table
  title "Voodoo² Options"
  size -1 -1 83 138
  option dbu
  button "&Okay", 1, 47 122 32 12, ok
  button "&Cancel", 2, 11 122 32 12, cancel
  box "Cut Length:", 4, 4 59 76 59
  edit "430", 17, 11 104 21 10, result %txtBufLen
  edit "400", 18, 53 104 21 10, result %txtCutLen
  text "Cut Length:", 19, 47 95 29 8
  text "Buffer Size:", 16, 7 95 29 8
  text "Do not change unless you are sure of what you are doing!", 15, 8 67 66 21
  box "Default Channel Profile:", 3, 4 4 76 26
  combo 5, 8 13 66 14, vsbar drop
  box "Default Query Profile:", 6, 4 31 76 26
  combo 7, 8 40 66 14, vsbar drop
}

dialog dlgScratch {
  ;; Scratchpad/Note Dialog Table
  title "Scratchpad"
  size -1 -1 154 139
  option dbu
  edit "", 1, 0 0 154 138, multi return autovs vsbar
}

on 1:dialog:dlgCharacter:init:0: {
  ;; INIT event handler for Add/Edit Char
  var %fpath      = $qt($scriptdir $+ colorcombo.dll)
  var %curchan    = %uchan $+ $network
  var %curquery   = %uquery $+ $network
  ;; DLL turns combo into color select combo
  dll %fpath COMBO dlgCharacter 1
  dll %fpath COMBO dlgCharacter 47
  dll %fpath COMBO dlgCharacter 39
  dll %fpath COMBO dlgCharacter 48
  dll %fpath COMBO dlgCharacter 40
  dll %fpath COMBO dlgCharacter 59
  dll %fpath COMBO dlgCharacter 50
  dll %fpath COMBO dlgCharacter 52
  dll %fpath COMBO dlgCharacter 57
  dll %fpath COMBO dlgCharacter 54

  var %tmp       = $findfile($qt(%charpath),*.rpg,0,did -a dlgCharacter 6 $left($nopath($1-), $calc($len($nopath($1-)) - 4)))
  var %lstCount  = $did(dlgCharacter, 6).lines
  var %i         = 0

  did -c dlgCharacter 6 1
  $iif(%uquery, %curchan = %curquery)
  if ($hget(%curchan, curProfile) != None) {
    while (%i <= %lstCount) {
      $iif($did(dlgCharacter, 6, %i).text == $hget(%curchan, curProfile), did -c dlgCharacter 6 %i)
      inc %i
    }
  }
  var %tblname   = $qt(%charpath $+ $did(dlgCharacter, 6).seltext $+ .rpg)
  load_table %tblname 
}

on 1:dialog:dlgCharacter:sclick:6:{
  ;; Listbox Handler for Add/Rem Char
  if (%edited == 1) {
    var %charname = $hget(tbl_char, curProfile)
    if ($input(You have not saved. Would you like to save changes to %charname $+ ?,ywa, Save?)) {
      if (%charname) save_table %charname  
    }
  }
  var %tblname =  $qt(%charpath $+ $did(dlgCharacter, 6).seltext $+ .rpg)
  load_table %tblname
}

on 1:dialog:dlgCharacter:sclick:83: {
  ;; Open Notes Link
  run notepad.exe $qt(%charpath $+ $hget(tbl_char, curProfile) $+ .txt)
}

on 1:dialog:dlgCharacter:sclick:4:{
  ;; Add Character Sub
  if (%edited == 1) {
    var %charname = $did(dlgCharacter, 6).seltext
    if ($input(You have not saved. Would you like to save changes to %charname $+ ?,ywa, Save?)) {
      if (%charname) save_table %charname  
    }
  }
  var %newchar = $input(Please enter the name of your new character,eog,Add New Character)
  var %tblname = $qt(%charpath $+ %newchar $+ .rpg)
  if (%newchar != $null) {

    if ($isfile(%tblname)) {
      %tmp = $input(Error: A profile named %newchar already exists,o,Voodoo² - Error)
    }
    else {
      load_table $qt(%charpath $+ Standard.rpg)
      did -a dlgCharacter 6 %newchar
      save_table %newchar
      did -c dlgCharacter 6 $did(dlgCharacter, 6).lines    
    }

  }
  else {
    %tmp = $input(Error: You must enter a profile name.,o,Voodoo² - Error)
  }
  unset %edited
}

on 1:dialog:dlgCharacter:sclick:66: {
  ;; Set Character Image Sub
  %tmpFile = $sfile($scriptdir $+ *.jpg, Select Character Image, Select)
  did -g dlgCharacter 62 $qt(%tmpFile)
  hadd tbl_char imgCharImage %tmpFile
  set %edited 1
}
on 1:dialog:dlgCharacter:sclick:10:{
  ;; Copy Character Sub
  if (%edited) {
    var %charname = $did(dlgCharacter, 6).seltext
    if ($input(You have not saved. Would you like to save changes to %charname $+ ?,ywa, Save?)) {
      if (%charname) save_table %charname  
    }
  }
  var %newchar        = $input(Please enter the name of the character to copy to:,eog,Copy Character)
  var %tblname        = $qt(%charpath $+ %newchar $+ .rpg)
  if (%newchar != $null) {

    if ($isfile(%tblname)) {
      %tmp = $input(Error: A profile named %newchar already exists,o,Voodoo² - Error)
    }
    else {
      did -a dlgCharacter 6 %newchar
      save_table %newchar
      did -c dlgCharacter 6 $did(dlgCharacter, 6).lines
    }
  }
  else {
    %tmp = $input(Error: You must enter a profile name.,o,Voodoo² - Error)
  }
  unset %edited
}

on 1:dialog:dlgCharacter:edit:*: {
  ;; Edited? For Prompt to Save
  set %edited 1
}

on 1:dialog:dlgCharacter:sclick:1,47,39,48,40,59,50,52,57,54,14,16,29,60,66,67,81,82,70,71,76,78,64,65: {
  ;; Edited? For Prompt to Save
  set %edited 1
  ;; Keep user from selecting clear/no color
  $iif($did(dlgCharacter, $did).sel == 1, did -c dlgCharacter $did 2)
}

on 1:dialog:dlgCharacter:sclick:3: {
  ;; Save Button sub
  var %charname = $did(dlgCharacter, 6).seltext
  if (%charname) save_table %charname
}

on 1:dialog:dlgCharacter:sclick:9:{
  ;; Okay Button sub
  dll -u colorcombo.dll
  if (%edited) {
    var %charname = $did(dlgCharacter, 6).seltext
    if ($input(You have not saved. Would you like to save changes to %charname $+ ?,ywa, Save?)) {
      if (%charname) save_table %charname  
    }
  }    
}

on 1:dialog:dlgCharacter:close:0: {
  var %curchan = $active $+ $network
  ;; On Close, unset variables and unload DLL
  dll -u colorcombo.dll
  $iif($hget(tbl_char), hfree tbl_char)
  unset %uchan
  unset %uquery
  unset %edited

  $iif($hget(%curchan, curProfile) != None && $active != Status Window, swchar 2 %charpath $+ $hget(%curchan, curProfile) $+ .rpg)
}

on 1:dialog:dlgCharacter:sclick:5: {
  ;; Delete Profile sub 
  var %iniPath        = %charpath $+ colors\
  var %delchar        = $did(dlgCharacter, 6).seltext
  var %delindex       = $did(dlgCharacter, 6).sel

  if (%delchar == Standard) {
    %tmp = $input(Error: You cannot delete the Standard profile template,o,Voodoo² - Error)
  }
  else {
    if ($input(Are you sure you wish to delete %delchar $+ ?,ywa, Delete?)) { 
      did -d dlgCharacter 6 %delindex 
      remove $qt(%charpath $+ %delchar $+ .rpg) 
      remove $qt(%iniPath $+ %delchar $+ .clr)  
    }
  }
}

on 1:dialog:dlgOptions:init:0: {
  ;; INIT event handler for Options Dialog
  var %i          = 0
  var %selprof    = $readini($qt($scriptdir $+ chansettings.ini), Global, Default)
  var %selprofq   = $readini($qt($scriptdir $+ chansettings.ini), Global, Query_Default)
  did -a dlgOptions 5 None
  did -a dlgOptions 7 None
  var %newtmp     = $findfile($qt(%charpath),*.rpg,0,did -a dlgOptions 5 $left($nopath($1-), $calc($len($nopath($1-)) - 4)))
  var %newtmpq    = $findfile($qt(%charpath),*.rpg,0,did -a dlgOptions 7 $left($nopath($1-), $calc($len($nopath($1-)) - 4)))
  var %lstCount   = $did(dlgOptions, 5).lines
  did -o dlgOptions 17 1 %txtBufLen
  did -o dlgOptions 18 1 %txtCutLen
  did -c dlgOptions 5 1
  did -c dlgOptions 7 1
  if (%selprof) {
    while (%i <= %lstCount) {
      $iif($did(dlgOptions, 5, %i).text == %selprof, did -c dlgOptions 5 %i)
      inc %i
    }
    %i = 0
  }
  if (%selprofq) {
    while (%i <= %lstCount) {
      $iif($did(dlgOptions, 7, %i).text == %selprofq, did -c dlgOptions 7 %i)
      inc %i
    }
    %i = 0
  }
}

on 1:dialog:dlgOptions:sclick:1: {
  ;; Options Dialog Okay Button sub
  writeini $qt($scriptdir $+ chansettings.ini) Global Default $did(dlgOptions, 5)
  writeini $qt($scriptdir $+ chansettings.ini) Global Query_Default $did(dlgOptions, 7)
}

on 1:dialog:sc_*:close:0: {
  ;; Close events for scratchpad sc_curprofile
  var %i            = 2
  tokenize $asc(_) $dname
  var %sfile        = $qt(%charpath $+ $2 $+ .txt)

  $iif($did(1).lines == 0, remove %sfile)

  write -ca1 %sfile $did(1, 1).text
  while %i <= $did(1).lines {
    write -a%i %sfile $did(1, %i).text
    inc %i
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            ;;
;;  Pop-up Menus & Routines   ;;
;;                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

menu channel {
  ;; Create context menu
  -
  Voodoo²
  .Open Grimoire...:set %uchan $chan | dialog -m dlgCharacter dlgCharacter  
  .$submenu($mnuedit($1))
  .Command List: vhelp
  .-
  .Notes
  ..$submenu($notelist($1))
  .-
  .$submenu($filelist($1))
  .-
  .Script Options...:/dialog -m dlgOptions dlgOptions    
}

menu query {
  ;; Create context menu
  -
  Voodoo²
  .Open Grimoire...:set %uquery $query($active) | dialog -m dlgCharacter dlgCharacter 
  .$submenu($mnuedit($1))
  .Command List: vhelp
  .Send Character Picture:sendpic $query($active)
  .-
  .Notes
  ..$submenu($notelist($1))
  .-
  .$submenu($filelist($1))
  .-
  .Script Options...:/dialog -m dlgOptions dlgOptions
}

alias -l mnuedit {
  if ($1 == 1) {
    if ($isfile($qt($scriptdir $+ fat mouth v2.exe))) {
      RETURN Advanced Editor... :ae
    }
    else {
      RETURN $!style(2) Advanced Editor... :ae
    }
  }
}

alias -l notelist {
  ;; List Created Notes $submenu
  if ($1) { 
    var %tfNames   = $findfile($qt(%charpath),*.txt,$1)
    var %nNames    = $left($nopath(%tfNames), $calc($len($nopath(%tfNames)) - 4))

    RETURN %nNames :note %nNames
  }
}

alias -l filelist {
  ;; Switch Profiles $submenu
  var %curchan   = $chan $+ $network
  var %curquery  = $query($active) $+ $network

  $iif($query($active),%curchan = %curquery)

  if (!$hget(%curchan)) {
    hmake %curchan 10
    hadd %curchan curProfile None
    titlebar AvalonScript Voodoo²: Active Profile - $+ $chr(32) $+ $hget(%curchan, curProfile)
  }
  if (!$hget(%curChan, curProfile)) { hadd %curchan curProfile None }
  if ($1 == begin) {
    if ($hget(%curChan, curProfile) == None) {
      RETURN $!style(1) None/Disabled :swnone %curchan
    }
    else {
      RETURN None/Disabled :swnone %curchan
    }
  }
  if ($1) { 
    var %fNames   = $findfile($qt(%charpath),*.rpg,$1)
    var %CNames   = $left($nopath(%fNames), $calc($len($nopath(%fNames)) - 4))

    if (%CNames == $hget(%curchan, curProfile)) { 
      RETURN $!style(1) %CNames :swchar 1 %fNames 
    }
    else {
      RETURN %CNames :swchar 1 %fNames    
    }
  }
  if ($1 == end) { RETURN - }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            ;;
;;       Script Events        ;;
;;                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


on 1:LOAD: {
  ;;First Time Run Handler
  set %charpath $scriptdir $+ chars\
  var %iniPath  = %charpath $+ colors\ 
  echo  14Voodoo05²1: 15Performing first-time initialization...
  set %txtCutLen 370
  set %txtBufLen 400
  $iif($hget(tbl_char), hfree tbl_char)

  ;; Create Default.rpg profile
  hmake -s tbl_char 10
  hadd -s tbl_char UsePnick 0
  hadd -s tbl_char txtPnick <Nickname>
  hadd -s tbl_char UseCut 1
  hadd -s tbl_char UseColor 1
  hadd -s tbl_char useCNotification 1
  hadd -s tbl_char useCBeep 1
  hadd -s tbl_char nfyChanActive 1
  hadd -s tbl_char nfyCAppActive 1
  hadd -s tbl_char txtCDelay 60
  hadd -s tbl_char useQNotification 1
  hadd -s tbl_char useQBeep 1
  hadd -s tbl_char nfyQueryActive 1
  hadd -s tbl_char nfyQAppActive 1
  hadd -s tbl_char txtQDelay 60
  hadd -s tbl_char txtBegin --
  hadd -s tbl_char txtContinue --
  hadd -s tbl_char txtDone 
  hadd -s tbl_char txtNext --
  hadd -s tbl_char txtDialog $chr(34)
  hadd -s tbl_char txtTelepathy ~
  hadd -s tbl_char txtForeign *
  hadd -s tbl_char txtOOCLeft ((
  hadd -s tbl_char txtOOCRight ))
  hadd -s tbl_char txtFullName Full Name
  hadd -s tbl_char txtInfo Info
  hadd -s tbl_char txtDescription Description
  hadd -s tbl_char imgCharImage $scriptdir $+ empty_profile.jpg
  hadd -s tbl_char colDefault 6
  hadd -s tbl_char colAction 6
  hadd -s tbl_char colDialog 1
  hadd -s tbl_char colTelepathy 14
  hadd -s tbl_char colForeign 2
  hadd -s tbl_char colOOC 1
  hadd -s tbl_char colNext 6
  hadd -s tbl_char colBegin 6
  hadd -s tbl_char colContinue 6
  hadd -s tbl_char colDone 6
  hadd -s tbl_char curProfile Standard
  $iif(!$isdir($qt(%charpath)), mkdir $qt(%charpath))
  $iif(!$isdir($qt(%iniPath)), mkdir $qt(%iniPath))
  hsave -sbo tbl_char $qt(%charpath $+ Standard.rpg)
  hfree tbl_char

  ;; Reset chansettings cache if exists
  $iif($isfile($qt($scriptdir $+ chansettings.ini)), remove $qt($scriptdir $+ chansettings.ini))
  writeini $qt($scriptdir $+ chansettings.ini) Global Default None
  writeini $qt($scriptdir $+ chansettings.ini) Global Query_Default None
  dialog -m dlgCharacter dlgCharacter
}

on 1:START: {
  ;; Set Global Variables
  set %charpath $scriptdir $+ chars\
  echo  14Voodoo05²1: 15Loaded.
}

on *:TEXT:*:*: {
  ;; New Post Notication on TEXT
  var %curchan       = $chan $+ $network
  var %curquery      = $query($active) $+ $network
  var %hwndCur       = $chan
  var %useNotice     = $hget(%curchan, useCNotification)
  var %nfyActive     = $hget(%curchan, nfyChanActive)
  var %nfyAppActive  = $hget(%curchan, nfyCAppActive)
  var %useBeep       = $hget(%curchan, useCBeep)
  var %cMsg          = $nick has posted in $+ $chr(32) $+ $chan $+ .

  if ($chan) || ($query($active)) {
    ;; IF channel or query else do nothing
    if ($query($active)) {
      ;; Switch Variables if Query
      %curchan       = %curquery
      %hwndCur       = $query($active) 
      %useNotice     = $hget(%curchan, useQNotification)
      %nfyActive     = $hget(%curchan, nfyQueryActive)
      %nfyAppActive  = $hget(%curchan, nfyQAppActive)
      %useBeep       = $hget(%curchan, useQBeep)
      %cMSG          = $nick has posted.  
    }

    if ($hget(%curchan, curProfile) != None) {
      ;; IF Profile is active
      if (%useNotice == 1) {
        if (%nfyActive == 1 && %hwndCur != $active) {
          $iif(!$tip(%hwndCur), %tmp = $tip(%hwndCur,New Post!,%cMsg,60))
          $iif(%useBeep == 1,beep 2)
          halt
        }
        if (%nfyAppActive == 1 && !$appactive) {
          $iif(!$tip(%hwndCur), %tmp = $tip(%hwndCur,New Post!,%cMsg,60))
          $iif(%useBeep == 1,beep 2)
          halt
        }
        if ($active != %hwndCur) {
          $iif(!$tip(%hwndCur), %tmp = $tip(%hwndCur,New Post!,%cMsg,60))
          $iif(%useBeep == 1,beep 2)
        }
      }
    }
  }
}

on *:ACTION:*:*: {

  var %curchan       = $chan $+ $network
  var %curquery      = $query($active) $+ $network
  var %hwndCur       = $chan
  var %useNotice     = $hget(%curchan, useCNotification)
  var %nfyActive     = $hget(%curchan, nfyChanActive)
  var %nfyAppActive  = $hget(%curchan, nfyCAppActive)
  var %useBeep       = $hget(%curchan, useCBeep)
  var %cMsg          = $nick has posted in $+ $chr(32) $+ $chan $+ .

  if ($chan) || ($query($active)) {

    if ($query($active)) {
      ;; Switch Variables if Query
      %curchan       = %curquery
      %hwndCur       = $query($active) 
      %useNotice     = $hget(%curchan, useQNotification)
      %nfyActive     = $hget(%curchan, nfyQueryActive)
      %nfyAppActive  = $hget(%curchan, nfyQAppActive)
      %useBeep       = $hget(%curchan, useQBeep)
      %cMSG          = $nick has posted.  
    }

    if ($hget(%curchan, curProfile) != None) {
      if (%useNotice == 1) {
        if (%nfyActive == 1 && %hwndCur != $active) {

          $iif(!$tip(%hwndCur), %tmp = $tip(%hwndCur,New Post!,%cMsg,60))
          $iif(%useBeep == 1,beep 2)
          halt
        }
        if (%nfyAppActive == 1 && !$appactive) {

          $iif(!$tip(%hwndCur), %tmp = $tip(%hwndCur,New Post!,%cMsg,60))
          $iif(%useBeep == 1,beep 2)
          halt
        }
        if ($active != %hwndCur) {
          $iif(!$tip(%hwndCur), %tmp = $tip(%hwndCur,New Post!,%cMsg,60))
          $iif(%useBeep == 1,beep 2)
        }
      }
    }
  }
}

on *:INPUT:*: {
  ;; Handles INPUT to be passed to $saytext for cut and color
  var %curchan      = $chan $+ $network
  var %curquery     = $query($active) $+ $network

  if ($chan) || ($query($active)) {
    $iif($query($active), %curchan = %curquery)

    if (!$hget(%curchan)) {
      ;; Intentional redundancy, makes sure hash is proper
      hmake %curchan 10
      hadd %curchan curProfile None
      titlebar AvalonScript Voodoo²: Active Profile - $+ $chr(32) $+ $hget(%curchan, curProfile)
    }
    if ($hget(%curchan, curProfile) != None) {
      ;; Checks last access time on profile and refreshes if necessary
      var %curprofile   = $hget(%curchan, curProfile)
      var %tblname      = $qt(%charpath $+ %curprofile $+ .rpg)
      if ($hget(%curchan, dateMod) != $file(%tblname).mtime) {
        swchar 2 %tblname
      }
      if ( ( $left($1,1) != / && $left($1,1) != ! && $left($1,1) != ` ) || ( $1 == /me ) ) {
        ;; IF not a slash or ! command besides /me 
        if ($pos($1-, $chr(92)) && $len($1-) > 370) {
          ;; Process paragraph breaks. Single-line solution elegance
          tokenize 92 $1- | saytext $* | halt
        }
        else {
          saytext $1-
          halt
        }
      }
    }
  }
}

on *:ACTIVE:*: {
  ;; Handles channel and query hash creation and titlebar updates
  var %curquery    = $query($active) $+ $network
  var %dSetting    = Query_Default

  if ($chan) || ($query($active)) {
    if ($chan) {
      %curquery = $chan $+ $network
      %dSetting = Default
    }
    var %pProfile    = $readini($qt($scriptdir $+ chansettings.ini), %curquery, profile)
    if (!$hget(%curquery)) {

      hmake %curquery 10
      if (%pProfile) {
        var %tblname      = $qt(%charpath $+ %pProfile $+ .rpg)
        hload -b %curquery %tblname
        hadd %curquery dateMod $file(%tblname).mtime
        hadd %curquery curProfile %pProfile
      }
      else {
        var %uProfile    = $readini($qt($scriptdir $+ chansettings.ini), Global, %dSetting)
        var %tblname      = $qt(%charpath $+ %uProfile $+ .rpg)
        if (%uProfile == None) {
          hadd %curquery curProfile None
        }
        else {
          hload -b %curquery %tblname
          hadd %curquery curProfile %uProfile
          hadd %curquery dateMod $file(%tblname).mtime
        }
      }
    }
    $iif($hget(%curchan), titlebar AvalonScriptVoodoo²: Active Profile - $+ $chr(32) $+ $hget(%curchan, curProfile),  titlebar AvalonScript Voodoo²: Active Profile - None)
    $iif($hget(%curquery), titlebar AvalonScript Voodoo²: Active Profile - $+ $chr(32) $+ $hget(%curquery, curProfile),  titlebar AvalonScript Voodoo²: Active Profile - None)
  }
}  

CTCP *:Version:*:{
  ;; Add script name to mIRC version reply
  ctcpreply $nick VERSION 03 $+ $me $+ 02 is using 02AvalonScript %version for mIRC 7+
}

on *:CLOSE:*: {
  ;; Close channels and queries cleanly
  var %curchan      = $chan $+ $network
  var %curchan      = $right($chan, $calc($len($chan) - 1))

  $iif($hget(%curquery), hfree %curquery)
  $iif($hget(%curchan), hfree %curchan)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            ;;
;;     Script Subroutines     ;;
;;                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


alias -l load_table {
  ;; Load Profile Values into dlgCharacter 
  $iif($hget(tbl_char), hfree tbl_char)
  hmake tbl_char 10
  hload -b tbl_char $1-

  ;; COMBO Color Boxes
  var %colDefault     = $hget(tbl_char, colDefault)
  var %colAction      = $hget(tbl_char, colAction)
  var %colDialog      = $hget(tbl_char, colDialog)
  var %colTelepathy   = $hget(tbl_char, colTelepathy)
  var %colForeign     = $hget(tbl_char, colForeign)
  var %colOOC         = $hget(tbl_char, colOOC)
  var %colNext        = $hget(tbl_char, colNext)
  var %colBegin        = $hget(tbl_char, colBegin)
  var %colContinue    = $hget(tbl_char, colContinue)
  var %colDone        = $hget(tbl_char, colDone)

  did -c dlgCharacter 1  $calc(%colDefault + 2)
  did -c dlgCharacter 47 $calc(%colTelepathy + 2)
  did -c dlgCharacter 39 $calc(%colAction + 2)
  did -c dlgCharacter 48 $calc(%colForeign + 2)
  did -c dlgCharacter 40 $calc(%colDialog + 2)
  did -c dlgCharacter 59 $calc(%colOOC + 2)
  did -c dlgCharacter 50 $calc(%colNext + 2)
  did -c dlgCharacter 52 $calc(%colContinue + 2)
  did -c dlgCharacter 57 $calc(%colBegin + 2)
  did -c dlgCharacter 54 $calc(%colDone + 2)

  ;; EDIT boxes
  did -o dlgCharacter 16 1 $hget(tbl_char, txtPnick)
  did -o dlgCharacter 20 1 $hget(tbl_char, txtTelepathy)
  did -o dlgCharacter 21 1 $hget(tbl_char, txtForeign)
  did -o dlgCharacter 22 1 $hget(tbl_char, txtDialog)
  did -o dlgCharacter 26 1 $hget(tbl_char, txtOOCLeft)
  did -o dlgCharacter 27 1 $hget(tbl_char, txtOOCRight)
  did -o dlgCharacter 30 1 $hget(tbl_char, txtNext)
  did -o dlgCharacter 32 1 $hget(tbl_char, txtBegin)
  did -o dlgCharacter 34 1 $hget(tbl_char, txtContinue)
  did -o dlgCharacter 36 1 $hget(tbl_char, txtDone)
  did -o dlgCharacter 69 1 $hget(tbl_char, txtCDelay)
  did -o dlgCharacter 75 1 $hget(tbl_char, txtQDelay)
  did -r dlgCharacter 63,64,65
  did -a dlgCharacter 63 $hget(tbl_char, txtFullName)
  did -a dlgCharacter 64 $hget(tbl_char, txtInfo)
  did -a dlgCharacter 65 $hget(tbl_char, txtDescription)

  ;; CHECK Boxes
  $iif($hget(tbl_char, UsePNick) == 1, /did -c dlgCharacter 14, /did -u dlgCharacter 14)
  $iif($hget(tbl_char, UseCut) == 1, /did -c dlgCharacter 29, /did -u dlgCharacter 29)
  $iif($hget(tbl_char, UseColor) == 1, /did -c dlgCharacter 60, /did -u dlgCharacter 60)
  $iif($hget(tbl_char, useCNotification) == 1, /did -c dlgCharacter 67, /did -u dlgCharacter 67)
  $iif($hget(tbl_char, useQNotification) == 1, /did -c dlgCharacter 77, /did -u dlgCharacter 77)
  $iif($hget(tbl_char, useCBeep) == 1, /did -c dlgCharacter 81, /did -u dlgCharacter 81)
  $iif($hget(tbl_char, useQBeep) == 1, /did -c dlgCharacter 82, /did -u dlgCharacter 82)
  $iif($hget(tbl_char, nfyChanActive) == 1, /did -c dlgCharacter 70, /did -u dlgCharacter 70)
  $iif($hget(tbl_char, nfyQueryActive) == 1, /did -c dlgCharacter 76, /did -u dlgCharacter 76)
  $iif($hget(tbl_char, nfyCAppActive) == 1, /did -c dlgCharacter 71, /did -u dlgCharacter 71)
  $iif($hget(tbl_char, nfyQAppActive) == 1, /did -c dlgCharacter 78, /did -u dlgCharacter 78)
  $iif($hget(tbl_char, imgCharImage), did -g dlgCharacter 62 $qt($hget(tbl_char, imgCharImage)))
  unset %edited
}

alias -l save_table {
  ;; Save Dialog Values to Profile
  $iif($hget(tbl_char), hfree tbl_char)
  hmake tbl_char 10 

  var %iniPath        = %charpath $+ colors\  
  var %iniFile        = $qt(%iniPath $+ $1- $+ .clr)
  var %colDefault     = $did(dlgCharacter, 1).sel
  var %colAction      = $did(dlgCharacter, 39).sel
  var %colDialog      = $did(dlgCharacter, 40).sel
  var %colTelepathy   = $did(dlgCharacter, 47).sel
  var %colForeign     = $did(dlgCharacter, 48).sel
  var %colOOC         = $did(dlgCharacter, 59).sel
  var %colNext        = $did(dlgCharacter, 50).sel
  var %colBegin       = $did(dlgCharacter, 57).sel
  var %colContinue    = $did(dlgCharacter, 52).sel
  var %colDone        = $did(dlgCharacter, 54).sel 
  var %bufInfo        = $null
  var %bufDesc        = $null
  var %i              = 1
  var %n              = 1

  $iif(!$isdir($qt(%charpath)), mkdir $qt(%charpath))
  $iif(!$isdir($qt(%iniPath)), mkdir $qt(%iniPath))
  hadd tbl_char curProfile $1-
  hadd tbl_char UsePnick $did(dlgCharacter, 14).state
  hadd tbl_char txtPnick $did(dlgCharacter, 16).text
  hadd tbl_char UseCut $did(dlgCharacter, 29).state
  hadd tbl_char UseColor $did(dlgCharacter, 60).state
  hadd tbl_char useCNotification $did(dlgCharacter, 67).state
  hadd tbl_char useQNotification $did(dlgCharacter, 77).state
  hadd tbl_char useCBeep $did(dlgCharacter, 81).state
  hadd tbl_char useQBeep $did(dlgCharacter, 82).state 
  hadd tbl_char nfyChanActive $did(dlgCharacter, 70).state
  hadd tbl_char nfyQueryActive $did(dlgCharacter, 76).state
  hadd tbl_char nfyCAppActive $did(dlgCharacter, 71).state
  hadd tbl_char nfyQAppActive $did(dlgCharacter, 78).state
  hadd tbl_char txtBegin $did(dlgCharacter, 32).text
  hadd tbl_char txtContinue $did(dlgCharacter, 34).text
  hadd tbl_char txtDone $did(dlgCharacter, 36).text
  hadd tbl_char txtNext $did(dlgCharacter, 30).text
  hadd tbl_char txtDialog $did(dlgCharacter, 22).text
  hadd tbl_char txtTelepathy $did(dlgCharacter, 20).text
  hadd tbl_char txtForeign $did(dlgCharacter, 21).text
  hadd tbl_char txtOOCLeft $did(dlgCharacter, 26).text
  hadd tbl_char txtOOCRight $did(dlgCharacter, 27).text
  hadd tbl_char txtCDelay $did(dlgCharacter, 69).text
  hadd tbl_char txtQDelay $did(dlgCharacter, 75).text

  %bufInfo = $didtok(dlgCharacter, 64, 10)
  %bufDesc = $didtok(dlgCharacter, 65, 10)

  hadd tbl_char txtFullName $did(dlgCharacter, 63).text
  hadd tbl_char txtInfo %bufInfo
  hadd tbl_char txtDescription %bufDesc
  hadd tbl_char imgCharImage $did(dlgCharacter, 62)
  hadd tbl_char colDefault $calc(%colDefault - 2)
  hadd tbl_char colAction $calc(%colAction - 2)
  hadd tbl_char colDialog $calc(%colDialog - 2)
  hadd tbl_char colTelepathy $calc(%colTelepathy - 2)
  hadd tbl_char colForeign $calc(%colForeign - 2)
  hadd tbl_char colOOC $calc(%colOOC - 2)
  hadd tbl_char colNext $calc(%colNext - 2)
  hadd tbl_char colBegin $calc(%colBegin - 2)
  hadd tbl_char colContinue $calc(%colContinue - 2)
  hadd tbl_char colDone $calc(%colDone - 2)


  ;; Create color file for advanced editor
  writeini %iniFile Palette 00 $color(0)
  writeini %iniFile Palette 01 $color(1)
  writeini %iniFile Palette 02 $color(2)
  writeini %iniFile Palette 03 $color(3)
  writeini %iniFile Palette 04 $color(4)
  writeini %iniFile Palette 05 $color(05)
  writeini %iniFile Palette 06 $color(06)
  writeini %iniFile Palette 07 $color(07)
  writeini %iniFile Palette 08 $color(08)
  writeini %iniFile Palette 09 $color(09)
  writeini %iniFile Palette 10 $color(10)
  writeini %iniFile Palette 11 $color(11)
  writeini %iniFile Palette 12 $color(12)
  writeini %iniFile Palette 13 $color(13)
  writeini %iniFile Palette 14 $color(14)
  writeini %iniFile Palette 15 $color(15)

  writeini %iniFile Colors colDefault $calc(%colDefault - 2)
  writeini %iniFile Colors colAction $calc(%colAction - 2)
  writeini %iniFile Colors colDialog $calc(%colDialog - 2)
  writeini %iniFile Colors colTelepathy $calc(%colTelepathy - 2)
  writeini %iniFile Colors colForeign $calc(%colForeign - 2)
  writeini %iniFile Colors colOOC $calc(%colOOC - 2)
  writeini %iniFile Colors colNext $calc(%colNext - 2)
  writeini %iniFile Colors colBegin $calc(%colBegin - 2)
  writeini %iniFile Colors colContinue $calc(%colContinue - 2)
  writeini %iniFile Colors colDone $calc(%colDone - 2)
  writeini %iniFile Brackets txtBegin $qt($did(dlgCharacter, 32).text)
  writeini %iniFile Brackets txtContinue $qt($did(dlgCharacter, 34).text)
  writeini %iniFile Brackets txtDone $qt($did(dlgCharacter, 36).text)
  writeini %iniFile Brackets txtNext $qt($did(dlgCharacter, 30).text)
  writeini %inifile Chars txtDialog $qt($did(dlgCharacter, 22).text)
  writeini %inifile Chars txtForeign $qt($did(dlgCharacter, 21).text)
  writeini %inifile Chars txtTelepathy $qt($did(dlgCharacter, 20).text)
  hsave -sbo tbl_char $qt(%charpath $+ $1- $+ .rpg)
  unset %edited
}

alias -l swchar {
  ;; Profile Navigation Handler
  var %curchan   = $active $+ $network
  var %CNames    = $left($nopath($2-), $calc($len($nopath($2-)) - 4))
  var %curquery  = $query($active) $+ $network

  $iif($query($active), %curchan = %curquery)
  $iif($hget(%curchan), hfree %curchan)
  hmake %curchan 10
  hload -b %curchan $qt($2-)
  hadd %curchan dateMod $file($qt($2-)).mtime
  hadd %curchan curProfile %CNames
  writeini $qt($scriptdir $+ chansettings.ini) %curchan profile %CNames
  $iif($1 == 1, echo 14Voodoo05²1: 15Changed active profile to 05 $+ %CNames)
  titlebar AvalonScript Voodoo²: Active Profile - $+ $chr(32) $+ $hget(%curchan, curProfile)
  ;; Too Noisy: $iif($1 == 2, echo 14Voodoo05²1: 15Refreshed %CNames)
}

alias -l swnone {
  ;; Update titlebar and hash for No Profile
  hadd $1- curProfile None
  titlebar AvalonScript Voodoo²: Active Profile - None)
}

alias -l saytext {
  ;; Main Cut-Color loop as called by INPUT event
  if ( ( $left($1,1) != / && $left($1,1) != ! && $left($1,1) != ` ) || ( $1 == /me ) ) {

    var %curchan    = $chan $+ $network
    var %curquery   = $query($active) $+ $network

    $iif($query($active), %curchan = %curquery)
    var %re           =  (^\x03\d{1,2}$)
    var %txtBuffer    = $1-
    var %colDefault   = 
    var %colAction    = 
    var %pnick        = $null
    var %colNext      = $null
    var %colDone      = $null 
    var %colCont      = $null
    var %colBegin      = $null  

    var %txtNext      = $hget(%curchan, txtNext)
    var %txtCont      = $hget(%curchan, txtContinue)
    var %txtDone      = $hget(%curchan, txtDone))
    var %txtBegin     = $hget(%curchan, txtBegin))

    if ($hget(%curchan, useColor) == 1) {
      ;; Color loop? Replace $NULL values from above
      %colDefault     = $hget(%curchan, colDefault)
      %colAction      = $hget(%curchan, colAction)
      %colNext        = $hget(%curchan, colNext)
      %colCont        = $hget(%curchan, colContinue)
      %colDone        = $hget(%curchan, colDone)
      %colBegin       = $hget(%curchan, colBegin)

      $iif(%colDefault < 10, %colDefault = $chr(3) $+ $chr(48) $+ %colDefault, %colDefault = $chr(3) $+ %colDefault)
      $iif(%colAction  < 10, %colAction = $chr(3) $+ $chr(48) $+ %colAction, %colAction = $chr(3) $+ %colAction)
      $iif(%colNext    < 10, %colNext = $chr(3) $+ $chr(48) $+ %colNext, %colNext = $chr(3) $+ %colNext)
      $iif(%colCont    < 10, %colCont = $chr(3) $+ $chr(48) $+ %colCont, %colCont = $chr(3) $+ %colCont)
      $iif(%colDone    < 10, %colDone = $chr(3) $+ $chr(48) $+ %colDone, %colDone = $chr(3) $+ %colDone)
      $iif(%colBegin   < 10, %colBegin = $chr(3) $+ $chr(48) $+ %colBegin, %colBegin = $chr(3) $+ %colBegin)

      $iif($len($hget(%curchan, txtNext)), %txtNext = %colNext $+ $hget(%curchan, txtNext))
      $iif($len($hget(%curchan, txtContinue)), %txtCont = %colCont $+ $hget(%curchan, txtContinue))
      $iif($len($hget(%curchan, txtDone)), %txtDone = %colDone $+ $hget(%curchan, txtDone))
      $iif($len($hget(%curchan, txtBegin)), %txtBegin = %colBegin $+ $hget(%curchan, txtBegin))
    }
    ;; PNICK? 
    $iif($hget(%curchan, usePNick) == 1, %pnick = $hget(%curchan, txtPNick))

    if ($gettok($1-, 1, 32) == /me) {
      ;; IF /me set ACTION color
      %txtBuffer = $right(%txtBuffer,-4)
      %txtBuffer = %colAction $+ %txtBuffer 
    }
    else {
      ;; Otherwise set DEFAULT color
      %txtBuffer = %colDefault $+ %txtBuffer 
    }
    if ($hget(%curchan, UseColor) == 1) {
      ;; Colorize dialog, telepathy and foreign...
      %colored = $colorquotes(%curchan, %txtBuffer )
      %colored = $colortele(%curchan, %colored)
      %colored = $colorfor(%curchan, %colored)
    }
    else {
      ;; ...or just pass on text
      %colored = %txtBuffer 
    }
    ;; Lastly, assign PNICK text
    %colored = %pnick $+ $chr(32) $+ %colored
    if ($hget(%curchan, UseCut) == 1) {
      ;; CUT on? Main cut loop  
      var %txtNewBuflen = $len(%colored)
      if (%txtNewBuflen > 400) {
        ;; Big enough to cut?
        var %pos            = 1
        var %txtNewBuf      = $mid(%colored, %pos, %txtBufLen)
        var %firsttime      = 1
        var %txtLastColor   = $null
        var %txtNextcolor   = $null

        while ( %txtNewBuf != $null ) {
          ;; Do until END OF POST
          if ( $len($deltok(%txtNewBuf, -1, 32)) < %txtCutLen ) {
            var %txtNewBuf = $left(%txtNewBuf, %txtCutLen)
            inc %pos %txtCutLen
          }
          else {
            var %txtNewBuf = $deltok(%txtNewBuf,-1,32)
            inc %pos $len(%txtNewBuf)
            inc %pos
          }
          var %txtResult = %txtNewBuf
          var %txtNewBuf = $mid(%colored, %pos, %txtBufLen)
          if (%firsttime == 1) {
            ;; Get last active color and prepend
            var %txtLastColor = $get_end_cc(%txtResult)
            if ($gettok($1-, 1, 32) == /me) {
              ;; IF ACTION then /ME with %colAction
              if ( $len(%colored) <= %txtCutLen) {
                action %txtResult %txtDone
              }
              else {
                action %txtResult %txtNext
              }
              if (%txtLastColor == $null) {
                %txtLastColor = %colDefault
              }
            }
            else {
              ;; otherwise use /SAY
              say %txtBegin %txtResult %txtNext
              if (%txtLastColor == $null) {
                var %txtLastColor = %colDefault
              }
            }
            var %firsttime = 0
          }
          else {
            var %txtColNewest = $chr(3) $+ %txtLastColor
            if (%txtNewBuf != $null) {
              say %txtCont $+ %txtColNewest %txtResult %txtNext
            }
            else {
              if (%txtNewBuflen <= 945) {

                if (!$regex(%txtResult,%re)) {
                  say %txtCont $+ %txtColNewest %txtResult %txtDone
                }
              }
              else {
                if (!$regex(%txtResult,%re)) {
                  say %txtCont $+ %txtColNewest %txtResult %txtDone
                }
              }
            }
            %txtNextcolor = $get_end_cc(%txtResult)
            if (%txtNextcolor != $null) {
              var %txtLastColor = %txtNextcolor
            }
          }
        }
      }
      else {
        ;; Last post
        if ($gettok($1-, 1, 32) == /me) {
          action %colored
        }
        else {
          say %colored
        }
      }
    }
    else {
      ;; From above, IF NOT long enough to cut, just /SAY or /ME
      if ($gettok($1-, 1, 32) == /me) {
        action %colored
      }
      else {
        say %colored
      }
    }
  }
}

alias -l colorquotes {
  ;; Colorize Dialog
  var %num         = 1
  var %out         = $2-
  var %txtDialog   = $hget($1, txtDialog)
  var %txtColorD   = $hget($1, colDialog) 

  $iif(%txtColorD < 10, %txtColorD = $chr(48) $+ %txtColorD)

  :loop
  if ($pos(%out,%txtDialog,%num) != $null) {
    if ($calc(%num % 2) == 1) {
      set %txtColorD2 $get_end_cc($left(%out,$calc($pos(%out,%txtDialog,%num) + 1)))
      %out = $left(%out,$calc($pos(%out,%txtDialog,%num) - 1)) $+  $+ %txtColorD $+ %txtDialog $+ $right(%out,$calc($pos(%out,%txtDialog,%num) * -1))
    }
    else {
      if ($right(%out,$calc($pos(%out,%txtDialog,%num) * -1))) {
        %out = $left(%out,$calc($pos(%out,%txtDialog,%num) - 1)) $+ %txtDialog $+  $+ %txtColorD2 $+ $right(%out,$calc($pos(%out,%txtDialog,%num) * -1))  
      }
      else {
        %out = $left(%out,$calc($pos(%out,%txtDialog,%num) - 1)) $+ %txtDialog
      }
    }   
    inc %num 1
    goto loop
  }
  return %out
}

alias -l colortele {
  ;; Colorize Telepathy
  var %numt        = 1
  var %outt        = $2-
  var %txtTele     = $hget($1, txtTelepathy)
  var %txtColorT   = $hget($1, colTelepathy)

  $iif(%txtColorT < 10, %txtColorT = $chr(48) $+ %txtColorT)
  :loop
  if ($pos(%outt,%txtTele,%numt) != $null) {
    if ($calc(%numt % 2) == 1) {
      set %txtColorT2 $get_end_cc($left(%outt,$calc($pos(%outt,%txtTele,%numt) - 3)))
      %outt = $left(%outt,$calc($pos(%outt,%txtTele,%numt) - 1)) $+  $+ %txtColorT $+ %txtTele $+ $right(%outt,$calc($pos(%outt,%txtTele,%numt) * -1))
    }
    else {
      if ($right(%outt,$calc($pos(%outt,%txtTele,%numt) * -1))) {
        %outt = $left(%outt,$calc($pos(%outt,%txtTele,%numt) - 1)) $+ %txtTele $+  $+ %txtColorT2 $+ $right(%outt,$calc($pos(%outt,%txtTele,%numt) * -1))
      }
      else {
        %outt = $left(%outt,$calc($pos(%outt,%txtTele,%numt) - 1)) $+ %txtTele 
      }
    }
    inc %numt 1
    goto loop
  }
  return %outt
}

alias -l colorfor {
  ;; Colorize Foreign Language
  var %numf        = 1
  var %outf        = $2-
  var %txtForeign  = $hget($1, txtForeign)
  var %txtColorF   = $hget($1, colForeign) 

  $iif(%txtColorF < 10, %txtColorF = $chr(48) $+ %txtColorF)

  :loop
  if ($pos(%outf,%txtForeign,%numf) != $null) {
    if ($calc(%numf % 2) == 1) {
      set %txtColorf2 $get_end_cc($left(%outf,$calc($pos(%outf,%txtForeign,%numf) - 3)))
      %outf = $left(%outf,$calc($pos(%outf, %txtForeign,%numf) -1)) $+  $+ %txtColorf $+ %txtForeign $+ $right(%outf,$calc($pos(%outf,%txtForeign,%numf) * -1))
    }
    else {
      if ($right(%outf,$calc($pos(%outf,%txtForeign,%numf) * -1))) {
        %outf = $left(%outf,$calc($pos(%outf,%txtForeign,%numf) -1)) $+ %txtForeign $+  $+ %txtColorf2 $+ $right(%outf,$calc($pos(%outf,%txtForeign,%numf) * -1))
      }
      else {
        %outf = $left(%outf,$calc($pos(%outf,%txtForeign,%numf) -1)) $+ %txtForeign
      }   
    }
    inc %numf 1
    goto loop
  }
  return %outf
}

alias -l get_end_cc {
  ;; Get last color code in saytext chunk
  if ($prop == bold) return $iif($calc($count($$1,) % 2),$true,$null)
  if ($prop == underline) return $iif($calc($count($$1,) % 2),$true,$null)
  if ($prop == reverse) return $iif($calc($count($$1,) % 2),$true,$null)
  var %re    = /(\d{1,2}(?:,\d{1,2})*)(?:[^]*)$/
  !.echo -q $regex(get_last,$$1,%re)
  return $iif($regml(get_last,1),$ifmatch,$null)
}

alias -l saycmd {
  ;; Cut-Color loop for /npc commands

  var %txtBuffer    = $right($1-, $calc($len($1-) - $pos($1-,:,1)))
  $iif($1 == 3, %txtBuffer = $2-)

  var %cmdLine      = $left($1-, $calc($pos($1-,:,1) - 1))
  var %curchan      = $chan $+ $network    
  var %colDefault   = 
  var %colAction    = 
  var %pnick        = $null
  var %colNext      = $null
  var %colDone      = $null 
  var %colCont      = $null
  var %colBegin     = $null

  var %txtNext      = $hget(%curchan, txtNext)
  var %txtCont      = $hget(%curchan, txtContinue)
  var %txtDone      = $hget(%curchan, txtDone))
  var %txtBegin     = $hget(%curchan, txtBegin))

  tokenize 32 %cmdLine

  $iif($1 == 1, %cmdPrefix = npc $+ $chr(32) $+ $chan $+ $chr(32) $+ $2 $+ $chr(32) $+ :)
  $iif($1 == 2, %cmdPrefix = npca $+ $chr(32) $+ $chan $+ $chr(32) $+ $2 $+ $chr(32) $+ :)
  $iif($1 == 3, %cmdPrefix = scene $+ $chr(32) $+ $chan $+ $chr(32) $+ :)

  if ($hget(%curchan, useColor) == 1) {
    %colDefault   = $hget(%curchan, colDefault)
    %colAction    = $hget(%curchan, colAction)
    %colNext      = $hget(%curchan, colNext)
    %colCont      = $hget(%curchan, colContinue)
    %colDone      = $hget(%curchan, colDone)
    %colBegin     = $hget(%curchan, colBegin)

    $iif(%colDefault < 10, %colDefault = $chr(3) $+ $chr(48) $+ %colDefault, %colDefault = $chr(3) $+ %colDefault)
    $iif(%colAction < 10, %colAction = $chr(3) $+ $chr(48) $+ %colAction, %colAction = $chr(3) $+ %colAction)
    $iif(%colNext < 10, %colNext = $chr(3) $+ $chr(48) $+ %colNext, %colNext = $chr(3) $+ %colNext)
    $iif(%colCont < 10, %colCont = $chr(3) $+ $chr(48) $+ %colCont, %colCont = $chr(3) $+ %colCont)
    $iif(%colDone < 10, %colDone = $chr(3) $+ $chr(48) $+ %colDone, %colDone = $chr(3) $+ %colDone)
    $iif(%colBegin < 10, %colBegin = $chr(3) $+ $chr(48) $+ %colBegin, %colBegin = $chr(3) $+ %colBegin)

    $iif($len($hget(%curchan, txtNext)), %txtNext = %colNext $+ $hget(%curchan, txtNext))
    $iif($len($hget(%curchan, txtContinue)), %txtCont = %colCont $+ $hget(%curchan, txtContinue))
    $iif($len($hget(%curchan, txtDone)), %txtDone = %colDone $+ $hget(%curchan, txtDone))
    $iif($len($hget(%curchan, txtBegin)), %txtBegin = %colBegin $+ $hget(%curchan, txtBegin))
  }

  $iif($1 == 2, %colDefault = %colAction)
  if ($hget(%curchan, UseCut) == 1) {
    var %txtNext      = %colNext $+ $hget(%curchan, txtNext)
    var %txtCont      = %colCont $+ $hget(%curchan, txtContinue)
    var %txtDone      = %colDone $+ $hget(%curchan, txtDone)
    var %txtBegin     = %colBegin $+ $hget(%curchan, txtBegin)
  }
  %txtBuffer = %colDefault $+ %txtBuffer 

  if ($hget(%curchan, UseColor) == 1 && $hget(%curchan, curProfile) != None) {
    %colored = $colorquotes(%curchan, %txtBuffer )
    %colored = $colortele(%curchan, %colored)
    %colored = $colorfor(%curchan, %colored)
  }
  else {
    %colored = %txtBuffer 
  }
  var %txtNewBuflen = $len(%colored)

  if (%txtNewBuflen > 400) {

    var %pos = 1
    var %txtNewBuf = $mid(%colored, %pos, %txtBufLen)
    var %firsttime = 1
    var %txtLastColor = $null
    var %txtNextcolor = $null

    while ( %txtNewBuf != $null ) {
      if ( $len($deltok(%txtNewBuf, -1, 32)) < %txtCutLen ) {
        var %txtNewBuf = $left(%txtNewBuf, %txtCutLen)
        inc %pos %txtCutLen
      }
      else {
        var %txtNewBuf = $deltok(%txtNewBuf,-1,32)
        inc %pos $len(%txtNewBuf)
        inc %pos
      }
      var %txtResult = %txtNewBuf
      var %txtNewBuf = $mid(%colored, %pos, %txtBufLen)
      if (%firsttime == 1) {
        var %txtLastColor = $get_end_cc(%txtResult)

        %cmdPrefix $+ %txtResult %txtNext
        if (%txtLastColor == $null) {
          var %txtLastColor = %colDefault
        }
        var %firsttime = 0
      }
      else {
        var %txtColNewest = $chr(3) $+ %txtLastColor
        if (%txtNewBuf != $null) {
          %cmdPrefix $+ %txtCont %txtColNewest $+ %txtResult %txtNext
        }
        else {
          if (%txtNewBuflen <= 945) {
            %cmdPrefix $+ %txtCont %txtColNewest $+ %txtResult %txtDone
          }
          else {
            %cmdPrefix $+ %txtCont %txtColNewest $+ %txtResult %txtDone
          }
        }
        %txtNextcolor = $get_end_cc(%txtResult)
        if (%txtNextcolor != $null) {
          var %txtLastColor = %txtNextcolor
        }
      }
    }

  }
  else {
    %cmdPrefix $+ $chr(32) $+ %colored
  }
}

alias -l saytrim {
  ;; Stupid workaround for string concat on internal $* loop
  if ($pos($1-,:,1)) {
    tokenize 58 $1-
    var %nospace = $trim($2-)
    saycmd $1 $+ $chr(32) $+ : $+ %nospace
  }
  else {
    saycmd $1-
  }
}

alias -l trim {
  ;; Trim exploits mIRC's poor preservation of space characters
  return $1-
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            ;;
;;       User Commands        ;;
;;                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias quit {
  ;; On quit, advertise script
  if ($1) {
    quit AvalonScript — Developed by Keiro for #Lysharia on DarkMyst. Want AvalonScript? http://lysharia.com
  }
  else {
    quit AvalonScript — Developed by Keiro for #Lysharia on DarkMyst. Want AvalonScript? http://lysharia.com
  }
}

alias note {
  ;; Open note for curProfile or $1
  var %curchan         = $chan $+ $network
  var %curprofile      = $hget(%curchan, curProfile)
  var %i               = 1

  $iif($1, %curprofile = $1-)
  var %sfile           = $qt(%charpath $+ %curprofile $+ .txt)

  if (!$dialog(sc_ $+ %curprofile)) {
    dialog -m sc_ $+ %curprofile dlgScratch
    dialog -t sc_ $+ %curprofile Scratchpad for %curprofile

    while %i <= $lines($qt(%sfile)) {
      ;; Maintaining line breaks
      did -a sc_ $+ %curprofile 1 $read(%sfile, %i) $+ $chr(10) $+ $crlf
      inc %i
    }
    did -a sc_ $+ %curprofile 1 $date $+ $chr(32) $+ at $+ $chr(32) $+ $time $+ $chr(10) $+ $crlf
  }
  else {
    echo 14Voodoo05²1: 15Scratchpad already open for 05 $+ %curprofile
  }
}

alias sendpic {
  ;; Send character profile image to $active query or $1
  var %curchan        = $chan $+ $network
  var %curquery       = $query($active) $+ $network

  $iif($query($active), %curchan = %curquery)

  if ($hget(%curchan, curProfile) != None) {
    if ($1) {
      var %tfName     = $hget(%curchan, imgCharImage)
      var %sName      = $1- 
      dcc send -c %sName %tfName
    }
    else {
      echo 14Voodoo05²1: 15You must specify a nickname to send to.
    }
  } 
}

alias sayinfo {
  ;; Output txtINFO, useful premade slot
  var %curchan        = $chan $+ $network
  $iif($query($active), %curchan = $query($active) $+ $network)
  $iif($hget(%curchan, curProfile) != None, saytext $hget(%curchan, txtInfo)) 
}

alias describe {
  ;; Output txtDescribe, another useful premade slot
  var %curchan        = $chan $+ $network
  $iif($query($active), %curchan = $query($active) $+ $network)
  $iif($hget(%curchan, curProfile) != None, saytext $hget(%curchan, txtDescription)) 
}

alias ooc {
  ;; Embrace OOC text
  var %curchan       = $chan $+ $network
  var %curquery      = $query($active) $+ $network
  var %txtColorO     = $hget(%curchan, colOOC)
  var %txtOpening    = $hget(%curchan, txtOOCLeft)
  var %txtClosing    = $hget(%curchan, txtOOCRight)

  $iif($query($active), %curchan = %curquery)

  if ($1) {
    say %txtOpening $+  $+ %txtColorO $+ $chr(32) $+ $1- $+ $chr(32) $+  $+ %txtClosing  
  }
  else {
    echo -i11 14 - Syntax: /ooc <text>
  }
}

alias char { 
  ;; Pass me a beer, this is getting repetitive
  var %curchan      = $chan $+ $network
  var %newprof      = $qt(%charpath $+ $1- $+ .rpg)
  var %curquery     = $query($active) $+ $network

  $iif($query($active), %curchan = %curquery)

  if ($1) {
    if ($1 != None) {
      $iif($isfile(%newprof),swchar 1 %newprof, echo Voodoo: $+ $chr(32) $+ $1 $+ $chr(32) $+ -- No such profile)
    }
    else {
      hadd %curchan curProfile None
      echo 14Voodoo05²1: 15Changed active profile to 05None
      titlebar AvalonScript Voodoo²: Active Profile - $+ $chr(32) $+ $hget(%curchan, curProfile)
    }
  }
  else {
    echo -i11 14 - Syntax: /char <profile name>
  }
}

alias aschar {
  ;; A bit more fun. Temporarily switches chars
  var %curquery     = $query($active) $+ $network
  var %txtBuffer    = $right($1-, $calc($len($1-) - $pos($1-,:,1)))
  var %curchan      = $chan $+ $network

  $iif($query($active), %curchan = %curquery)

  var %profname     = $left($1-, $calc($pos($1-,:,1) - 1))
  var %newprof      = $qt(%charpath $+ %profname $+ .rpg)
  var %testprof     = $hget(%curchan, curProfile)
  var %oldprof      = $qt(%charpath $+ %testprof $+ .rpg)

  if ($pos($1-,:,1)) {
    swchar 3 %newprof
    saytext %txtBuffer 
    if (%testprof == None) {
      hadd %curchan curProfile None
      halt
    }
    else {
      swchar 3 %oldprof
    }
  }
  else {
    echo -i11 14 - Syntax: /aschar <profile name> : <text>
  }
}

alias npcsay {
  ;; Cut/Color for DarkMyst.org /NPC
  var %curchan      = $chan $+ $network
  var %curprofile   = $hget(%curchan, curProfile)
  var %tblname      = $qt(%charpath $+ %curprofile $+ .rpg)

  if (%curprofile != None) {
    if ($hget(%curchan, dateMod) != $file(%tblname).mtime) {
      swchar 2 %tblname
    }
  }

  if ($pos($1-,:,1)) {
    tokenize 58 $1-

    if ($pos($2-, $chr(92)) && $len($2-) > 370) {
      %cmdLine = $1
      tokenize 92 $2- | saytrim 1 %cmdLine : $*
    }
    else {
      saycmd 1 $+ $chr(32) $+ $1 $+ : $+ $2-
      halt
    } 
  }
  else {
    echo -i11 14 - Syntax: /npcsay <npc name> : <text>
  }  
}

alias npcscene {
  ;; Cut/Color for Darkmyst.org /SCENE
  var %curchan      = $chan $+ $network
  var %curprofile   = $hget(%curchan, curProfile)
  var %tblname      = $qt(%charpath $+ %curprofile $+ .rpg)

  if (%curprofile != None) {
    if ($hget(%curchan, dateMod) != $file(%tblname).mtime) {
      swchar 2 %tblname
    }
  }
  if ($pos($2-, $chr(92)) && $len($2-) > 370) {
    %cmdLine = $1
    tokenize 92 $2- | saytrim 3 $*
  }
  else {
    saycmd 3 $+ $chr(32) $+ $1-
  }
}

alias npcact {
  ;; Cut/Color for DarkMyst.org /NPCA
  var %curchan      = $chan $+ $network
  var %curprofile   = $hget(%curchan, curProfile)
  var %tblname      = $qt(%charpath $+ %curprofile $+ .rpg)

  if (%curprofile != None) {
    if ($hget(%curchan, dateMod) != $file(%tblname).mtime) {
      swchar 2 %tblname
    }
  }

  if ($pos($1-,:,1)) {
    tokenize 58 $1-

    if ($pos($2-, $chr(92)) && $len($2-) > 370) {
      %cmdLine = $1
      tokenize 92 $2- | saytrim 2 %cmdLine : $*
    }
    else {
      saycmd 2 $+ $chr(32) $+ $1 $+ : $+ $2-
      halt
    } 
  }
  else {
    echo -i11 14 - Syntax: /npcsay <npc name> : <text>
  } 
}

alias ae {
  ;; Added for external FatMouth advanced editor
  if ($isfile($qt($scriptdir $+ fat mouth v2.exe))) {
    run $qt($scriptdir $+ fat mouth v2.exe) 
  }
  else {
    echo 14Voodoo05²1: 15FatMouth Advanced Editor not found in05 $scriptdir
    echo 14Voodoo05²1: 15Please visit 05http://www.voodoo-script.com 15for more information.
  }
}
alias editor {
  ae
}
alias fatmouth {
  ae
}
alias advanced {
  ae
}

alias vhelp {
  ;; Command Listing 
  window -k0 @Voodoo²
  echo @Voodoo² 14-= Voodoo05²14Command List =  -
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/ooc - Prints comments in OOC brackets set by the profile.
  echo -i11 @Voodoo² 14 - Syntax: /ooc <text>
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/describe - Posts the text in your character's description box to the active channel or query.
  echo -i11 @Voodoo² 14 - Syntax: /describe
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/sayinfo - Posts the text in your character's info box to the active channel or query.
  echo -i11 @Voodoo² 14 - Syntax: /sayinfo
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/sendpic - Sends your character's profile picture to the specified user.
  echo -i11 @Voodoo² 14 - Syntax: /sendpic <name>
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/note - Opens your characters scratch pad for notes.
  echo -i11 @Voodoo² 14 - Syntax: /note [profile]
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/aschar - Sends a single post with the specified profile settings.
  echo -i11 @Voodoo² 14 - Syntax: /aschar <profile name> : <text>
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/char - Switches character profiles.
  echo -i11 @Voodoo² 14 - Syntax: /char <profile name>
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/npcsay - Utilizes DarkMyst's /npc command in the active channel, and cuts text accordingly. Carries colors over from the active profile in the channel.
  echo -i11 @Voodoo² 14 - Syntax: /npcsay <npc name> : <text>
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/npcact - Utilizes DarkMyst's /npca command in the active channel, and cuts text accordingly. This is like the default /me command and uses the action color. Carries over colors from the active profile in the channel.
  echo -i11 @Voodoo² 14 - Syntax: /npcact <npc name> : <action>
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/npcscene - Utilizes DarkMyst's /scene command in the active channel. 
  echo -i11 @Voodoo² 14 - Syntax: /npcscene <scene>
  echo @Voodoo² $chr(13)
  echo -i11 @Voodoo² 14/advanced, /fatmouth, /ae - Opens FatMouth Advanced Post Editor
  echo -i11 @Voodoo² 14 - Syntax: /advanced
  echo @Voodoo² $chr(13)
}
;; fin
