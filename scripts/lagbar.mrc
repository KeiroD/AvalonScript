;MyLagBar by Ford_Lawnmower irc.geekshed.net #Script-Help
alias -l Settings {
  goto $prop
  :TextColor
  return $iif($readini(MylagbarTB\Mylagbar.ini,lagbar,TextColor) == $null,$rgb(255,0,0),$v1)
  :BarColor
  return $iif($readini(MylagbarTB\Mylagbar.ini,lagbar,BarColor) == $null,$rgb(0,0,255),$v1)
  :Background
  return $iif($readini(MylagbarTB\Mylagbar.ini,lagbar,Background) == $null,$rgb(240,240,240),$v1)
  :Interval
  return $iif($readini(MylagbarTB\Mylagbar.ini,lagbar,Interval),$v1,15)
  :Multiplier
  return $iif($readini(MylagbarTB\Mylagbar.ini,lagbar,Multiplier),$v1,20)
  :Length
  return $iif($readini(MylagbarTB\Mylagbar.ini,lagbar,Length),$v1,80)
  :Network
  return $readini(MylagbarTB\Mylagbar.ini,lagbar,Network)
  :Status
  return $iif($readini(MylagbarTB\Mylagbar.ini,lagbar,Status),$v1,On)
}
alias MyLagBarUpdate {
  if ($status == connected && $Settings().status == On) .raw -q ping $+(MyLagBar,:,$network,:,$ticks)
}
alias StartMyLagBar {
  if ($Settings().status == On) {
    if (!$isdir(MyLagBarTB)) mkdir MyLagBarTB
    .timerMyLagBar -o 0 $Settings().Interval scon -a MyLagBarUpdate
    MyLagBarUpdate
  }
}
on *:Active:*: {
  if (!$isdir(MyLagBarTB)) mkdir MyLagBarTB
  if ($network) writeini MylagbarTB\Mylagbar.ini lagbar Network $network
  MyLagBarUpdate
}
on ^*:pong:{ 
  if ($istok($2,MyLagBar,58)) {
    haltdef
    var %lag $calc(($ticks - $gettok($2,3,58)) / 1000)    
    if ($network == $Settings().Network) {
      if (!$window(@MyLagBar)) window -hp +d @MyLagBar 0 0 $Settings().Length 22
      clear @mylagbar
      drawfill -r @MyLagBar $Settings().Background $Settings().Background 0 0
      drawtext -pr @mylagbar $Settings().TextColor arial 11 0 0 $+($chr(2),Lag:,$chr(32),%lag,s)
      if (%lag) drawrect -fr @Mylagbar $Settings().BarColor 2 0 14 $calc(%lag * $Settings().Multiplier) 8
      UpdateToolBar -tp Network: $network *** Lag: $+(%lag,s) ***
    }
  } 
}
alias -l UpdateToolBar {
  if (!$isdir(MyLagBarTB)) mkdir MyLagBarTB
  drawsave @MyLagBar MyLagBarTB\MyLagBar.jpg
  if ($toolbar(MyLagBar)) { 
    toolbar $1 MyLagBar $qt($2-) "MyLagBarTB\MyLagBar.jpg" $&
      $qt(/GetMyLagBar) @MyLagBar
  }
  else {
    toolbar -as MyLagBar|
    toolbar -a MyLagBar $qt($2-) "MyLagBarTB\MyLagBar.jpg" $&
      $qt(/GetMyLagBar) @MyLagBar
  }
}
On *:Start: StartMyLagBar
On *:Unload: {
  .remove MyLagBarTB/MyLagbarTemp.jpg
  .remove MyLagBarTB/MyLagbar.jpg
  .remove MyLagBarTB/MyLagbar.ini
  .timer 1 5 .rmdir MyLagBarTB
}
menu @MyLagBar {
  MyLagBar
  .$iif($timer(MyLagBar),$style(3)) On:{
    writeini MyLagBarTB\MyLagBar.ini Settings Status On
    StartMyLagBar
  }
  .$iif(!$timer(MyLagBar),$style(3)) Off:{
    scon -a .timerMyLagBar off
    window -c @MyLagBar
    if ($toolbar(MyLagBar)) toolbar -d MyLagBar
    if ($toolbar(MyLagBar|)) toolbar -d MyLagBar|
    writeini MyLagBarTB\MyLagBar.ini Settings Status Off
  }
  .Dialogs:GetMyLagBar
}
menu channel,status,menubar {
  MyLagBar
  .$iif($timer(MyLagBar),$style(3)) On:{
    writeini MyLagBarTB\MyLagBar.ini Settings Status On
    StartMyLagBar
  }
  .$iif(!$timer(MyLagBar),$style(3)) Off:{
    scon -a .timerMyLagBar off
    window -c @MyLagBar
    if ($toolbar(MyLagBar)) toolbar -d MyLagBar
    if ($toolbar(MyLagBar|)) toolbar -d MyLagBar|
    writeini MyLagBarTB\MyLagBar.ini Settings Status Off
  }
  .Dialogs:GetMyLagBar
}
dialog MyLagBar {
  title "Lag Bar Setup"
  size -1 -1 104 149
  option dbu
  combo 4, 34 4 63 11, drop
  combo 5, 37 87 60 11, drop
  combo 6, 37 100 60 11, drop
  combo 7, 37 114 60 11, drop
  button "+", 8, 17 38 12 12
  button "-", 9, 31 38 12 12
  button "+", 10, 17 54 12 12
  button "-", 11, 31 54 12 12
  button "+", 12, 17 70 12 12
  button "-", 13, 31 70 12 12
  button "Save", 14, 6 131 37 12, ok cancel
  button "Close", 15, 61 131 37 12, cancel
  icon 16, 48 38 47 43
  text "Colors:", 17, 5 5 25 8, right
  text "R:", 18, 6 18 8 8
  text "G:", 19, 38 18 8 8
  text "B:", 20, 70 18 8 8
  text "R:", 21, 6 40 8 8
  text "G:", 22, 6 56 8 8
  text "B:", 23, 6 72 8 8
  text "Multiplier:", 24, 5 88 25 8, right
  text "Length:", 25, 5 102 25 8, right
  text "Interval:", 26, 5 115 25 8, right
  text "", 27, 48 29 49 8, center
  combo 1, 12 17 23 11, drop
  combo 2, 44 17 23 11, drop
  combo 3, 76 17 23 11, drop
}
On *:dialog:MyLagBar:init:*: {
  if (!$window(@MyLagBarTemp)) window -hp +d @MyLagBarTemp 0 0 100 100
  didtok -a $dname 1-3 32 0 $regsubex($str(.,255),/(.)/g,$+(\n,$chr(32)))
  didtok -a $dname 4 32 TextColor BarColor Background
  didtok -a $dname 5 32 10 20 30 40 50 60 70 80 90 100
  didtok -a $dname 6 32 50 60 70 80 90 100 110 120 130 140 150
  didtok -a $dname 7 32 $regsubex($str(.,24),/(.)/g,$+($calc(\n * 5),$chr(32)))
  did -c $dname 4 1
  did -c $dname 5 $didwm($dname,5,$Settings().Multiplier)
  did -c $dname 6 $didwm($dname,6,$Settings().Length)
  did -c $dname 7 $didwm($dname,7,$Settings().Interval)
  UpdateColorSelection $dname $did(4)
}
On *:dialog:MyLagBar:Sclick:1-15: {
  if ($did == 4) UpdateColorSelection $dname $did(4)
  elseif ($did < 4) {
    var %rgb $rgb($did(1),$did(2),$did(3))
    writeini MyLagBarTB\MyLagBar.ini lagbar $did(4) %rgb
    UpdateImage %rgb %rgb
  }
  elseif ($did < 8) {
    writeini MyLagBarTB\MyLagBar.ini lagbar $gettok($did($calc($did + 19)),1,58) $did($did)
    if ($did == 7) .timerMyLagBar -o 0 $Settings().Interval scon -a MyLagBarUpdate
  }
  elseif ($did < 14) {
    UpdateRGB $did($did) $iif($did < 10,1,$iif($did < 12,2,3))
  }
  MyLagBarUpdate
}
alias -l UpdateRGB {
  var %value $did(MyLagBar,$2), %calc $calc(%value $1 1), %rgb $rgb($did(MyLagBar,1),$did(MyLagBar,2),$did(MyLagBar,3))
  if ((%calc > -1) && (%calc < 256)) {
    did -c MyLagBar $2 $calc(%calc + 1)
    writeini MyLagBarTB\MyLagBar.ini lagbar $did(MyLagBar,4) %rgb
    .timerUpdateTempImage 1 1 UpdateImage %rgb %rgb
  }
}
On *:dialog:MyLagBar:close:*: .remove MyLagBarTB/MyLagbarTemp.jpg
alias -l UpdateColorSelection {
  var %dname $1, %item $2
  tokenize 44 $rgb($($+($,Settings().,%item),2))
  did -c %dname 1 $calc($1 + 1)
  did -c %dname 2 $calc($2 + 1)
  did -c %dname 3 $calc($3 + 1)
  did -a $dname 27 %item
  UpdateImage $rgb($1,$2,$3) $rgb($1,$2,$3)
}
alias -l UpdateImage {
  if (!$window(@MyLagBarTemp)) window -hp +d @MyLagBarTemp 0 0 100 100
  clear @MyLagBarTemp
  drawfill -r @MyLagBarTemp $1 $2 0 0
  drawsave @MyLagBarTemp MyLagBarTB/MyLagbarTemp.jpg
  did -g MyLagBar 16 MyLagBarTB/MyLagbarTemp.jpg
}
alias GetMyLagBar dialog $iif(!$dialog(MyLagBar),-m MyLagBar,-v) MyLagBar
