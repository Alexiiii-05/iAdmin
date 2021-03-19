fx_version "adamant"
game "gta5"

client_scripts {
    "src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",
    "src/client/components/*.lua",
    "src/client/menu/elements/*.lua",
    "src/client/menu/items/*.lua",
    "src/client/menu/panels/*.lua",
    "src/client/menu/windows/*.lua",

    "Config.lua",
    "cl_admin.lua",
    "cl_functions.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "Config.lua",
    "sv_admin.lua"
}
