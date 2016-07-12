#!/bin/bash
COMMENT="Revision ${REVISION_ID} passed all tests for revision ${DIFF_ID}"
JSON="{\"message\": \"${COMMENT}\", \"action\": \"none\", \"revision_id\": \"${REVISION_ID}\"}"
echo $JSON | arc call-conduit --conduit-uri http://coder.wembassy.com/ differential.createcomment
