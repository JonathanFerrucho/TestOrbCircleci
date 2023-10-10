#!/bin/bash
# If `modules` is unavailable, stop this job without continuation
if [ ! -f "<< parameters.modules >>" ] || [ ! -s "<< parameters.modules >>" ]
then
echo 'Nothing to merge. Halting the job.'
circleci-agent step halt
exit
fi

# Convert a list of dirs to a list of config.yml
sed -i -e 's/$/\/.circleci\/config.yml/g' "<< parameters.modules >>"

# If `shared-config` exists, append it at the end of `modules`
if [ -f << parameters.shared-config >> ]
then
echo "<< parameters.shared-config >>" >> "<< parameters.modules >>"
fi

xargs -a "<< parameters.modules >>" yq -y -s 'reduce .[] as $item ({}; . * $item)' | tee "<< parameters.continue-config >>"