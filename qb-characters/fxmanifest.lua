fx_version 'cerulean'
games { 'gta5' }

author 'ZJ4ER'
description 'Characters'

ui_page "html/index.html"

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
}


lua54 'yes'