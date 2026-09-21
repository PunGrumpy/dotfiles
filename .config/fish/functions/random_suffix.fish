function random_suffix --description "Print a random 5-character suffix"
    if type -q sha256sum
        head -c 16 /dev/urandom | sha256sum | cut -c 1-5
    else if type -q shasum
        head -c 16 /dev/urandom | shasum | cut -c 1-5
    else
        head -c 16 /dev/urandom | cksum | cut -c 1-5
    end
end
