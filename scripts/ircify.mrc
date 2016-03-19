;--------------------------------------------------------------------

;--------------------------------------------------------------------
;-----------------  ircify start -----------------

; if the script does not work, download this: http://www.microsoft.com/en-us/download/details.aspx?id=5555
;
; This script/dll will not work on mirc 6.2 and below. possibly more versions as well.
; It works fine on mirc 6.3x and above!

; ircify.dll made by dev0
; ircify.mrc made by Tw|tch

;-----------------
;-- If you happen to have any issues with the dll not overwriting when you upgrade,
;-- try making sure it's not loaded with this command: /ircifdll unload

;-- There are some scripts out there that will automaticaly look up spotify url/uri links,
;-- to try to avoid this, I have setup a way to split the link with bold control codes..
;-- Enable Splitting                         ->     /spotsplit on
;-- Disable Splitting                        ->     /spotsplit off

;-- aliases to easily set the display formats, you know, if for some
;-- reason you don't want to use the \awesome\ settings dialog.. (à¦¤ï¸µ;à¦¤)
;-- Set NP output format              ->     /spoutp np: .song. - .artist. (.album.)
;-- Get current NP tag list            ->     //echo -ag NP Tags: $nptags
;-- Set Lookup output format     ->     /splook ss: .song. - .artist. (.album.)
;-- Get current Lookup tag list   ->     //echo -ag Lookup Tags: $luptags
;-----------------

;--------------------------------------------------------------------
; Just some quick notes for scripters...
; As of right now, there is no real way to use the standard return command...
; (Well there is, but it makes mirc hang until return, just the way dll works, sorry.)

; however, that being said, you can pretty much send the data anywhere you want,
; just use the /sptell command knowing that the current song data would be the last param sent..

; for example:
; '/sptell msg $chan' <- would be the same as sending -> '/msg $chan <now playing data>'
; '/sptell describe $nick' <- would be the same as sending -> '/describe $nick <now playing data>'

; as such, you can do this for things like dialogs and custom windows like so;
; /sptell did -ra <dname> <did>
; /sptell [echo|aline] @window

; to strip the output, just call it as $sptell().strip, like so;
; /noop $sptell(did -ra <dname> <did>).strip
; /noop $sptell(msg $chan).strip
;-----------------
;-- If you really just need a return call, you can use "$sptret", but as stated above.. it makes mirc hang for a moment..

;- Also:
;-- You may notice a lot of stuff about "Equalify" here and there within ircify...
;-- If you don't already know what it is, \and\ have it, you should. So, Go. Get it. nao.
;-- You can get your copy at http://equalify.me/

;--------------------------------------------------------------------
;-- current script version
alias ircifvern { return 2.3.3 }
;-- on load/start make some checks..
on *:load: { ckircify }
on *:start: { ckircify }
;-- clean up on unload... turn off timers, free h-tables, unset vars and unload dll, etc...
on *:unload: {  .timer*ircify* off | hfree -w ircify.* | unset %ircify.* | ircifdll unload }

;--- main settings ini file..
alias ircifysetf { return $qt($scriptdir $+ ircify.ini) }
;-- settings ini quick read/write function
alias sptset {
  var %f = $ircifysetf
  if ($isid) { return $r2ini($iif($prop,$readini(%f,$prop,$$1,$$2),$readini(%f,$$1,$$2))) }
  else { if ($3 == $null) { remini %f $1 $$2 } | else { w2ini %f $1 $2 $3- } } | return
}

;-- OMG! You people NEED to \UPGRADE\! (yes, dev0, this mean you as well!)  áƒš(à² ç›Šà² áƒš)
;-- So, it seems older versions of mirc (6.3x) have issues with control codes and ini files..
;-- This is an attempt to get around that.. yeah, you see it?! So, you know, Upgrade.
;-- yeah, it's sloppy, it sucks, but meh. it is what it is. also, did i mention upgrading?
alias -l r2ini { return $replace($1-,&&b,,&&u,,&&r,,&&k,,&&i,,&&o,) }
alias -l w2ini {
  if ($regex($4-,/(&&b|&&u|&&r|&&k|&&i|&&o)/ig)) { ircifecho 04* /w2ini: illegal characters $qt($regml(1)) - ( $1 $2 $3- ) }
  else { writeini -n $1 $2 $3 $replace($4-,,&&b,,&&u,,&&r,,&&k,,&&i,,&&o) }
}

;--------------------------------------------------------------------
;-- the menus...
alias doircify { return $iif($sptset(main,version) == $ircifversf,$true,$ckircify) }
menu channel,query,nicklist,menubar {
  $iif($doircify,ircify)
  .$iif(!$exists($sptset(main,spotifyapp)),Set Spotify Path):spotifyapp set
  .$iif($exists($sptset(main,spotifyapp)) && !$spotistat,Open Spotify):spotifyapp run
  .$iif($spotistat,$iif($spotistat == 1,Show NP,$style(2) Spotify is Paused)):sptell
  .$iif($spotistat == 1,Show NP...)
  ;-- opens the 'not quite finished' quick display dialog..
  ;..Quick Display Dialog:optsify qspam
  ..-
  ..to $qt($iif($istok(query nicklist,$menu,32),$$1,$active)) ...
  ...$spmenu(echo):sptell echo $active
  ...$spmenu(msg):sptell msg $iif($istok(query nicklist,$menu,32),$$1,$active)
  ...$spmenu(describe):sptell describe $iif($istok(query nicklist,$menu,32),$$1,$active)
  ..to listed channels
  ...$spmenu(echo):hadd -m ircify.tmp auto listed | sptell echo 1
  ...$spmenu(msg):hadd -m ircify.tmp auto listed | sptell msg 1
  ...$spmenu(describe):hadd -m ircify.tmp auto listed | sptell describe 1
  .-
  .Settings
  ..Open Settings Dialog:ircify
  ..-
  ..$iif($sptset(npauto,autodisplay),$style(1)) Auto Display (toggle $iif($sptset(npauto,autodisplay),off,on) $+ ) {
    var %s = $iif($sptset(npauto,autodisplay),0,1) | sptelltimer %s set
  }
  ..Output Displayed Data As...
  ...$spmenu(echo):sptset main outputtype echo $!active
  ...$spmenu(msg):sptset main outputtype msg $!active
  ...$spmenu(describe):sptset main outputtype describe $!active
  ...-
  ...$style(2) / $+ $gettok($sptset(main,outputtype),1,32) to the...:-
  ...-
  ...$iif($sptset(npauto,autoaction) == active,$style(1)) active window:sptset npauto autoaction active
  ...$iif($sptset(npauto,autoaction) == listed,$style(1)) listed channels:sptset npauto autoaction listed
  ..-
  ..$iif($sptset(lookauto,autolookup),$style(1)) Auto Lookup (toggle $iif($sptset(lookauto,autolookup),off,on) $+ ) {
    sptset lookauto autolookup $iif($sptset(lookauto,autolookup),0,1)
  }
  ..Allow Lookup matches in...
  ...$iif($sptset(lookauto,pmlook),$style(1)) Private Message:sptset lookauto pmlook $iif($sptset(lookauto,pmlook),0,1)
  ...$iif($sptset(lookauto,chanlook),$style(1)) Channel Message
  ....$iif($sptset(lookauto,lookaction) == all,$style(1)) All Channels:sptset lookauto chanlook 1 | sptset lookauto lookaction all
  ....$iif($sptset(lookauto,lookaction) == listed,$style(1)) Listed Channels:sptset lookauto chanlook 1 | sptset lookauto lookaction listed
  ....-
  ....Disable Lookup:sptset lookauto chanlook 0
  ..Output Lookup Result As...
  ...$spmenu(echo).lookup:sptset lookauto autocoutput echo $!chan | sptset lookauto autopoutput echo $!nick
  ...$spmenu(msg).lookup:sptset lookauto autocoutput msg $!chan | sptset lookauto autopoutput msg $!nick
  ...$spmenu(describe).lookup:sptset lookauto autocoutput describe $!chan | sptset lookauto autopoutput describe $!nick
  ..-
  ..Edit Hotlink Settings For...
  ...Spotify Links:optsify hotlink
  ...Equalify Links:optsify hotlink eq
  .$iif($status == connected,Channels)
  ..$style(2) $qt($network):-
  ..-
  ..$iif($sptset(npokspam,$network),$style(1)) Auto Display
  ...$style(2) Toggle Status:-
  ...-
  ...$submenu($okspch($1).npokspam)
  ...-
  ...Add All:sptset npokspam $network $left($regsubex($str(.,$chan(0)),/(.)/g,$chan(\n) $+ $chr(44)),-1)
  ...Clear All:sptset npokspam $network
  ..$iif($sptset(spoklook,$network),$style(1)) Auto Lookup
  ...$style(2) Toggle Status:-
  ...-
  ...$submenu($okspch($1).spoklook)
  ...-
  ...Add All:sptset spoklook $network $left($regsubex($str(.,$chan(0)),/(.)/g,$chan(\n) $+ $chr(44)),-1)
  ...Clear All:sptset spoklook $network
  .$iif($eqhlsh,Equalify)
  ..Edit Stored:optsify equalify
  ..-
  ..$submenu($equsers($1))
  .-
  .Information
  ..$style(2) v. $+ $ircifvers:-
  ..-
  ..About ircify ...:ircifecho $sptset(main,aboutmsg)
  ..Check for updates:url http://equalify.me/ircify/
  ..-
  ..Advertise to $qt($iif($istok(query nicklist,$menu,32),$$1,$active)) {
    msg $iif($istok(query nicklist,$menu,32),$$1,$active) $sptset(main,preftag) $sptset(main,advrtmsg)
  }
}
alias okspch {
  if ($1 > $chan(0)) return
  var %t = $prop, %cl = $sptset(%t,$network), %ch = $chan($1), %r, %rt
  if ($istok(%cl,%ch,44)) { return $style(1) %ch :sptset %t $network $remtok(%cl,%ch,0,44) }
  else { return %ch :sptset %t $network $addtok(%cl,%ch,44) }
}
alias spmenu {
  var %t = $2-, %m = $replace($$1,describe,me)
  var %s = $gettok($iif($prop == lookup,$sptset(lookauto,autocoutput),$sptset(main,outputtype)),1,32)
  if (%s == $$1) { return $style(1) %t / $+ %m } | return %t / $+ %m
}
alias eqhlsh {
  var %f = $ircifysetf, %m = $ini(%f,equalify,0)
  if ((%m > 1) || ((%m == 1) && ($readini(%f,equalify,$ini(%f,equalify,1)) != None))) { return $true }
  return $false
}
alias equsers {
  var %f = $ircifysetf, %1 = $1
  if (%1 > $ini(%f,equalify,0)) return
  var %x = $ini(%f,equalify,%1), %z = $readini(%f,equalify,%x), %r = $regsubex(%z,/(\w+)/g,12spotify:eq:\1 $+ )
  return $iif(%x == HotLinked && %z == None,$style(2)) %x :ircifecho Stored equalifys from $+(,%x,:) %r
}
;-----------------

;--------------------------------------------------------------------
;-- check settings...
alias ckircify {
  sptset main preftag [04ir07c09ify]
  ;-- run command to move and/or update settings..
  mvoldset
  ;-- check for dll path...
  if ((!$sptset(main,dllpath)) || (!$exists($qt($sptset(main,dllpath))))) {
    if ($findfile($scriptdir,ircify.dll,1)) { sptset main dllpath $qt($v1) }
    elseif ($findfile($mircdir,ircify.dll,1)) { sptset main dllpath $qt($v1) }
    elseif ($findfile($nofile($mircini),ircify.dll,1)) { sptset main dllpath $qt($v1) }
    elseif ($findfile($nofile($mircexe),ircify.dll,1)) { sptset main dllpath $qt($v1) }
    elseif ($sfile($scriptdir $+ ircify.dll,Select ircify.dll)) { sptset main dllpath $qt($v1) }
    else { ircifecho 04Error: ircify.dll was not found... This is a problem, maybe should fix it.. =( | return $false }
  }
  var %f = $ircifysetf, %sap = $spotifyapp
  ;-- main settings and output defaults check..
  if (!$sptset(main,npcmd)) { alias f11 sptell | sptset main npcmd f11 }
  if (%ircify.output) { sptset main output $v1 }
  if (!$sptset(main,output)) { sptset main output 04n07p: 04".song.04" 07â†” 04(.artist. .coartists. (.album.)04) 07â†’ 04[.played.07/.time.04] 07â†’ .uri. }
  sptset outputs $sha1($sptset(main,output)) $sptset(main,output)
  if (!$sptset(main,outputtype)) { sptset main outputtype msg $!active }
  ;-- auto display stuff
  if ($sptset(npauto,autodisplay) == $null) { sptset npauto autodisplay 0 }
  if (!$sptset(npauto,autoaction)) { sptset npauto autoaction active }
  if (!$sptset(npauto,autotime)) { sptset npauto autotime 5 }
  if ($sptset(npauto,autodisplay)) { sptelltimer 1 }
  if ((!$ini(%f,npokspam,0)) || ($ini(%f,npokspam,0) <= 0)) { sptset npokspam foobar #Foo,#barr }
  ;-- auto lookup output and flood protection setting defaults check
  if (%ircify.luoutput) { sptset main searchout $v1 }
  if (!$sptset(main,searchout)) { sptset main searchout 04s07s: 04".song.04" 07â†” 04(.artist. (.album. (.year.))04) 07â†’ 04[.time.04] 07â†’ .uri. }
  sptset searchout $sha1($sptset(main,searchout)) $sptset(main,searchout)
  if (!$sptset(lookauto,alfldamnt)) { sptset lookauto alfldamnt 5 }
  if (!$sptset(lookauto,alfldtime)) { sptset lookauto alfldtime 60 }
  if ($sptset(lookauto,pmlook) == $null) { sptset lookauto pmlook 0 }
  if (!$sptset(lookauto,chanlook)) { sptset lookauto chanlook 1 }
  if ($sptset(lookauto,autolookup) == $null) { sptset lookauto autolookup 0 }
  if (!$sptset(lookauto,lookaction)) { sptset lookauto lookaction listed }
  if (!$sptset(lookauto,autoeqstore)) { sptset lookauto autoeqstore 1 }
  if (!$sptset(lookauto,autocoutput)) { sptset lookauto autocoutput echo $!chan }
  if (!$sptset(lookauto,autopoutput)) { sptset lookauto autopoutput echo $!nick }
  if ((!$ini(%f,spoklook,0)) || ($ini(%f,spoklook,0) <= 0)) { sptset spoklook foobar #Foo,#barr }
  if (!$sptset(equalify,HotLinked)) { sptset equalify HotLinked None }
  var  %v = $ircifversf
  if ($sptset(main,version) != %v) { ircifecho New $iif($sptset(main,version),Update $+(,$v1,),Version) -> $+(,%v,) | sptset main version %v }
  sptset main advrtmsg 09Spotify for 12m04IR08C (v. $+ $ircifvers $+ ) - Get yours at 12http://equalify.me/ircify/
  sptset main aboutmsg 09Spotify for 12m04IR08C (v. $+ $ircifversf $+ ) - Get yours at 12http://equalify.me/ircify/
  return $true
}

;-- move old settings to keep them a bit more grouped/tidy.. code will be added/removed as things change,
;-- I'm just trying to make sure users don't loose thier, you know, settings... and you know, yell at me.. and stuff..
alias mvoldset {
  if ($sptset(main,dll)) { sptset main dllpath $qt($v1) | sptset main dll }
  if ($sptset(main,hlinkaction)) { sptset hotlinks hlinkaction $v1 | sptset main hlinkaction }
  if ($sptset(main,autoaction)) { sptset npauto autoaction $v1 | sptset main autoaction }
  if ($sptset(main,autodisplay)) { sptset npauto autodisplay $replace($v1,true,1,false,0) | sptset main autodisplay }
  if ($sptset(main,autocoutput).n) { sptset lookauto autocoutput $v1 | sptset main autocoutput }
  if ($sptset(main,autopoutput).n) { sptset lookauto autopoutput $v1 | sptset main autopoutput }
  if ($sptset(main,alfldamnt)) { sptset lookauto alfldamnt $v1 | sptset main alfldamnt }
  if ($sptset(main,alfldtime)) { sptset lookauto alfldtime $v1 | sptset main alfldtime }
  if ($sptset(main,autolookup)) { sptset lookauto autolookup $replace($v1,true,1,false,0) | sptset main autolookup }
  if ($sptset(main,chanlook)) { sptset lookauto chanlook $replace($v1,true,1,false,0) | sptset main chanlook }
  if ($sptset(main,pmlook)) { sptset lookauto pmlook $replace($v1,true,1,false,0) | sptset main pmlook }
}
;-----------------


;//echo -a mIRC: $version OS: $os - ircify: $script(ircify.mrc)
;--------------------------------------------------------------------
;-- Current available tags... lookup/now playing, respectivly..
alias luptags { $iif($isid,return,ircifecho Lookup Tags:) .song. .artist. .album. .time. .coartists. .year. .uri. .url. }
alias nptags { $iif($isid,return,ircifecho Now Playing Tags:) .song. .artist. .coartists. .album. .year. .uri. .url. .time. .played. .pbar. .popularity. .shuffle. }
alias npthlp {
  ;.song. .artist. .coartists. .album. .year. .uri. .url. .time. .played. .pbar. .popularity. .shuffle.
  var %t = Track Title;Track Artist;Track Coartists (up to 6);Track Album Name;Album Release Date
  var %t = $+(%t,;,Track URI (spotify:track:...);Track URL (http://open.spotify.com/...);Track Length)
  var %t = $+(%t,;,Track played time;Track played bar (|||:::::::);Track Popularity (**********);Shuffle Status (â‡„))
  return %t
}
alias donpthlp {
  var %x = 1, %tgs = $nptags, %t = $numtok(%tgs,32), %tgh = $npthlp, %dt
  while (%x <= %t) { var %tg = $gettok(%tgs,%x,32), %dt = $addtok(%dt,%tg $iif($len(%tg) <= 7 || %tg == .artist.,$str($chr(9),2),$chr(9)) - $gettok(%tgh,%x,59),13) | inc %x }
  return %dt
}
;-- Just something to be able to test the lookup outputs.. space seperated list...
alias lookupsamples { return spotify:track:13J55aSk2MNd4wTR8g9wwX spotify:track:0PN8rUVGoFO6n7ZYt4H9NF spotify:track:4pWLh2rpIwawP5ExSwvV1V spotify:track:13J55aSk2MNd4wTR8g9wwX }

;--------------------------------------------------------------------
;-- check for, store and/or run the spotify application..
;-- "%AppData%\Spotify\Spotify.exe", %AppData% refers to the current users Application Data folder.
;-- By default, this is C:\Documents and Settings\<user>\Application Data for Windows 2000/XP.
;-- For Windows Vista and Windows 7 it is C:\Users\<user>\AppData\Roaming or C:\Users\<user>\AppData\Local.
;-- if $com is available, and you know, not locked..
alias gtappdata {
  if ($lock(com)) { return $false } | var %x = $ticks, %cm = $+($ticks,.,%x), %f = $+(%cm,.txt)
  if ($com(%cm)) { .comclose %cm } | .comopen %cm WScript.Shell | if ($comerr) { return $false }
  .comclose %cm $com(%cm,run,1,bstr*,% $+ comspec% /c echo  $+(%,AppData%) > %f,uint,0,bool,true)
  var %m = $iif($read(%f,n,1) != $null,$v1,$false) | .remove %f | return %m
}
alias spotifyapp {
  if ((!$exists($sptset(main,spotifyapp))) || ($1 == set)) {
    var %apdt = $gtappdata, %i = Do you want to set the Spotify application path? Doing so helps. I promise.
    var %i = $+(%i,$chr(32),I'm sure it's around here somewhere... ,$crlf,Normally it's in: $iif(%apdt,%apdt $+ \Spotify\,$+(%,AppData%)))
    if ((%apdt) && ($exists($+(%apdt,\Spotify\Spotify.exe)))) { sptset main spotifyapp $qt($+(%apdt,\Spotify\Spotify.exe)) }
    elseif (($input(%i,yq,Spotify path not set...)) && ($sfile($iif(%apdt,%apdt,C:) $+ \Spotify\Spotify.exe,Select your spotify.exe location...))) { sptset main spotifyapp $qt($v1) }
  }
  if ($exists($sptset(main,spotifyapp))) { $iif($1 == run,run,return) $qt($sptset(main,spotifyapp)) $2- }
  else { ircifecho 04Error: Spotify Application path is not stored... might should add it, you know, from the settings dialog.. maybe. }
  return $exists($sptset(main,spotifyapp))
}

;-- dll calls and stuffs...
alias ircifdll {
  var %df = $qt($sptset(main,dllpath))
  if ($1 == unload) { ircifecho DLL Unloaded $+ $iif(!$sptelltimer,.,$chr(44) Auto Display timer halted.) | sptelltimer 0 | dll -u %df | return $true }
  if ($isid) { return $iif($prop == call,$dllcall(%df,$1,$$2,$iif($3,$3-,.)),$dll(%df,$$1,$iif($2,$2-,.))) }
  else { dll %df $$1 $2- }
}

;-- Send data to spotify..
alias spopenlnk {
  if ($1) {
    if ($spotistat) { dde -e Spotify OpenLink $1- }
    else {
      var %em = Spotify does not seem to be running, start it now? $str($crlf,2) This dialog will self-destruct in 5 Seconds.
      if ($input(%em,yhk5,Spotify not running...)) { spotifyapp run | .timer.ircify.sptrun -io 20 10 spreopenlnk $1- }
      else { spotistat text }
    } 
  }
}
alias spreopenlnk { if ($spotistat) { .timer.ircify.sptrun off | spopenlnk  $1- } }

;-- TODO: Work this some more...
;-- the main script+dll version return...
alias ircifvers { return $+($ircifvern,-,$regsubex($ircifdll(Version),/Lib:(.+?)Dll:(.+?)-.*/,\1\2)) }
alias ircifversf { return $+($ircifvern,-,$ircifdll(Version)) }

;-- spotify app status: 0 not started - 1 playing - 2 paused
alias spotistat {
  if ($hget(ircify.tmp,status) == $null) {
    hadd -mu1 ircify.tmp status $ircifdll(ChkStatus)
  }
  var %ret = $hget(ircify.tmp,status)
  var %ret = $iif($1 == text,$replace(%ret,0,04Not Running,1,03Playing,2,07Paused),%ret)
  if ($isid) { return %ret } | ircifecho Spotify Status: %ret
}

;-- check track change: 0 no change - 1 changed - (D5C4BBC8 - paused?)
alias spotntrk { return $ircifdll(ChkTrack) }
;-- equalify plugin status: 0 not loaded - 1 loaded
;-- (currently not really usable..)
alias equalistat { return $ircifdll(IsEqualify) }
alias spotsplit {
  sptset main spotsplt $iif($1 == on,1,0)
  ircifecho Spotify url/uri link split: $iif($1 == on,03Enabled,04Disabled)
}
alias spoutp { sptset main output $$1 $2- | sptset outputs $sha1($1-) $1- }
alias splook { sptset main searchout $$1 $2- | sptset searchout $sha1($1-) $1- }

;--------------------------------------------------------------------
;---------- Now Playing ----------
;-- you break it, you bought it.
alias sptell {
  if ($spotistat == 1) {
    hadd -m ircify.tmp ccid $cid
    if ($1) { hadd -m ircify.tmp tmptell $1- }
    if (($isid) && ($prop == strip)) { hadd -m ircify.tmp strip 1 }
    set %ircify.output $sptset(main,output) | noop $ircifdll(sptellout,NowPlaying).call
  }
  else { hadd -m ircify.tmp astat $spotistat(text) | spotistat text }
}

alias sptellout {
  if (%ircify.data) {
    var %opd = $iif($hget(ircify.tmp,strip) || $sptset(main,stripout),$strip(%ircify.data),%ircify.data)
    if ($sptset(main,spotsplt)) { var %opd = $spotbb(%opd) }
    var %opt = $iif($hget(ircify.tmp,tmptell),$v1,$sptset(main,outputtype)), %owt = $window($gettok(%opt,2-,32)).type
    var %op = $iif($hget(ircify.tmp,auto),$v1,$iif($hget(ircify.tmp,tmptell),$v1,$sptset(main,outputtype)))
    ;if ($dialog(ircify)) { did -ra ircify 87 $iif($len($strip(%opd)) <= 130,$strip(%opd),$left($strip(%opd),125) ...) }
    if (%op == listed) { spotispam $gettok(%opt,1,32) %opd }
    else {
      var %opt = $iif(!$istok(channel query,%owt,32),$replace(%opt,msg,echo,describe,echo),%opt)
      var %opt = $replace(%opt,Status Window,-a), %ch = $gettok(%opt,-1,32)
      scid $hget(ircify.tmp,ccid) | %opt $iif(%ch ischan && c isincs $chan(%ch).mode,$strip(%opd),%opd)
    }
  }
  unset %ircify.data %ircify.output | if ($hget(ircify.tmp)) { hfree ircify.tmp }
}
alias spotispam {
  var %x = 1, %ot = $$1, %od = $2-
  while ($scon(%x).status == connected) {
    if ($sptset(npokspam,$scon(%x).network).n) {
      scid $scon(%x).cid | var %i = 1, %ch = $replace($sptset(npokspam,$scon(%x).network).n,$chr(44),$chr(32))
      while ($gettok(%ch,%i,32)) { var %c = $v1 | if (%c ischan) { %ot %c $iif(c isincs $chan(%c).mode,$strip(%od),%od) } | inc %i } | scid -r
    }
    inc %x
  }
}
alias sptelltimer {
  if ($isid) { return $timer(.ircify.sptauto) }
  if ($2 == set) {  sptset npauto autodisplay $1 }
  .timer.ircify.sptauto $iif($1 == 1,-io 0 $sptset(npauto,autotime) sptellauto,off)
}
alias sptellauto {
  if ($spotntrk) { hadd -m ircify.tmp auto $sptset(npauto,autoaction) | sptell $1- }
  elseif (($hget(ircify.tmp,astat) != $spotistat(text)) && ($spotistat != 1)) { hadd -m ircify.tmp astat $spotistat(text) | spotistat text }
}

;-----------------
;-- scripters, don't call this alot.. causes slight hang while doing the lookup..
;-- might should think of better way, maybe? *shrug*
;-- used in the main settings dialog for testing 'np' output formats...
alias sptret {
  if ($spotistat == 1) {
    set %ircify.output $iif($1,$1-,$sptset(main,output))
    var %t = $ircifdll(NowPlaying), %r = %ircify.data
    unset %ircify.data %ircify.output | return %r
  }
  return $false
}

;--------------------------------------------------------------------
;---------- Lookups ----------
;-- spotify:artist:ID - spotify:album:ID
;-- spotify:user:<user>:starred - spotify:user:<user>:playlist:ID

alias lookqueue {
  var %h = ircify.lookq, %sh = $sha1($$1)
  if (!$hget(%h)) { .timer.ircify.lookq 1 1 lktell $cid $1 $2- }
  if (!$hfind(%h,$+(lookq.*.,%sh),0,w).item) {
    hadd -m %h $+(lookq.,$calc($hfind(%h,lookq.*.*,0,w).item + 1),.,%sh) $cid $1 $2-
  }
}
alias lktell {
  if ($regex($2,$spotrx)) {
    var %t = $regml(1), %d = $regml(2)
    ;-- only song track lookups are currently available, sorry.. =(
    if (%t == track) {
      var %uri = $+(spotify:,$replace(%t,/,:),:,%d)
      if ($3) { hadd -m ircify.tmpl tmptell $3- }
      if (($isid) && ($prop == strip)) { hadd -m ircify.tmpl strip 1 }
      hadd -m ircify.tmpl cid $1 | hadd -m ircify.lookq current %uri
      set %ircify.luoutput $sptset(main,searchout) | noop $ircifdll(lktellout,Lookup,%uri).call
    }
  }
}
alias lktellout {
  var %h = ircify.lookq
  if (%ircify.ludata) {
    var %opd = $iif($hget(ircify.tmpl,strip) || $sptset(lookauto,stripout),$strip(%ircify.ludata),%ircify.ludata)
    var %opt = $iif($hget(ircify.tmpl,tmptell),$v1,$sptset(lookauto,autocoutput)), %owt = $window($gettok(%opt,2-,32)).type
    var %opt = $iif(!$istok(channel query,%owt,32),$replace(%opt,msg,echo,describe,echo),%opt)
    var %opt = $replace(%opt,Status Window,-a), %ch = $gettok(%opt,-1,32)
    scid $hget(ircify.tmpl,cid) | %opt $iif(%ch ischan && c isincs $chan(%ch).mode,$strip(%opd),%opd)
  }
  unset %ircify.ludata %ircify.luoutput | if ($hget(ircify.tmpl)) { hfree ircify.tmpl }
  if ($hfind(%h,$+(lookq.*.,$sha1($hget(%h,current))),1,w)) { hdel %h $v1 }
  if ($hfind(%h,lookq.*.*,1,w).item) { .timer.ircify.lktell 1 0 lktell $hget(%h,$v1) }
  elseif ((!$hfind(%h,lookq.*.*,1,w).item) && ($hget(%h))) { hfree %h }
}

alias lktret {
  if ($regex($1,$spotrx)) {
    var %t = $regml(1), %d = $regml(2)
    ;-- only song track lookups are currently available, sorry.. =(
    if (%t == track) {
      var %uri = $+(spotify:,$replace(%t,/,:),:,%d) | set %ircify.luoutput $iif($2,$2-,$sptset(main,searchout))
      var %t = $ircifdll(Lookup,%uri), %r = %ircify.ludata | unset %ircify.ludata %ircify.luoutput | return %r
    }
  }
  return $false
}
;-----------------

;--------------------------------------------------------------------
;-- Dialogs...

;-- Simple small option dialog, used for various things via hidden tabs...
alias optsify {
  var %dt = $replace($1-,$chr(32),.)
  if ($dialog(ircifyopts. $+ %dt)) { dialog -v ircifyopts. $+ %dt }
  else { dialog -mh ircifyopts. $+ %dt ircifyopts }
}

dialog ircifyopts {
  title "ircify :: Spotify for mIRC"
  size -1 -1 382 108
  option pixels
  tab "Tab 1", 1, 7 153 368 95
  text "ircify :: Spotify for mIRC", 24, 7 13 367 16, tab 1 center
  link "http://equalify.me/", 25, 7 36 100 16, tab 1
  link "http://equalify.me/ircify/", 26, 107 36 125 16, tab 1
  link "irc://irc.equalify.me/equalify/", 27, 232 36 140 16, tab 1
  text "Use the links above to get more information. - Enjoy.", 28, 7 54 367 16, tab 1 center
  tab "Tab 2", 2
  text "", 14, 100 53 274 16, group tab 2 center
  radio "Always Ask", 8, 7 13 90 20, tab 2
  radio "Load it...", 9, 7 35 90 20, tab 2
  radio "Look it up", 10, 7 57 90 20, tab 2
  radio "Load && Store", 11, 7 79 90 20, tab 2
  check "Remember Selected", 12, 107 79 115 20, tab 2 left
  text "", 13, 100 13 274 35, tab 2 center
  tab "Tab 3", 3
  text "Settings", 18, 199 32 50 16, tab 3
  text "From", 15, 15 32 50 16, tab 3
  button "EQ Links", 22, 7 76 70 24, tab 3
  button "Delete", 20, 303 50 70 23, tab 3
  button "Delete", 17, 119 50 70 23, tab 3
  combo 16, 7 51 110 100, tab 3 drop
  link "http://equalify.me/", 23, 106 80 95 16, tab 3
  combo 19, 191 51 110 100, tab 3 drop
  text "Equalify - An equalizer for Spotify", 21, 7 13 367 16, tab 3 center
  tab "Tab 4", 4
  text "NP temporary quick display settings...", 33, 7 13 198 16, tab 4
  check "Auto Display", 42, 216 11 85 20, tab 4
  check "$stripped", 34, 304 11 70 20, tab 4
  box "Send to...", 38, 7 30 205 40, group tab 4
  radio "Listed Channels", 35, 13 44 100 20, tab 4
  radio "Active Window", 36, 115 44 95 20, tab 4
  box "Send as...", 37, 210 30 164 40, group tab 4
  radio "/echo", 30, 216 44 50 20, tab 4
  radio "/msg", 31, 268 44 50 20, tab 4
  radio "/me", 32, 320 44 50 20, tab 4
  button "Settings", 39, 7 76 70 24, tab 4
  button "Reload", 43, 157 76 70 24, tab 4
  tab "Tab 5", 5
  tab "Tab 6", 29
  tab "Tab 7", 40
  tab "Tab 8", 41
  button "Cancel", 6, 304 76 70 24, default cancel
  button "Continue", 7, 231 76 70 24
}

on *:dialog:ircifyopts.*:*:*: {
  var %sf = $ircifysetf, %dn = $dname, %de = $devent
  var %typ = $gettok(%dn,2,46), %hlt = $iif($gettok(%dn,3,46),$v1,$null)
  if (%de == init) {
    if (%typ == hotlink) {
      dialog -t %dn ircify :: $iif(%hlt == eq,Equalify,Spotify) Hotlinks
      .timer.ircify.did. [ $+ [ %dn ] ] 1 0 did -f %dn 2
      var %tr = $lookupsamples, %eq = spotify:eq:CA886579898
      did $iif(%hlt == eq,-v,-h) %dn 11 | did -ra %dn 10 $iif(%hlt == eq,Store it..,Look it up)
      if ($hget(ircify.hlink,uri)) { did -h %dn 8 | did -c %dn 9 | did -era %dn 14 $+([ ,$chr(32),$v1,$chr(32), ]) | did -ra %dn 13 It would seem $iif(%hlt == eq,an Equalify,a Spotify) uri/url has been mashed upon, which course of action would you like to be takin'? }
      else { did -cb %dn 12 | did -c %dn 8 | did -bra %dn 14 eg: $iif(%hlt == eq,%eq,$gettok(%tr,$r(1,$numtok(%tr,32)),32)) | did -ra %dn 13 What would you like to happen when you mash upon $iif(%hlt == eq,an Equalify,a Spotify) uri/url hotlink? }
    }
    elseif (%typ == equalify) {
      dialog -t %dn ircify :: Equalify
      .timer.ircify.did. [ $+ [ %dn ] ] 1 0 did -f %dn 3
      var %x = 1 | did -ra %dn 6 Close | did -ra %dn 7 Load
      while ($ini(%sf,equalify,%x)) { if ($readini(%sf,equalify,$ini(%sf,equalify,%x)) != None) { did -a %dn 16 $ini(%sf,equalify,%x) } | inc %x }
      did -c %dn 16 1 | didtok %dn 19 32 $readini(%sf,equalify,$did(%dn,16).text) | did -c %dn 19 1
    }
    elseif (%typ == qspam) {
      dialog -t %dn ircify :: Quick Display
      dialog -s %dn 15 50 $dialog(%dn).cw $dialog(%dn).ch
      .timer.ircify.did. [ $+ [ %dn ] ] 1 0 did -f %dn 4
      did -ra %dn 6 Close | did -ra %dn 7 Display
      if ($sptset(npauto,autodisplay)) { did -c %dn 42 }
      var %opty = $gettok($sptset(main,outputtype),1,32)
      did -c %dn $iif(%opty == echo,30,$iif(%opty == msg,31,32))
      did -c %dn $iif($sptset(npauto,autoaction) == listed,35,36)
      if ($sptset(main,stripout)) { did -c %dn 34 }
    }
  }
  if (%de == sclick) {
    if ($did == 6) { if ($hget(ircify.tmpl)) { hfree ircify.tmpl } | if ($hget(ircify.hlink)) { hfree ircify.hlink } }
    elseif ($did == 7) {
      if (%typ == equalify) { spopenlnk $+(spotify:eq:,$$did(%dn,19).text) }
      elseif (%typ == hotlink) {
        var %s = $iif($did(%dn,9).state,9,$iif($did(%dn,10).state,10,$iif($did(%dn,11).state,11,$null)))
        var %eqr = $replace(%s,9,load,10,store,11,stald), %hlr = $replace(%s,9,load,10,lookup,11,$null)
        if ($did(%dn,12).state) { sptset hotlinks $iif(%hlt == eq,eqlinkaction,hlinkaction) $iif(%hlt == eq,%eqr,%hlr) }
        if ($hget(ircify.hlink,uri)) {
          var %uri = $hget(ircify.hlink,uri), %d = $gettok(%uri,-1,58)
          if (($did(%dn,9).state) || (($did(%dn,11).state) && (%hlt == eq))) { spopenlnk %uri }
          if (($did(%dn,10).state) || (($did(%dn,11).state) && (%hlt == eq))) {
            if (%hlt == eq) {
              var %n = HotLinked, %eqs = $sptset(equalify,%n)
              if ((!$istok(%eqs,%d,32)) && ($len(%d) == 11)) {
                sptset equalify %n $remtok($addtok(%eqs,%d,32),None,1,32)
                ircifecho Equalify settings from $+(,%n,) have been stored -> $+(,%uri,)
              }
            }
            else { lookqueue %uri echo $active }
          }
        }
        if ($hget(ircify.tmpl)) { hfree ircify.tmpl } | if ($hget(ircify.hlink)) { hfree ircify.hlink } | dialog -x %dn
      }
      elseif (%typ == qspam) {
        if ($did(%dn,34).state) { hadd -m ircify.tmp strip 1 }
        if ($did(%dn,35).state) { hadd -m ircify.tmp auto listed }
        sptell $iif($did(%dn,30).state,echo,$iif($did(%dn,31).state,msg,describe)) $active
      }
    }
    elseif ($did == 16) { did -r %dn 19 | didtok %dn 19 32 $readini(%sf,equalify,$did(%dn,$did).text) | did -c %dn 19 1 }
    elseif ($did == 17) {
      sptset equalify $did(%dn,1).text
      did -d %dn 16 $did(%dn,16).sel | did -c %dn 16 1
      didtok %dn 19 32 $readini(%sf,equalify,$did(%dn,16).text)
    }
    elseif ($did == 19) { did -ra %dn 21 Equalify - $+(spotify:eq:,$$did(%dn,19).text) }
    elseif ($did == 20) {
      var %eqs = $sptset(equalify,$did(%dn,16).text)
      sptset equalify $did(%dn,16).text $remtok(%eqs,$did(%dn,19).text,0,32)
      did -d %dn 19 $did(%dn,19).sel
      if ($did(%dn,19).lines <= 0) {
        did -d %dn 16 $did(%dn,16).sel | did -c %dn 16 1
        didtok %dn 19 32 $readini(%sf,equalify,$did(%dn,16).text)
      }
    }
    elseif ($did == 22) { optsify hotlink.eq }
    elseif ($istok(23 25 26 27,$did,32)) { url $did(%dn,$did).text }
    ;-- set quick display as actual settings, or just temp? commented for now..
    ;elseif ($istok(30 31 32,$did,32)) { sptset main outputtype $iif($did(%dn,30).state,echo,$iif($did(%dn,31).state,msg,describe)) $!active }
    ;elseif ($did == 34) { sptset main stripout $did(%dn,$did).state }
    ;elseif ($istok(35 36,$did,32)) { sptset npauto autoaction $replace($did,35,listed,36,active) }
    ;--
    elseif ($did == 39) { ircify }
    elseif ($did == 42) { sptelltimer $iif($did(%dn,$did).state,1,0) }
    elseif ($did == 43) {
      did -u %dn 30,31,32,34,35,36,42
      if ($sptset(npauto,autodisplay)) { did -c %dn 42 }
      var %opty = $gettok($sptset(main,outputtype),1,32)
      did -c %dn $iif(%opty == echo,30,$iif(%opty == msg,31,32))
      did -c %dn $iif($sptset(npauto,autoaction) == listed,35,36)
      if ($sptset(main,stripout)) { did -c %dn 34 }
    }
  }
  if (%de == close) { .timer.ircify*. [ $+ [ %dn ] ] off }
}

;--------------------------------------------------------------------
;--- main ircify settings dialog
alias ircify { if ($ckircify) { if ($dialog(ircify)) { dialog -v ircify } | else { dialog -mh ircify ircify } } }

dialog ircify {
  title "ircify :: Settings"
  size -1 -1 750 403
  option pixels
  text "ircify :: Spotify for mIRC", 87, 6 12 734 16, disable center
  tab "Now Playing", 9, 6 32 734 180
  combo 39, 88 150 130 100, tab 9 sort edit drop
  box "np quick command", 44, 514 155 223 51, tab 9
  text "", 10, 27 65 365 16, disable tab 9 nowrap
  text "Output as:", 37, 448 65 55 16, group tab 9 right
  radio "/msg", 20, 562 62 50 20, tab 9
  radio "/echo", 21, 508 62 50 20, tab 9
  radio "/me", 22, 616 62 50 20, tab 9
  check "$strip", 61, 670 62 50 20, tab 9
  button "Update", 42, 295 150 70 20, tab 9
  button "Delete", 43, 221 150 70 20, tab 9
  text "Channels", 41, 27 179 55 16, tab 9 center
  edit "", 40, 88 176 278 21, tab 9 autohs
  button "<-  Load  -", 33, 369 176 70 20, tab 9
  button "Test", 45, 470 117 60 20, tab 9
  button "Add", 31, 534 117 60 20, tab 9
  button "Set", 47, 597 117 60 20, tab 9
  button "Delete", 30, 660 117 60 20, tab 9
  button "Set", 51, 660 176 60 20, tab 9
  check "Auto Display", 28, 27 117 95 20, group tab 9
  radio "Active Window", 49, 213 117 95 20, tab 9
  text "check every", 4, 311 120 64 16, tab 9 right
  text "seconds", 65, 411 120 45 16, tab 9
  radio "Listed Below", 46, 125 117 85 20, tab 9
  edit "10", 64, 378 118 30 21, tab 9 center
  combo 25, 534 176 120 100, tab 9 edit drop
  combo 2, 23 87 700 24, tab 9 sort edit drop
  text "Networks", 38, 27 152 55 16, tab 9 center
  link "more...", 36, 397 65 44 16, tab 9
  tab "Auto Lookup", 66
  box "flood delay (auto lookup only)", 67, 514 155 223 51, tab 66
  text "Output as:", 50, 448 65 55 16, group tab 66 right
  radio "/echo", 13, 508 62 50 20, tab 66
  radio "/msg", 18, 562 62 50 20, tab 66
  radio "/me", 19, 616 62 50 20, tab 66
  check "$strip", 62, 670 62 50 20, tab 66
  combo 23, 23 87 700 24, tab 66 sort edit drop
  check "Channels", 3, 188 117 70 20, tab 66
  radio "All Channels", 57, 349 117 85 20, tab 66
  button "Set", 48, 597 117 60 20, tab 66
  text "stop at", 15, 521 178 45 16, tab 66 center
  edit "5", 11, 568 176 30 21, tab 66 center
  edit "60", 14, 647 176 30 21, tab 66 center
  text "within", 12, 600 179 45 16, tab 66 center
  text "seconds", 16, 679 179 50 16, tab 66 center
  check "Auto Lookup", 17, 27 117 110 20, group tab 66
  check "PMs", 8, 140 117 45 20, tab 66
  radio "Listed Below", 58, 261 117 85 20, tab 66
  button "<-  Load  -", 68, 369 176 70 20, tab 66
  button "Delete", 29, 660 117 60 20, tab 66
  button "Delete", 53, 221 150 70 20, tab 66
  button "Update", 54, 295 150 70 20, tab 66
  button "Test", 56, 470 117 60 20, tab 66
  button "Add", 32, 534 117 60 20, tab 66
  combo 55, 88 150 130 100, tab 66 sort edit drop
  text "Networks", 59, 27 152 55 16, tab 66 center
  text "Channels", 60, 27 179 55 16, tab 66 center
  edit "", 52, 88 176 278 21, tab 66 autohs
  text "", 24, 27 65 402 16, disable tab 66 nowrap
  tab "Misc. Settings", 35
  box "Set File Paths...", 78, 23 69 427 80, tab 35
  text "ircify.dll", 70, 27 90 55 16, tab 35 center
  edit "", 69, 88 87 278 21, tab 35 autohs
  button "Set", 71, 369 87 70 20, tab 35
  text "Spotify", 73, 27 119 55 16, tab 35 center
  edit "", 72, 88 117 278 21, tab 35 autohs
  button "Set", 74, 369 117 70 20, tab 35
  box "Default Hotlink Action For...", 79, 448 69 275 80, tab 35
  text "Spotify", 80, 457 90 50 16, tab 35 center
  button "Set", 85, 511 87 70 20, tab 35
  combo 81, 457 117 125 100, tab 35 drop
  text "Equalify", 83, 588 90 50 16, tab 35 center
  button "Set", 86, 642 87 70 20, tab 35
  combo 82, 588 117 125 100, tab 35 drop
  button "Equalify", 7, 26 165 70 24, tab 35
  box "Preview", 26, 6 215 734 145
  box "Preview Area", 1, 23 235 700 110
  link "http://www.equalify.me/ircify/", 27, 305 364 150 16
  link "irc://irc.equalify.me/equalify/", 34, 309 383 140 16
  button "Save", 5, 589 370 70 24, ok
  button "Close", 6, 664 370 70 24, cancel
  text "", 75, 9 375 200 16, disable
}


on *:dialog:ircify:*:*: {
  var %f = $ircifysetf, %pw = @ircify
  var %dn = $dname, %de = $devent
  if (%de == init) {
    window -hk0do +dL %pw 0 0 0 0
    dll $qt($qt($sptset(main,dllpath))) dock $window(%pw).hwnd
    if (!$eqhlsh) { did -h %dn 7 }
    did -ra %dn 75 $+(v.,$ircifvers)
    did -ra %dn 10 $+([,$chr(32),$replace($nptags,$chr(32),$+($chr(32),|,$chr(32))),$chr(32),])
    var %x = 1 | did -a %dn 2 $sptset(main,output)
    while ($ini(%f,outputs,%x)) {
      var %c = $r2ini($readini(%f,outputs,$ini(%f,outputs,%x)))
      if (!$didwm(%dn,2,%c)) { did -a %dn 2 %c }
      inc %x
    }
    did -c %dn 2 $didwm(%dn,2,$sptset(main,output))
    var %x = 1, %opty = $gettok($sptset(main,outputtype),1,32)
    did -c %dn $iif(%opty == echo,21,$iif(%opty == msg,20,22))
    if ($sptset(main,stripout)) { did -c %dn 61 }

    if ($sptset(npauto,autodisplay)) { did -c %dn 28 }
    did $iif($did(%dn,28).state,-v,-h) %dn 46,49,4,64,65
    did -ra %dn 64 $sptset(npauto,autotime)
    while ($ini(%f,npokspam,%x)) {
      var %c = $ini(%f,npokspam,%x)
      if (!$didwm(%dn,39,%c)) { did -a %dn 39 %c }
      inc %x
    }
    did -c %dn 39 1 | did -ra %dn 40 $sptset(npokspam,$did(%dn,39).text)
    did -c %dn $iif($sptset(npauto,autoaction) == listed,46,49)
    var %x = 2 | did -a %dn 25 sptell
    while (%x <= 12) {
      if ((!$isalias($+(F,%x))) || ($+(F,%x) == $sptset(main,npcmd))) { did -a %dn 25 $+(F,%x) }
      inc %x
    }
    if (!$didwm(%dn,25,$sptset(main,npcmd))) { did -a %dn 25 $sptset(main,npcmd) }
    did -c %dn 25 $didwm(%dn,25,$sptset(main,npcmd))
    var %x = 1, %ckc = $cksptell($did(%dn,25).text)
    did -ra %dn 24 $+([,$chr(32),$replace($luptags,$chr(32),$+($chr(32),|,$chr(32))),$chr(32),])
    did -a %dn 23 $sptset(main,searchout)
    while ($ini(%f,searchout,%x)) {
      var %c = $r2ini($readini(%f,searchout,$ini(%f,searchout,%x)))
      if (!$didwm(%dn,23,%c)) { did -a %dn 23 %c }
      inc %x
    }
    did -c %dn 23 $didwm(%dn,23,$sptset(main,searchout))
    var %opty = $gettok($sptset(lookauto,autocoutput),1,32)
    did -c %dn $iif(%opty == echo,13,$iif(%opty == msg,18,19))
    if ($sptset(lookauto,stripout)) { did -c %dn 62 }
    if ($sptset(lookauto,autolookup)) { did -c %dn 17 }
    did $iif($did(%dn,17).state,-v,-h) %dn 8,3,58,57
    if ($sptset(lookauto,chanlook)) { did -c %dn 3 }
    if ($sptset(lookauto,pmlook)) { did -c %dn 8 }
    did -ra %dn 11 $sptset(lookauto,alfldamnt)
    did -ra %dn 14 $sptset(lookauto,alfldtime)
    var %x = 1
    while ($ini(%f,spoklook,%x)) {
      var %c = $ini(%f,spoklook,%x)
      if (!$didwm(%dn,55,%c)) { did -a %dn 55 %c }
      inc %x
    }
    did -c %dn 55 1 | did -ra %dn 52 $sptset(spoklook,$did(%dn,55).text)
    did -c %dn $iif($sptset(lookauto,lookaction) == listed,58,57)
    noop $doircifyprev(%pw,NP Layout Preview,$did(%dn,2).text)
    did -ra %dn 69 $sptset(main,dllpath)
    did $iif($exists($qt($sptset(main,dllpath))),-b,-e) %dn 69
    did -ra %dn 71 $iif($exists($qt($sptset(main,dllpath))),Change,set)
    did -ra %dn 72 $sptset(main,spotifyapp)
    did $iif($exists($sptset(main,spotifyapp)),-b,-e) %dn 72
    did -ra %dn 74 $iif($exists($sptset(main,spotifyapp)),Change,set)
    didtok %dn 81 58 Always Ask:Load it...:Look it up
    didtok %dn 82 58 Always Ask:Store it...:Load it...:Store & Load
    did -c %dn 81,82 1
  }
  elseif (%de == edit) {
    if ($istok(2 23,$did,32)) { noop $doircifyprev(%pw,$replace($did,23,Lookup Preview,2,NP Layout Preview),$did(%dn,$did).text) }
    elseif ($did == 25) { noop $doircifyprev(%pw,Now Playing Quick Command,$gettok($cksptell($did(%dn,$did).text),2-,32)).single }
    elseif ($istok(39 55,$did,32)) { did -ra %dn $replace($did,39,40,55,52) $sptset($replace($did,39,npokspam,55,spoklook),$did(%dn,$did).text).n }
    elseif ($did == 64) {
      var %n = $did(%dn,$did).text
      if ((%n !isnum) || (%n  < 5)) { noop $doircifyprev(%pw,Auto Display (Error):,You entered a value of $qt(%n). You need a valid number value larger than Five (5)).single }
      else { noop $doircifyprev(%pw,Auto Display:,Check for song changes every $duration(%n)).single }
    }
  }
  elseif (%de == sclick) {
    if ($did == 5) {
      sptset main output $did(%dn,2).text
      sptset outputs $sha1($did(%dn,2).text) $did(%dn,2).text
      sptset main searchout $did(%dn,23).text
      sptset searchout $sha1($did(%dn,23).text) $did(%dn,23).text

      sptset lookauto alfldamnt $did(%dn,11).text
      sptset lookauto alfldtime $did(%dn,14).text

      var %n = $iif($did(%dn,64).text,$v1,10)
      if ((%n isnum) && (%n  >= 5)) { sptset npauto autotime %n }
      else { noop $doircifyprev(%pw,Auto Display (Error):,You entered a value of $qt(%n). You need a valid number value larger than Five (5)).single | did -raf %dn 64 10 | halt }

      var %ckc = $cksptell($did(%dn,25).text), %iscmd = $gettok(%ckc,1,32)
      if (%iscmd) {
        var %ccmd = $sptset(main,npcmd), %cmd = $remove($did(%dn,25).text,$chr(32))
        var %cmd = $lower($iif($left(%cmd,1) == /,$right(%cmd,-1),%cmd))
        if (%cmd) {
          if ((%ccmd != %cmd) && (%ccmd != sptell)) { alias %ccmd }
          if (%cmd != sptell) { alias %cmd sptell }
          sptset main npcmd %cmd
        }
      }
      else { noop $input($gettok(%ckc,2-,32),ohd,ERROR) | did -f %dn 25 | halt }
      noop $input(Your ircify settings have been saved.,oik2,Settings Saved.)
      ircifecho 03Settings have been saved/updated.
    }
    elseif ($istok(3 8,$did,32)) {
      if ($did == 3) { did $iif($did(%dn,$did).state,-e,-b) %dn 57,58 }
      sptset lookauto $replace($did,3,chanlook,8,pmlook) $did(%dn,$did).state
    }
    elseif ($istok(2 23,$did,32)) { noop $doircifyprev(%pw,$replace($did,23,Lookup Preview,2,NP Layout Preview),$did(%dn,$did).text) }
    elseif ($did == 7) { optsify equalify }
    elseif ($istok(9 66,$did,32)) { noop $doircifyprev(%pw,$replace($did,66,Lookup Preview,9,NP Layout Preview),$did(%dn,$replace($did,9,2,66,23)).text) }
    elseif ($did == 63) { noop $doircifyprev(%pw,$chr(160),Welcome to ircify - Spotify for mIRC).single }
    elseif ($istok(13 18 19,$did,32)) {
      sptset lookauto autocoutput $iif($did(%dn,13).state,echo,$iif($did(%dn,18).state,msg,describe)) $!chan
      sptset lookauto autopoutput $iif($did(%dn,13).state,echo,$iif($did(%dn,18).state,msg,describe)) $!nick
    }
    elseif ($did == 17) { sptset lookauto autolookup $did(%dn,$did).state | did $iif($did(%dn,17).state,-v,-h) %dn 8,3,58,57 }
    elseif ($istok(20 21 22,$did,32)) { sptset main outputtype $iif($did(%dn,21).state,echo,$iif($did(%dn,20).state,msg,describe)) $!active }
    elseif ($did == 25) { var %ckc = $cksptell($did(%dn,$did).text) | noop $doircifyprev(%pw,Now Playing Quick Command,$gettok(%ckc,2-,32)).single }
    elseif ($did == 27) { url $did(%dn,$did).text }
    elseif ($did == 28) { sptelltimer $iif($did(%dn,$did).state,1,0) set | did $iif($did(%dn,28).state,-v,-h) %dn 46,49,4,64,65 }
    elseif ($istok(29 30,$did,32)) {
      var %td = $replace($did,29,searchout,30,output)
      var %cd = $replace($did,29,23,30,2), %op = $$did(%dn,%cd).text
      sptset $replace($did,29,searchout,30,outputs) $sha1(%op)
      did -d %dn %cd $did(%dn,%cd).sel
      if ($did(%dn,%cd).lines <= 0) { did -a %dn %cd $sptset(main,%td) }
      if ($didwm(%dn,%cd,$sptset(main,%td))) { did -c %dn %cd $v1 }
      else { did -c %dn %cd 1 }
    }
    elseif ($istok(31 32 47 48,$did,32)) {
      var %cd = $replace($did,31,2,32,23,47,2,48,23), %dt = $$did(%dn,%cd).text
      var %op = $replace($did,31,outputs,32,searchout,47,outputs,48,searchout)
      sptset %op $sha1(%dt) %dt | if (!$didwm(%dn,%cd,%dt)) { did -a %dn %cd %dt }
      if ($istok(47 48,$did,32)) { sptset main $replace(%op,outputs,output) %dt }
    }
    elseif ($istok(33 68,$did,32)) {
      var %cd = $replace($did,33,39,68,55), %td = $replace($did,33,40,68,52)
      ;-- wicked awesomeness from PennyBreed, don't question it.
      var %x = 1 | while ($scon(%x)) { var %n = $addtok(%n,$scon(%x).network,44) | inc %x }
      var %net = $input( $+ [ $+(Select a Network to load.,$chr(44),qm,$chr(44),Networks,$chr(44),$network,$chr(44),%n) ] $+ )
      if (%net) {
        scid $scon($findtok(%n,%net,44)).cid
        if (!$didwm(%dn,%cd,%net)) { did -a %dn %cd %net }
        var %x = 1 | while ($chan(%x)) { var %c = $addtok(%c,$chan(%x),44) | inc %x }
        did -c %dn %cd $didwm(%dn,%cd,%net) | did -ra %dn %td %c
      }
    }
    elseif ($did == 34) { url $did(%dn,$did).text }
    elseif ($did == 36) { tagify }
    elseif ($istok(39 55,$did,32)) { did -ra %dn $replace($did,39,40,55,52) $sptset($replace($did,39,npokspam,55,spoklook),$did(%dn,$did).text).n }
    elseif ($istok(42 54,$did,32)) {
      var %cd = $replace($did,42,39,54,55), %td = $replace($did,42,40,54,52)
      sptset $replace($did,42,npokspam,54,spoklook) $$did(%dn,%cd).text $$did(%dn,%td).text
      if (!$didwm(%dn,%cd,$$did(%dn,%cd).text)) { did -a %dn %cd $$did(%dn,%cd).text }
    }
    elseif ($istok(43 53,$did,32)) {
      var %sps = $replace($did,43,npokspam,53,spoklook)
      var %cd = $replace($did,43,39,53,55), %td = $replace($did,43,40,53,52)
      did -r %dn %td | sptset %sps $$did(%dn,%cd).text | did -d %dn %cd $$did(%dn,%cd).sel
      did -c %dn %cd 1 | did -ra %dn %td $sptset(%sps,$did(%dn,%cd).seltext)
    }
    elseif ($did == 45) {
      var %em = Spotify doesn't seem to be running, start it now maybe, yeah?
      var %np = It would seem Spotify is not playing a song currently, you should maybe have something
      var %np = %np playing before trying to test the output...  I don't know.. just a suggestion.
      if (!$spotistat) { if ($input(%em,yh,Spotify not running...)) { spotifyapp run } }
      elseif ($spotistat == 2) { noop $input(%np,oq,Spotify not playing...) }
      elseif ($spotistat == 1) { noop $doircifyprev(%pw,Preview Of Currently Playing Song,$sptret($$did(%dn,2).text)) }
    }
    elseif ($istok(46 49,$did,32)) { sptset npauto autoaction $replace($did,46,listed,49,active) }
    elseif ($istok(57 58,$did,32)) { sptset lookauto lookaction $replace($did,57,all,58,listed) }
    elseif ($did == 51) {
      var %ckc = $cksptell($did(%dn,25).text), %iscmd = $gettok(%ckc,1,32)
      noop $doircifyprev(%pw,Now Playing Quick Command,$gettok(%ckc,2-,32)).single
      if (%iscmd) {
        var %cmd = $remove($did(%dn,25).text,$chr(32)), %cmd = $lower($iif($left(%cmd,1) == /,$right(%cmd,-1),%cmd))
        var %ccmd = $sptset(main,npcmd)
        if (%cmd) {
          if ((%ccmd != %cmd) && (%ccmd != sptell)) { alias %ccmd }
          if (%cmd != sptell) { alias %cmd sptell }
          sptset main npcmd %cmd
        }
      }
      else { noop $input($gettok(%ckc,2-,32),ohd,ERROR) | did -f %dn 25 }
    }
    elseif ($did == 56) {
      var %tx = Enter your Spotify uri/url to test the lookup output format., %ls = $lookupsamples
      var %rl = $input(%tx,eq,Test uri/url,$gettok(%ls,$r(1,$numtok(%ls,32)),32))
      if ($regex(%rl,$spotrx)) { noop $doircifyprev(%pw,Testing Lookup Format,$lktret(%rl,$did(%dn,23).text)) }
    }
    elseif ($istok(61 62,$did,32)) { sptset $replace($did,61,main,62,lookauto) stripout $did(%dn,$did).state }
    elseif ($did == 71) {
      var %dllf = $sfile($scriptdir $+ ircify.dll,Select ircify.dll)
      if ($exists(%dllf)) { sptset main dllpath $qt(%dllf) }
      did -ra %dn 69 $noqt($sptset(main,dllpath))
      did $iif($exists($qt($sptset(main,dllpath))),-b,-e) %dn 69
      did -ra %dn 71 $iif($exists($qt($sptset(main,dllpath))),Change,set)
    }
    elseif ($did == 74) {
      did -ra %dn 72 $noqt($spotifyapp(set))
      did $iif($exists($sptset(main,spotifyapp)),-b,-e) %dn 72
      did -ra %dn 74 $iif($exists($sptset(main,spotifyapp)),Change,set)
    }
    elseif ($istok(85 86,$did,32)) {
      var %sdp = $replace($did,85,81,86,82), %dps = $did(%dn,%sdp).sel
      var %hlr = $replace(%dps,1,$null,2,load,3,lookup)
      var %eqr = $replace(%dps,1,$null,2,store,3,load,4,stald)
      sptset hotlinks $iif($did == 86,eqlinkaction,hlinkaction) $iif($did == 86,%eqr,%hlr)
    }
  }
  elseif (%de == close) { window -c @ircify }
}

;-- load preview window...
alias doircifyprev { clear $$1 | echo $1 $2 | echo $1  | echo $1 $iif($prop != single,$$3-,) | echo $1 $strip($$3-) }

;-- $cksptell(<cmd>)
alias cksptell {
  var %fkreg = /^(?!^f1$)([cs]?f[1-9][0-2]?)$/ig, %cmd = $remove($1,$chr(32))
  var %cmd = $lower($iif($left(%cmd,1) == /,$right(%cmd,-1),%cmd)), %rt
  if ((%cmd == sptell) || (!%cmd)) { var %rt = $true Use default command "/sptell" }
  elseif (%cmd == f1) { var %rt = $false Function key $qt($upper(%cmd)) is used to open the mIRC help file. }
  elseif (%cmd == $sptset(main,npcmd)) { var %rt = $true Command $qt(/ $+ %cmd) is currently set. }
  elseif ($isalias(%cmd)) {
    if ($regex(%cmd,%fkreg)) { var %rt = $false Function key $qt($upper(%cmd)) is in use. }
    else { var %rt = $false Command $qt(/ $+ %cmd) is in use. }
  }
  else { var %rt = $true $iif($regex(%cmd,%fkreg),Function Key $qt($upper(%cmd)),Command $qt(/ $+ %cmd)) Available. }
  return %rt
}
;-----------------


alias tagify { if ($dialog(tagify)) { dialog -v tagify } | else { dialog -mh tagify tagify } }

dialog tagify {
  title "ircify :: Tags"
  size -1 -1 312 240
  option pixels
  text "", 1, 8 7 300 198
  button "Close", 2, 231 210 70 24, ok cancel
}

on *:dialog:tagify:*:*: {
  var %dn = $dname, %de = $devent
  if (%de == init) {
    did -ra %dn 1 $donpthlp
  }
}
;--------------------------------------------------------------------
;------------- Other Stuff/Events -------------
alias ircifecho { echo -astn $sptset(main,preftag) $1- }
;-- equalify and spotify uri/url regex match
alias -l spotbb { return $regsubex($1-,/((?:http:\/\/open\.)?spotify(?:\.com)?[:|\/])/ig,$replace(\1,potify,potify)) }
alias -l eqrgx { return /http:\/\/preset.equalify.me\/\?(preset)=([0-9A-Z]{11})/Sig }
alias -l spotrx { return /(?:http:\/\/open\.)?spotify(?:\.com)?[:|\/](eq|track|artist|album|user.*playlist)[:|\/]([0-9a-zA-Z]+)/Sig }
alias -l ispeqrx {
  var %e = $regex(eq,$1-,$eqrgx), %s = $regex(sp,$1-,$spotrx), %m
  var %x = 1 | while ($regml(sp,%x)) { var %m = $addtok(%m,$+($replace($v1,/,:),:,$regml(sp,$calc(%x + 1))),32) | inc %x 2 }
  var %x = 1 | while ($regml(eq,%x)) { var %m = $addtok(%m,$+($replace($v1,/,:,preset,eq),:,$regml(eq,$calc(%x + 1))),32) | inc %x 2 }
  return %m
}

;-- hotlinks.. derp.
on ^*:hotlink:*:*:{ if ($ispeqrx($1)) { return } | halt }
on *:hotlink:*:*:{
  if (($regex($1,$eqrgx)) || ($regex($1,$spotrx))) {
    var %t = $replace($regml(1),preset,eq), %d = $regml(2)
    var %uri = $+(spotify:,$replace(%t,/,:),:,%d)
    hadd -m ircify.hlink uri %uri
    if ((%t == eq) && ($len(%d) == 11)) {
      if ($sptset(hotlinks,eqlinkaction)) {
        var %hla = $v1 | hfree ircify.hlink
        if ($istok(load stald,%hla,32)) { spopenlnk %uri }
        if ($istok(store stald,%hla,32)) {
          var %n = HotLinked, %eqs = $sptset(equalify,%n)
          if (!$istok(%eqs,%d,32)) {
            sptset equalify %n $remtok($addtok(%eqs,%d,32),None,1,32)
            ircifecho Equalify settings from $+(,%n,) have been stored -> $+(,%uri,)
          }
        }
      }
      else { optsify hotlink eq %uri }
    }
    elseif (%t != eq) {
      if ($sptset(hotlinks,hlinkaction)) {
        var %hla = $v1 | hfree ircify.hlink
        if (%hla == load) { spopenlnk %uri }
        elseif (%hla == lookup) { lookqueue %uri echo $active }
      }
      else { optsify hotlink %uri }
    }
  }
}

;-----------------
;-- check text/action events for spotify/equalify stuff..
on *:text:*:#:{ if ($ispeqrx($1-)) { getspot $chan $nick $strip($1-) } }
on *:action:*:#:{ if ($ispeqrx($1-)) { getspot $chan $nick $strip($1-) } }
on *:text:*:?:{ if ($ispeqrx($1-)) { getspot query $nick $strip($1-) } }
on *:action:*:?:{ if ($ispeqrx($1-)) { getspot query $nick $strip($1-) } }

;-- parse text events..
alias getspot {
  if ($ispeqrx($3-)) {
    var %x = 1, %m = $v1, %tt = $numtok(%m,32), %n = $2, %eql
    var %opt = $iif($1 == query,$sptset(lookauto,autopoutput),$sptset(lookauto,autocoutput))
    var %opt = $iif($hget(ircify.tmpl,tmptell),$v1,%opt), %owt = $window($gettok(%opt,2-,32)).type
    var %opt = $iif(!$istok(channel query,%owt,32),$replace(%opt,msg,echo,describe,echo),%opt)
    var %opt = $replace(%opt,Status Window,-a)
    while ($gettok(%m,%x,32)) {
      var %cr = $v1, %t = $gettok(%cr,1,58), %d = $gettok(%cr,-1,58), %uri = $+(spotify:,%cr)
      if ((%t != eq) && ($sptset(lookauto,autolookup))) {
        var %dolook = $false
        if (($1 == query) && ($sptset(lookauto,pmlook))) { var %dolook = $true }
        if (($1 ischan) && ($sptset(lookauto,chanlook))) {
          if (($sptset(lookauto,lookaction) == all) || (($sptset(lookauto,lookaction) == listed) && ($istok($sptset(spoklook,$network),$1,44)))) { var %dolook = $true }
        }
        ;-- only song track lookups are currently available, sorry.. =(
        if (%t != track) { var %dolook = $false }
        if (%dolook) {
          inc $+(-eu,$sptset(lookauto,alfldtime)) %ircify.dospot. [ $+ [ %n ] ]
          if (%ircify.dospot. [ $+ [ %n ] ] <= $sptset(lookauto,alfldamnt)) { lookqueue %uri %opt }
        }
      }
      elseif ((%t == eq) && ($len(%d) == 11) && ($sptset(lookauto,autoeqstore))) {
        var %eqs = $sptset(equalify,%n)
        if (!$istok(%eqs,%d,32)) { var %eql = $addtok(%eql,%d,32) | sptset equalify %n $remtok($addtok(%eqs,%d,32),None,1,32) }
      }
      inc %x
    }
    if ($hget(ircify.tmpl)) { hfree ircify.tmpl } | if ($hget(ircify.hlink)) { hfree ircify.hlink }
    if (%eql) { %opt $sptset(main,preftag) Equalify settings from $+(,%n,) have been automagicaly stored -> $regsubex(%eql,/(\w+)/g,$+(,spotify:eq:\1,)) }
  }
}


;-----------------  ircify end -----------------
;--------------------------------------------------------------------

;--------------------------------------------------------------------
