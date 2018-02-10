#!/bin/bash -x


function init_repo_tool() {
    declare -ga REPO_TOOL_BRANCH_NAME
    local MANIFEST_BRANCH_NAME
    if [[ -d "$ADMIN_SRC_DIR" ]]; then
      MANIFEST_BRANCH_NAME=`cd $ADMIN_SRC_DIR;$DEPLOYMENT_ROOT_DIR/bin/repo info 
      | grep 'refs/.*' 
      | sed "s/^Manifest merge branch: refs\/heads\/\(.*\)$/\1/" 2>/dev/null`
    else
      mkdir -p $ADMIN_SRC_DIR
      chown -hR $USER:$USER $ADMIN_SRC_DIR
      read -p "Manifest branch name [master]: " MANIFEST_BRANCH_NAME
      MANIFEST_BRANCH_NAME=${MANIFEST_BRANCH_NAME:-master}
    fi
    cd $ADMIN_SRC_DIR && \
    read -p "Enter FVAdmin repo manifest branch name that to fetch: [${MANIFEST_BRANCH_NAME}] " REPO_TOOL_BRANCH_NAME
    if [ -z "$REPO_TOOL_BRANCH_NAME" ]; then
      REPO_TOOL_BRANCH_NAME=$MANIFEST_BRANCH_NAME
    fi
    $DEPLOYMENT_ROOT_DIR/bin/repo init -u https://bitbucket.org/futurevaultdev/fvadmin-manifest -b $REPO_TOOL_BRANCH_NAME
}
init_repo_tool