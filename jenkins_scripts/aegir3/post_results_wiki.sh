#!/bin/bash
CHANGELOG="Coming SOON!"
JSON="{\"slug\": \"${PROJECT}/changelog\", \"title\": \"Project Changelog\", \"content\": \"${CHANGELOG}\"}"
echo $JSON | arc call-conduit --conduit-uri http://coder.wembassy.com/ phriction.edit
