function newbranch --description "Create a throwaway branch with a random name"
    git checkout -b "$git_branch_prefix/"(random_suffix)
end
