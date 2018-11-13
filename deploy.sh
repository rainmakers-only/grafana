#!/bin/bash

BRANCH="${BRANCH:-rm_master}"

# thanks https://github.com/gma/heroku-deploy-rails !
# Notes:
# Please enabled heroku pgbackups
# Please have 2 remoted called pointing at their respective heroku git
#  staging
#  production

# Functions

usage()
{
  echo "Usage: [BRANCH=master] $(basename $0) <remote>" >&2
  echo >&2
  echo "        remote         Name of git remote for Heroku app" >&2
  echo "        no-migrations  Deploy without running migrations" >&2
  echo >&2
  exit 1
}

has_remote()
{
  git remote | grep -qs "$REMOTE"
}

show_undeployed_changes()
{
  git fetch $REMOTE
  local range="$REMOTE/master..$BRANCH"
  local commits=$(git log --reverse --pretty=format:'%h | %cr: %s (%an)' $range)

  if [ -z "$commits" ]; then
    echo "Nothing to deploy (or $BRANCH is behind currently deployed branch)"
    echo -e -n "\nPress enter to continue... "
    read
  else
    echo -e "Undeployed commits:\n"
    echo -e "$commits"
    echo -e -n "\nPress enter to continue... "
    read
  fi
}

deploy_changes()
{
  if [ "$REMOTE" = "production" ]; then
    # No going backwards on production
    git push $REMOTE $BRANCH:master
  else
    git push -f $REMOTE $BRANCH:master
  fi
}

# Main program

set -e

REMOTE="$1"
COMMAND="$2"

[ -n "$DEBUG" ] && set -x
[ -z "$REMOTE" ] && usage

[ ! has_remote ] && usage

show_undeployed_changes
deploy_changes
