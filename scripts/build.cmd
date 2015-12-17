@echo off
setlocal

cd %~dp0
cd ../

echo :: Set local git config
call git config --local core.autocrlf false
call git config --local core.safecrlf true
echo :: Done

echo :: Clean repo
call git clean -fdx > nul
call rmdir /S /Q node_modules > nul
call git reset --hard HEAD~0 > nul
echo :: Done

echo :: Fetch latest changes
call git pull --rebase origin master > nul
echo :: Done

echo :: NPM install
call scripts\npm.bat install --loglevel error > nul
echo :: Done

echo :: Build Code
call node --max_old_space_size=4096 ./node_modules/gulp/bin/gulp.js vscode-win32-x64 > ../build.log
echo :: Done

echo :: Install latest typescript nightly build
call npm install -g typescript@next > nul
echo :: Done

echo :: Copy VSCode-win32 folder to tools folder
call robocopy ../VSCode-win32-x64 D:/tools/VSCode /MIR /XD > nul
echo :: Done!
