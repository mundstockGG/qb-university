fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'mundstock'
description 'University System for Ventura Roleplay'
version '1.0.0'

shared_scripts { 
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client/main.lua'
server_script 'server/server.lua'

dependencies {
    'qb-core',
    'ox_lib'
}