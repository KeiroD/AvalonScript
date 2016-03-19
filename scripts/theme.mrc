raw 311:*:{ echo @whois 00[09<00Whois09>14 $2 $+ 00  | echo @whois 00[09<00Ident09>14 $3 $+ 00 | echo @whois 00[09<00Address09>14 @ $+ $4 $+ 00 | echo @whois 00[09<00Real Name09>14 $6- $+ 00 | halt }
raw 307:*:{ echo @whois 00[09<00Registered Nick09>14 Yes00 | halt }
raw 301:*:{ echo @whois 00[09<00Away09>14 $3- $+ 00] | halt }
raw 310:*:{ halt }
raw 378:*:{ echo @whois 00[09<00Hostmask09>14 $6 $+ 00 and 0009<00IP09>14 $7 $+ 00 | halt }
raw 379:*:{ echo @whois 00[09<00Modes09>14 $6- $+ 00 | halt }
raw 671:*:{ echo @whois 00[09<00Secure Connecction09>14 Yes00 | halt }
raw 312:*:{ echo @whois 00[09<00Server09>14 $3 $+ 00 | echo @whois 00[09<00Description09>14 $4- $+ 00 | halt }
raw 313:*:{ echo @whois 00[09<00Network Rank09>14 $2-9 $+ 00 | halt }
raw 320:*:{ echo @whois 00[09<00Network Role09>14 $2-9 $+ 00 | halt }
raw 319:*:{ echo @whois 00[09<00Channels09>14 $iif(!$3-,No Channels,$Replace($3-,~,09~14,&,09&14,@,09@14,%,09%14,+,09+14)) $+ 00 | halt }
raw 317:*:{ echo @whois 00[09<00Signed on09>14 $asctime($4,dddd mm/dd/yyyy HH:nn:sstt) $+ 00 | echo @whois 00[09<00Time Idle09>14 $duration($3) $+ 00 | echo @whois 00[09<00Time Online09>14 $duration($calc($ctime - $4)) $+ 00 | halt }
raw 335:*:{ echo @whois 00[09<Bot09>14 Yes00 | halt }
raw 318:*:{ echo @whois 00[09<00Whois09>14 End of09 $2 $+ 14's Information00  | halt }
raw 330:*:{ echo @whois 00[09<00Logged in as09>14 $2 $+ 00 | halt }


raw 401:*:{ echo -a 00[09<00Error09>14 No such User09 $2 $+ 00] | halt }
raw 473:*:{ echo -at 09<00Error09>14 Cannot join channel 09(00 $+ $remove($6,$chr(40),$chr(41)) $+ 09)00] | halt }
raw 332:*:{ echo $2 $timestamp 09<00Topic09>14 Topic is09 "00 $+ $3- $+ 09"00] | haltdef }
raw 333:*:{ echo $2 $timestamp 09<00Topic09>14 Topic set by09 $3 00on09 $asctime($4,dddd mm/dd/yyyy hh:nn:sstt) $+ 00] | haltdef }
raw 324:*:{ echo $2 $timestamp 09<00Channel Modes09>14 set in this channel:09 $3 | haltdef }
raw 001:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 002:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 003:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 004:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 005:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 251:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 252:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 254:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 255:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 265:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 266:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 375:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 372:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 376:*:{ echo -s 00[09<00Server Information09>14 $2- $+ 00] | haltdef }
raw 321:*:{ haltdef | echo -s 00[09<00Listing Channels09>00] }
raw 323:*:{ haltdef | echo -s 00[09<00End of 14/List09>00] }
raw 474:*:{ haltdef | echo -s 00[09<00Error09>14 Cannot join channel09(00 $+ $remove($6,$chr(40),$chr(41)) $+ 09)00] }
raw 320:*:{ echo -a <- $1- | haltdef }
