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

git clone --depth=1 --branch web git@github.com:SegurosUniversales/mobile-ios-artifacts.git repo

cd repo || echo "repo not found" && exit 1

git fetch origin temp-web:temp-web --depth=1

git checkout -b "$ARTIFACT/$COMPILADO"

mkdir -p "$ARTIFACT/$COMPILADO"

cd "$ARTIFACT/$COMPILADO/" || echo "artifact not build" && exit 1

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

git add .
git commit -m "$ARTIFACT $COMPILADO"
git push --set-upstream origin "$ARTIFACT/$COMPILADO"
git checkout temp-web
git merge "$ARTIFACT/$COMPILADO" --allow-unrelated-histories --no-edit
git diff
git push --set-upstream origin temp-web