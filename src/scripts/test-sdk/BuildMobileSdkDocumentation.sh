LAUNCH_DIR=$PWD

APPLEDOC_EXE=$(which appledoc)
if [ -z "$APPLEDOC_EXE" ]; then
	APPLEDOC_EXE=/usr/local/bin/appledoc
fi


cd ../..
PROJECT_ROOT=$PWD
cd "$LAUNCH_DIR"


DEPLOYMENT_DIR=${PROJECT_ROOT}/deployment
SDK_LIBRARIES_ROOT=${PROJECT_ROOT}/lib

if [ -d "$DEPLOYMENT_DIR" ]; then
	rm -rf "$DEPLOYMENT_DIR" 
fi
mkdir -p "$DEPLOYMENT_DIR" 


cd "$DEPLOYMENT_DIR"
	which appledoc

	${APPLEDOC_EXE} \
	 	--project-name "Sitecore Mobile SDK" \
		--project-company "Sitecore" \
		--company-id net.sitecore \
		--output . \
		"$SDK_LIBRARIES_ROOT/SCApi/SitecoreMobileSDK" \
		"$SDK_LIBRARIES_ROOT/SCMap/SitecoreMobileSDK" \
		"$SDK_LIBRARIES_ROOT/SCQRCodeReader/SitecoreMobileSDK" \
		"$SDK_LIBRARIES_ROOT/SCUI/SitecoreMobileSDK" \
		"$SDK_LIBRARIES_ROOT/SCUtils/SitecoreMobileSDK" \
		"$SDK_LIBRARIES_ROOT/SCWebView/SitecoreMobileSDK"
#		"$SDK_LIBRARIES_ROOT/SCWebContentApi" \
		"$SDK_LIBRARIES_ROOT/SCWebPlugins" \



	DOCUMENTATION_PATH=$( cat docset-installed.txt | grep Path: | awk 'BEGIN { FS = " " } ; { print $2 }' )
	echo DOCUMENTATION_PATH - $DOCUMENTATION_PATH
	
	cp -R "${DOCUMENTATION_PATH}" .
	find . -name "*.docset" -exec zip -r Sitecore-Mobile-SDK-doc.zip {} \;  -print 
cd "$LAUNCH_DIR"
