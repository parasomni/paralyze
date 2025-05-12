script_folder="/home/xpr/repos/wizard/c++-implementation/Server/build"
echo "echo Restoring environment" > "$script_folder/deactivate_conanrunenv-release-x86_64.sh"
for v in LD_LIBRARY_PATH DYLD_LIBRARY_PATH MARIADB_PLUGIN_DIR PATH OPENSSL_MODULES
do
    is_defined="true"
    value=$(printenv $v) || is_defined="" || true
    if [ -n "$value" ] || [ -n "$is_defined" ]
    then
        echo export "$v='$value'" >> "$script_folder/deactivate_conanrunenv-release-x86_64.sh"
    else
        echo unset $v >> "$script_folder/deactivate_conanrunenv-release-x86_64.sh"
    fi
done


export LD_LIBRARY_PATH="/home/xpr/.conan2/p/b/mongo5313063350671/p/lib:/home/xpr/.conan2/p/b/boost41488eebefabd/p/lib:/home/xpr/.conan2/p/b/mariad1a65861d246f/p/lib:/home/xpr/.conan2/p/b/opens386f8c036bddd/p/lib:$LD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="/home/xpr/.conan2/p/b/mongo5313063350671/p/lib:/home/xpr/.conan2/p/b/boost41488eebefabd/p/lib:/home/xpr/.conan2/p/b/mariad1a65861d246f/p/lib:/home/xpr/.conan2/p/b/opens386f8c036bddd/p/lib:$DYLD_LIBRARY_PATH"
export MARIADB_PLUGIN_DIR="/home/xpr/.conan2/p/b/mariad1a65861d246f/p/lib/plugin:$MARIADB_PLUGIN_DIR"
export PATH="/home/xpr/.conan2/p/b/mariad1a65861d246f/p/bin:/home/xpr/.conan2/p/b/opens386f8c036bddd/p/bin:$PATH"
export OPENSSL_MODULES="/home/xpr/.conan2/p/b/opens386f8c036bddd/p/lib/ossl-modules"