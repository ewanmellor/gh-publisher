#!/bin/bash

set -eu

function readlink_f() {
  if [ $(uname) = 'Darwin' ]
  then
    DIR=$(echo "${1%/*}")
    FILE=$(basename "$1")
    (cd "$DIR" && echo "$(pwd -P)/$FILE")
  else
    readlink -f "$1"
  fi
}

gh_token="${GH_TOKEN-}"
git_name="${GIT_NAME-Automated build by gh-publisher}"
git_email="${GIT_EMAIL-not.a.real.person@example.com}"
git_remote="${GIT_REMOTE-origin}"
git_publish_branch="${GIT_PUBLISH_BRANCH-gh-pages}"

if [ -z "$gh_token" ]
then
  echo "GH_TOKEN is not set.  Cannot proceed." >&2
  echo "Please see the installation instructions." >&2
  exit 1
fi

scripts_dir=$(dirname $(readlink_f "$0"))
scripts_dir_name=$(basename "$scripts_dir")
project_dir=$(dirname "$scripts_dir")

cd "$scripts_dir"
git_url=$(git config "remote.${git_remote}.url" |
          sed -e 's,git://*,https://,' -e "s,https://,https://${gh_token}@,")
git_rev=$(git rev-parse HEAD)
github_username=$(echo "$git_url" | sed -e 's,^https://[^/]*/\([^/]*\)/.*$,\1,')
github_repo=$(echo "$git_url" | sed -e 's,^https://[^/]*/[^/]*/\([^/.]*\).*$,\1,')

tmpdir=$(mktemp -t publish.XXXXXX -d)
(cd "$tmpdir"
 git clone "$git_url" "publish"
 cd publish
 git config user.name "$git_name"
 git config user.email "$git_email"
 if git branch -av | grep -q "remotes/origin/$git_publish_branch"
 then
   git checkout "$git_publish_branch"
 else
   git checkout --orphan "$git_publish_branch"
   git reset .
   git clean -dfx
 fi
)
publish_dir="$tmpdir/publish"

export GH_PUBLISHER_PROJECT_DIR="$project_dir"
export GH_PUBLISHER_PUBLISH_DIR="$publish_dir"
export GH_PUBLISHER_SCRIPTS_DIR="$scripts_dir"

(cd "$project_dir" && /bin/bash "$scripts_dir/build.sh")
(cd "$project_dir" && /bin/bash "$scripts_dir/copy.sh")

published_scripts="$publish_dir/$scripts_dir_name"
if [ -d "$published_scripts" ]
then
  rsync -av "$published_scripts"/* "$publish_dir"
  rm -rf "$published_scripts"
fi

config_yml="$publish_dir/_config.yml"
cp "$scripts_dir/front-matter.yml" "$config_yml"
echo "github_username: $github_username" >>"$config_yml"
echo "github_repo: $github_repo" >>"$config_yml"
if ! grep -q "^iframe_src:" "$config_yml"
then
  iframe_src=$( (cd "$publish_dir"; ls *.pdf || true) | sort | head -n1)
  if [ -z "$iframe_src" ]
  then
    iframe_src=$( (cd "$publish_dir"; ls *.html || true) | sort | head -n1)
  fi
  if [ -n "$iframe_src" ]
  then
    echo "iframe_src: $iframe_src" >>"$config_yml"
  fi
fi
if ! grep -q "^title:" "$config_yml"
then
  echo "title: $github_repo" >>"$config_yml"
fi

(cd "$publish_dir"
 git add -A
 if ! git diff --quiet --staged
 then
   git commit -m "Built from revision $git_rev."
   git push -q origin "$git_publish_branch:$git_publish_branch"
 else
   echo "Nothing has changed!  I hope that's what you expected." >&2
 fi
)
