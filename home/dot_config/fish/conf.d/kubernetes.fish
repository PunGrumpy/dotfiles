# ~/.kube/config is the default kubectl reads, and the file `kubectl config`
# writes back to. Anything else under ~/.kube is appended so a new cluster
# only needs its config dropped in — no merging, no re-exporting.
#
#   ~/.kube/<name>/config   or   ~/.kube/configs/<name>.yaml
if type -q kubectl
    set -l configs

    if test -f $HOME/.kube/config
        set -a configs $HOME/.kube/config
    end

    for config in $HOME/.kube/*/config $HOME/.kube/configs/*.yaml
        if test -f $config
            set -a configs $config
        end
    end

    if test (count $configs) -gt 1
        set -gx KUBECONFIG (string join : $configs)
    end
end
