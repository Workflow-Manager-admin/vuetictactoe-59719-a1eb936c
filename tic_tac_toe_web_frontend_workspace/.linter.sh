#!/bin/bash
cd /home/kavia/workspace/code-generation/vuetictactoe-59719-a1eb936c/tic_tac_toe_web_frontend_workspace/tic_tac_toe_web_frontend
npm run lint
ESLINT_EXIT_CODE=$?
npm run build
BUILD_EXIT_CODE=$?
if [ $ESLINT_EXIT_CODE -ne 0 ] || [ $BUILD_EXIT_CODE -ne 0 ]; then
   exit 1
fi

