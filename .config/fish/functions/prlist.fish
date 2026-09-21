function prlist --description "List the URLs of your open pull requests"
    gh pr list --author "@me" --json=url --jq '.[].url'
end
