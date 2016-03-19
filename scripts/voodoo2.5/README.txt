Voodoo2 ReadMe
Release Version 2.0

Author:   Freakuancy
Email:    freakuancy@gmail.com
AIM SN:   Freakuancy
Darkmyst: Freakuancy
Efnet:    diviniti

Revised: January 30th, 2013


-= Table of Contents =-

Introduction
Features
Installation
Commands


-= Introduction =-

Voodoo2 was created implicitly for use with mIRC 7.x. (We personally were running mIRC 7.27 and 7.29 during the development of this script.) It's entirely possible that Voodoo2 will work with older versions of mIRC, but we cannot guarantee that it will and will not offer support for older versions. It's recommended that you update your copy of mIRC.


-= Features =-

* Profile Storage: Easily customize features by character profile and switch between them. Profiles are set by channel, so you can run one profile in one channel, and another in a different channel. Makes doubling without nick changes easy.

* Cut Script: Customize your trailing, leading and ending text easily. Or turn it off entirely to rely on mIRC's built in cut function. 

* Auto Color: Input text is processed and colorized according to the active profile. Colors can be easily changed by profile. Text is processed based on the /me command (action) or normal input (default) and any opening and closing notations. 

* PNicks: "Pseudo Nicks" as coined by the old Switchblade script. Append a character name to the first paragraph of every post. This can be customized and saved by profile.

* Paragraph Breaks: RPers can write more naturally and note paragraph breaks as they would in formal writing using the backslash character. The script automatically processes this as a new paragraph and will start text following it on a new post.

* DarkMyst.org Custom Command Cut Function: Get around that pesky mIRC buffer limit and write long, elaborate /npc, /npca and /scene posts. Voodoo2 uses its own aliases for these commands and natively cuts any lengthy posts automatically and correctly. This feature works by default, and will function regardless of whether or not you're using the script's cut function or mIRC's. 

* Notifications: Never miss an RP post again. Configure a pop up in the notification area of the system tray for when you have mIRC minimized or behind windows. 

* Character Storage: Add a picture and bio to your profile. Descriptions saved can be sent to the active window for quick character appearance info; similar to auto-descs of old. Pictures can be sent on command to users selected in the nick list.

* Notes: Bring up a note pad in mIRC based on your active profile to store RP details, interesting tidbits or quotes, or anything that you can think of. Good for GMs for storing session information for next time.


-= Installation =-

1. Unzip all files to an easily accessible directory on your hard drive, such as your Documents directory. It's recommended that you put this somewhere accessible and that Windows natively grants users write permissions. C:\Users\YourName\Documents\Voodoo2 is a good place. This can be anywhere on your hard drive except Program Files or any other system related directories. If you can access your AppData directory, you can unzip these files there.

It is important to keep the colorcombo.dll and the empty_profile.jpg in the same location as your voodoo2.mrc file, so make certain they are all in the same directory. 

2. Load the script. This can be done in one of two ways:

Method A: Type /load -rs C:\Users\YourName\Documents\Voodoo2\voodoo2.mrc (or the extended file location of where you unzipped the files)

Method B: Open the Scripts Editor. (You can access it quickly by pressing Alt+R.)
          Go up to File, and navigate to Load. 
          Select voodoo2.mrc

3. Allow the script to initialize. This is *VERY IMPORTANT*. Do NOT cancel out of this or the script will not write the appropriate information that it needs in order to run properly. 

If successful, you should see the following in your Status window:

Voodoo2: Performing first-time initialization...
-
* Made hash table 'tbl_char' (10)
-
(A lot of Added item (example) to hash table 'tbl_char')
-
* Saved hash table 'tbl_char' to 'C:\Users\YourName\Documents\Voodoo2\chars\Standard.rpg' (or wherever your script file is located)

If you see any errors here, such as cannot make the hash tables or the Standard.rpg profile, you should unload the script and delete the chars folder and the chansettings.ini file (in the directory the script was loaded from based on where you unzipped them earlier).

Again, the script needs to be located in an area that mIRC can write to in order to work properly. This can be anywhere on your hard drive but Program Files or in any other system related directories. It's highly recommended that you unzip the script to your Documents directory to avoid these problems.

Restart mIRC and repeat steps 2 and 3. 

4. Configure which profiles are automatically loaded on new channels and queries by right clicking and selecting Script Options. 

5. Add and edit new profiles. (Notifications are turned on by default. Changing the Standard profile will change the template for all new profiles.)

6. Right click to activate your profiles in channels and queries. 


Optional:

7. If you are going to use the script's cut function, you need to turn off mIRC's auto cut function in Options --> IRC --> Messages. Look for the second to last check box and make certain it's unchecked if you plan on using the script's cut function for leading, trailing and ending notations.


-= Commands =-

/ooc - Prints comments in OOC brackets set by the profile.
 - Syntax: /ooc <text>

/describe - Posts the text in your character's description box to the active channel or query.
 - Syntax: /describe

/sayinfo - Posts the text in your character's info box to the active channel or query.
 - Syntax: /sayinfo

/sendpic - Sends your character's profile picture to the specified user.
 - Syntax: /sendpic <name>

/note - Opens your characters scratch pad for notes.
 - Syntax: /note [profile]

/aschar - Sends a single post with the specified profile settings.
 - Syntax: /aschar <profile name> : <text>

/char - Switches character profiles.
 - Syntax: /char <profile name>

/npcsay - Utilizes DarkMyst's /npc command in the active channel, and cuts text accordingly. Carries colors over from the active profile in the channel.
 - Syntax: /npcsay <npc name> : <text>

/npcact - Utilizes DarkMyst's /npca command in the active channel, and cuts text accordingly. This is like the default /me command and uses the action color. Carries over colors from the active profile in the channel.
 - Syntax: /npcact <npc name> : <action>

/npcscene - Utilizes DarkMyst's /scene command in the active channel.
 - Syntax: /npcscene <scene>
