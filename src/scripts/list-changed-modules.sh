#!/bin/bash
# Add each module to `modules-filtered` if  2) there is a diff against `base-revision`, 3) there is no `HEAD~1` (i.e., this is the very first commit for the repo) OR 4) there is a diff against the previous commit
cat \<< EOD | sed -e '/^$/d' | while read row; do module="$(echo "$row" | awk '{ print $1 }')"; if [ $(git diff --name-only << parameters.base-revision >> "$module" | wc -l) -gt 0 ] || (! git rev-parse --verify HEAD~1) || [ $(git diff --name-only HEAD~1 "$module" | wc -l) -gt 0 ]; then echo "$row" | sed -e 's/ /\n/g' >> << parameters.modules-filtered >>; fi; done
<< parameters.modules >>
EOD