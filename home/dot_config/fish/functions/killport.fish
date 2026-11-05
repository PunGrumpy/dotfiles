function killport --description "Kill whatever is listening on a TCP port"
    if test -z "$argv[1]"
        echo "Usage: killport <port>" >&2
        return 1
    end

    set -l pids (lsof -ti tcp:$argv[1])
    if test -z "$pids"
        echo "Nothing is listening on port $argv[1]"
        return 0
    end

    kill -9 $pids
end
