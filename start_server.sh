#!/bin/bash

steamcmd_dir="/home/steam/steamcmd"
steam_user="anonymous"
install_dir="/home/steam/dstds"
cluster_name="world"
dontstarve_dir="/home/steam/.klei/DoNotStarveTogether"

function fail()
{
    echo Error: "$@" >&2
    exit 1
}

function check_for_file()
{
    if [ ! -e "$1" ]; then
        fail "Missing file: $1"
    fi
}

cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"

check_for_file "steamcmd.sh"
check_for_file "$dontstarve_dir/$cluster_name/cluster.ini"
check_for_file "$dontstarve_dir/$cluster_name/cluster_token.txt"
check_for_file "$dontstarve_dir/$cluster_name/Master/server.ini"
#check_for_file "$dontstarve_dir/$cluster_name/Caves/server.ini"

if [ ! -e $install_dir ]; then
    echo mkdir $install_dir
    mkdir $install_dir
fi

if [ ! -e $dontstarve_dir ]; then
    echo mkdir $dontstarve_dir
    mkdir -p $dontstarve_dir
fi

./steamcmd.sh +force_install_dir "$install_dir" +login $steam_user +app_update 343050 validate +quit

# download mods
modsfile=''
if [ -e $dontstarve_dir/$cluster_name/Master/modoverrides.lua ]; then
    modsfile="${modsfile} ${dontstarve_dir}/world/Master/modoverrides.lua"
fi

if [ -e $dontstarve_dir/$cluster_name/Caves/modoverrides.lua ]; then
    modsfile="${modsfile} ${dontstarve_dir}/world/Caves/modoverrides.lua"
fi

if [ "$modsfile" != '' ]; then
    rm -rf $install_dir/mods/dedicated_server_mods_setup.lua
    cat $modsfile | grep workshop-[0-9]* | grep -o [0-9]* | sort | uniq | xargs -I '{}' echo 'ServerModSetup("{}")' >> $install_dir/mods/dedicated_server_mods_setup.lua
fi


# start server
check_for_file "$install_dir/bin"

cd "$install_dir/bin" || fail

run_shared=(./dontstarve_dedicated_server_nullrenderer)
run_shared+=(-console)
run_shared+=(-cluster "$cluster_name")
run_shared+=(-monitor_parent_process $$)
"${run_shared[@]}" -shard Master | sed 's/^/Master: ' &
if [ -e $dontstarve_dir/$cluster_name/Caves ]; then
	"${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /'
fi
