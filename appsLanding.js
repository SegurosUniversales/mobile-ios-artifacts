fetch('./app.json')
    .then((response) => response.json())
    .then((json) => {
        let ulIos = document.getElementById("ios-apps-list-container");
        
        for (const app in json) {
            if (Object.hasOwnProperty.call(json, app)) {
                const element = json[app];
                let li = `<li>
                <a href="itms-services://?action=download-manifest&url=https://apps.universales.com/${app}/${element.version}/manifest.plist" title="v: ${element.version}">
                    <img src="imgs/logoApp.svg" alt="${app}"> 
                   Ajustadores
                </a>
             </li> `; 
                
                ulIos.innerHTML += li.trim();   
            }
        }
});