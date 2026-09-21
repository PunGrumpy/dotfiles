function nukemodules --description "Delete every node_modules directory below \$PWD"
    find . -name node_modules -type d -prune -print0 | xargs -0 rm -rf
end
