# ~/.zsh/git.zsh
# Git-specific fzf functions for enhanced workflow

# ============================================================================
# Git + FZF Functions
# Note: Basic git aliases are provided by Oh My Zsh git plugin
# ============================================================================

# fbr: Fuzzy git branch checkout
fbr() {
  local branches branch
  branches=$(git branch -a) &&
  branch=$(echo "$branches" | fzf +m --height 40% --reverse) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco: Fuzzy git commit browser with preview
fco() {
  local commits commit
  commits=$(git log --oneline --color=always --graph --decorate --all) &&
  commit=$(echo "$commits" | fzf --ansi --height 60% --reverse --preview "git show --color=always {2}") &&
  git checkout $(echo "$commit" | awk '{print $2}')
}

# fshow: Fuzzy git log browser with interactive preview
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % git show --color=always %" \
      --bind "enter:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fstash: Fuzzy git stash browser with preview
fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-a \
        --preview "git stash show --color=always -p {1}");
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-a' ]]; then
      git stash apply $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

# gadd: Fuzzy git add (select files to stage)
gadd() {
  git status --short |
  fzf -m --height 60% --reverse --preview "git diff --color=always {2}" |
  awk '{print $2}' |
  xargs git add
}

# gdiff: Fuzzy git diff file selector
gdiff() {
  git status --short |
  fzf --height 60% --reverse --preview "git diff --color=always {2}" |
  awk '{print $2}' |
  xargs git diff
}

# greset: Fuzzy git reset (unstage files)
greset() {
  git status --short |
  grep '^[MARC]' |
  fzf -m --height 60% --reverse --preview "git diff --cached --color=always {2}" |
  awk '{print $2}' |
  xargs git reset HEAD
}
