fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'John Doe <j.doe@example.com>'
description 'Example resource'
version '1.0.0'
shared_script '@ox_lib/init.lua'
lua54 'yes'

-- What to run
client_scripts {
    'cl.lua'
}
--server_script 'server.lua'