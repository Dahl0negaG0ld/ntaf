#!/bin/bash

set -euo pipefail

git fetch --unshallow

npm run test
npm run test-with-coverage
npm run doc
npm run e2e-test-docker

command='sonar-scanner'
commonArgs="-Dsonar.host.url=https://sonarcloud.io -Dsonar.login=$SONAR_TOKEN -Dsonar.organization=nespresso"
githubArgs="-Dsonar.analysis.mode=preview -Dsonar.github.pullRequest=$TRAVIS_PULL_REQUEST -Dsonar.github.repository=$TRAVIS_REPO_SLUG -Dsonar.github.oauth=$GITHUB_TOKEN"
branchArgs=''

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    if [ "$TRAVIS_BRANCH" != "master" ]; then
       branchArgs="-Dsonar.branch.name=$TRAVIS_BRANCH -Dsonar.branch.target=master"
    fi
    eval $command $commonArgs $branchArgs
else
    eval $command $commonArgs $githubArgs
fi
