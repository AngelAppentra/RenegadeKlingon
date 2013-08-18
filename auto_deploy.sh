#bash
#deploy the game to binary executables in deployments directory

test() {
    "$@"
    status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1";
	exit 10;
    fi
}


necesary_files="GameFrameWork GameScreens Resources Utils main.lua conf.lua"
path_linux=../RenegadeKlingonDeploy/linux
path_windows=../RenegadeKlingonDeploy/windows
path_mac=../RenegadeKlingonDeploy/mac
path_act=`pwd`


#lets deploy a .love for LINUX
echo "deploying for linux..."
test cd ../RenegadeKlingonDeploy
test git checkout linux
test cd ../RenegadeKlingon
rm $path_linux/*
test zip  $path_linux/RenegadeKlingon.zip -r $necesary_files
test mv $path_linux/RenegadeKlingon.zip $path_linux/RenegadeKlingon.love
test cd ../RenegadeKlingonDeploy
test git commit -a --message="auto_deploy script deploying linux"
test git push
test cd ../RenegadeKlingon

echo "deploy for linux OK"

# # lets deploy a .exe for WINDOWS
echo "deploying for windows..."
test cd ../RenegadeKlingonDeploy
test git checkout windows
test cd ../RenegadeKlingon
rm $path_windows/*
test cp $path_linux/RenegadeKlingon.love $path_windows/game.love
test cp -R ../RenegadeKlingonDeploy/love-0.8.0-win-x86/* $path_windows/
test cat $path_windows/love.exe $path_windows/game.love > $path_windows/RenegadeKlingon.exe
test rm $path_windows/*.love $path_windows/love.exe
test cd ../RenegadeKlingonDeploy
test git commit -a --message="auto_deploy script deploying windows"
test git push
test cd ../RenegadeKlingon
echo "deploy for windows OK"

# #lets deploy a .app for MAC OSX
echo "deploying for mac..."
test cd ../RenegadeKlingonDeploy
test git checkout mac
test cd ../RenegadeKlingon
rm -rf $path_mac/*
test cp -R ../RenegadeKlingonDeploy/love.app $path_mac/RenegadeKlingon.app
test cp $path_linux/RenegadeKlingon.love $path_mac/RenegadeKlingon.app/Contents/Resources/
test sed -i 's/>org.love2d.love</>com.with2balls.RenegadeKlingon</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test sed -i 's/>LÖVE</>RENEGADEKLINGON</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test cd $path_mac
test zip RenegadeKlingon.osx.zip -r ./RenegadeKlingon.app
test cd $path_act
test rm -rf $path_mac/RenegadeKlingon.app
test cd ../RenegadeKlingonDeploy
test git commit -a --message="auto_deploy script deploying mac"
test git push
test cd ../RenegadeKlingon
echo "deploy for mac OK"

test cd ../RenegadeKlingonDeploy
test git checkout master
test git merge linux
test git merge windows
test git merge mac
test git push
test cd ../RenegadeKlingon