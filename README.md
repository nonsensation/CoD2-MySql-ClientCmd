# CoD2-MySql-ClientCmd

This requires libcod from http://killtube.org & a MySQL database.

---
This may not be a complete mod, I just had a quick look over it and it seems to be missing some parts (`player.pers["client"].Id`, `BanPlayer()` in MySQL etc...)
---

- init in `maps\mp\gametypes\_callbacksetup::CodeCallback_StartGameType()` via `level thread svr\main::Main();`
- libcod calls `maps\mp\gametypes\_callbacksetup::CodeCallback_PlayerCommand( args )`
- see `svr\clientcmd\clientcmd.gsc` for implementation
- create and call `level thread svr\clientcmd\clientcmd_<your-command>::Init();` where you register your command:
- `RegisterChatCmd( cmdNameList , cmdCallbackFunc , isHiddenCmd , helpText )`
  - `cmdNameList`: all the valid names for this command, for long (`!time`) or short (`!t`) versions
  - `cmdCallbackFunc`: gets called when the client uses the chat-command
  - `isHiddenCmd`: specifies if the command is sent to the chat-window and visible for all players (in theory, I just looked through the source and couldn't find the implementation)
  - `helpText`: an optional help text displayed in `!help` or `!h`

### MySQL Setup

- set the following server variables (example for local development in server.cfg):
  - `mysql_hostname`
  - `mysql_username`
  - `mysql_password`
  - `mysql_database`
  - `mysql_port`
- every SQL command should be logged to the console
- it creates the tables on its own (see `svr/mysql/mysql_functions.gsc`)
- every command is logged and the clients IP & name is logged to a table
- it matches names & IPs so you can lookup for name and/or IP changes
  
