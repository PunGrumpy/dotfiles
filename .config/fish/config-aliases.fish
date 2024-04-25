# EZA
if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

# Docker
if type -q dockercolorize
    alias dps "docker ps | dockercolorize"
    alias dpsa "docker ps -a | dockercolorize"
    alias di "docker images | dockercolorize"
    alias dcps "docker compose ps | dockercolorize"
    alias dstats "docker stats --no-stream | dockercolorize"
end

if type -q docker
    alias d docker
end

# Kubernetes
if type -q kubectl
    alias k kubectl
end

if type -q kubectx
    alias kctx kubectx
    alias kns kubens
end

# Helm
if type -q helm
    alias h helm
end

# Terraform
if type -q terraform
    alias tf terraform
end

# Ansible
if type -q ansible
    alias a ansible
    alias ap ansible-playbook
end

# Python
alias python python3
alias pip pip3
