fetch('./app.json')
    .then((response) => response.json())
    .then((json) => {
        let ulIos = document.getElementById("ios-apps-list-container");
        let ulAnd = document.getElementById("android-apps-list-container");
        let itemIos = "";
        let itemAnd = "";
        for (const app in json) {
            if (Object.hasOwnProperty.call(json, app)) {
                const element = json[app];
                
                switch(element.type){
                    case 0: // IOS && Android
                    itemIos = `<li>
                        <a href="itms-services://?action=download-manifest&url=https://apps.universales.com/${app}/${element.version}/manifest.plist" title="v: ${element.version}">
                            <img src="imgs/logoApp.svg" alt="${app}"> 
                        ${app}
                        </a>
                    </li>`;
                    itemAnd = `<li>
                        <a href="https://apps.universales.com/${app}/${element.version}/${app}" title="v: ${element.version}" download>
                            <img src="imgs/logoApp.svg" alt="${app}"> 
                        ${app}
                        </a>
                    </li>`;
                    ulIos.innerHTML += itemIos.trim();
                    ulAnd.innerHTML += itemAnd.trim();
                    break;
                    case 1: // IOS
                    itemIos = `<li>
                        <a href="itms-services://?action=download-manifest&url=https://apps.universales.com/${app}/${element.version}/manifest.plist" title="v: ${element.version}">
                            <img src="imgs/logoApp.svg" alt="${app}"> 
                        ${app}
                        </a>
                    </li>`;
                    ulIos.innerHTML += itemIos.trim();   
                    break;
                    case 2: // Android
                    itemAnd = `<li>
                        <a href="https://apps.universales.com/${app}/${element.version}/${app}" title="v: ${element.version}" download>
                            <img src="imgs/logoApp.svg" alt="${app}"> 
                        ${app}
                        </a>
                    </li>`;
                    ulAnd.innerHTML += itemAnd.trim();
                    break;
                }              
            }
        }
});