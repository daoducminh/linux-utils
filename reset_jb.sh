#!/usr/bin/env bash
# Works on JB products <= 2021.1.3

rm -rf ~/.java/.userPrefs/prefs.xml
rm -rf ~/.java/.userPrefs/jetbrains

JB_PRODUCTS="PyCharm PhpStorm IntelliJIdea WebStorm CLion GoLand Rider DataGrip RubyMine AppCode"

for PRD in $JB_PRODUCTS; do
    rm -rf ~/.config/JetBrains/${PRD}*/eval
    rm -rf ~/.config/JetBrains/${PRD}*/options/other.xml
done
