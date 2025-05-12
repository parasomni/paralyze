script_folder="/home/xpr/repos/wizard/c++-implementation/Bot/build"
echo "echo Restoring environment" > "$script_folder/deactivate_conanrunenv-release-x86_64.sh"
for v in LD_LIBRARY_PATH DYLD_LIBRARY_PATH OPENSSL_MODULES PATH
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


export LD_LIBRARY_PATH="/home/xpr/.conan2/p/b/boost0979979597134/p/lib:/home/xpr/.conan2/p/b/opens386f8c036bddd/p/lib:$LD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="/home/xpr/.conan2/p/b/boost0979979597134/p/lib:/home/xpr/.conan2/p/b/opens386f8c036bddd/p/lib:$DYLD_LIBRARY_PATH"
export OPENSSL_MODULES="/home/xpr/.conan2/p/b/opens386f8c036bddd/p/lib/ossl-modules"
export PATH="/home/xpr/.conan2/p/b/opens386f8c036bddd/p/bin:$PATH"