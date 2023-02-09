{ runCommand }:

{ name, paths, postBuild ? "", ... }:
runCommand name { inherit paths; passAsFile = ["paths"]; }
''
    mkdir -p $out
    for i in $(cat $pathsPath); do
        find -L $i -type f -exec bash -c "\
            dir={}; \
            target=$out\''\${dir#$i}; \
            mkdir -p \''\${target%\$(basename \$target)}; \
            ln -s {} \$target;" \
        \;
    done

    ${postBuild}
''
