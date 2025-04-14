#!/usr/bin/bash
set -x
if [[ -z "$CM_BUILD_OUTPUT_DIR" ]]; then
    echo "CM_BUILD_OUTPUT_DIR is not set"
    exit 1
fi
if [[ -z "$GH_URL" ]]; then
    echo "GH_URL is not set"
    exit 1
fi
if [[ -z "$PACKAGE" ]]; then
    echo "PACKAGE is not set"
    exit 1
fi
if [[ -z "$VERSION" ]]; then
    echo "VERSION is not set"
    exit 1
fi
if [[ -z "$ARTIFACT" ]]; then
    echo "ARTIFACT is not set"
    exit 1
fi
if [[ -z "$COMPILADO" ]]; then
    echo "COMPILADO is not set"
    exit 1
fi
if [[ -z "$LAST_VERSION" ]]; then
    echo "LAST_VERSION is not set"
fi

git clone git@github.com:SegurosUniversales/mobile-ios-artifacts.git repo -b web
cd repo
git checkout -b $ARTIFACT/$COMPILADO
mkdir -p $ARTIFACT/$COMPILADO

if [[ "$LAST_VERSION" ]]; then
    for file in "$ARTIFACT"/*;
    do
      if [[ "$file" != *"$LAST_VERSION"* ]]; then
        echo "Eliminar: $file"
        rm -rf "$file"
      fi
    done
fi

mkdir -p "$ARTIFACT/$COMPILADO"
cd "$ARTIFACT/$COMPILADO/" || echo "artifact not build"
cp -r "$CM_BUILD_OUTPUT_DIR/*.ipa" ./
cp -r "$CM_BUILD_OUTPUT_DIR/*.apk" ./

i=0; a=0; for f in *;
do
    if [[ "$f" == *.ipa ]];
      then i=$((i+1)) && mv "$f" "app_${ARTIFACT}_$i.${f#*.}";
    fi;
    if [[ "$f" == *.apk ]];
      then a=$((a+1)) && mv "$f" "app_${ARTIFACT}_$a.${f#*.}";
    fi;
done

if [[ "$i" -gt 0 ]]; then
    cp -R ../../templates/base-manifest.plist manifest.plist
fi

echo "$GH_URL" | xargs -I {} sed -i ''  's|%%url-artifact%%|{}|g' manifest.plist
echo "$PACKAGE" | xargs -I {} sed -i ''  's|%%package-artifact%%|{}|g' manifest.plist
echo "$VERSION" | xargs -I {} sed -i ''  's|%%version-artifact%%|{}|g' manifest.plist
echo "$ARTIFACT" | xargs -I {} sed -i ''  's|%%name-artifact%%|{}|g' manifest.plist

git add . -A
git commit -m "$ARTIFACT $COMPILADO"
git push --set-upstream origin $ARTIFACT/$COMPILADO
git checkout temp-web
git merge $ARTIFACT/$COMPILADO
git push

exit 0