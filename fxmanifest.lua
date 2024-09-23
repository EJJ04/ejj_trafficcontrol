fx_version 'cerulean'
game 'gta5'

name 'ejj_trafficcontrol'
author 'EJJ_04'
version '1.0.0'
lua54 'yes'

files {
    'locales/*.json',
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
    '@oxmysql/lib/MySQL.lua',
    
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua',
}