fx_version 'cerulean'
game 'gta5'

version '1.0.0'

shared_scripts {'@ox_lib/init.lua', 'shared/sh_config.lua'}

client_script {'@qbx_core/modules/playerdata.lua', 'client/cl_main.lua'}

server_scripts {'server/main.lua'}

lua54 'yes'
