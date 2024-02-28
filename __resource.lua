resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'

description 'Klamer rob npc'

server_scripts {
     'config.lua',
     'server/main.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'client/main.lua',
    '@ox_lib/init.lua'

}

dependencies {
    'es_extended'
}