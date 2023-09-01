fetch('./app.json')
    .then((response) => response.json())
    .then((json) => {
        let ul = document.getElementById("apps-list-container");

        console.log(json);
        for (const app in json) {
            if (Object.hasOwnProperty.call(json, app)) {
                const element = json[app];
                let li = `<li>
                <a href="itms-services://?action=download-manifest&url=https://apps.universales.com/Ajustadores/${element.version}/manifest.plist">
                    <img src="imgs/logoApp.svg" alt="${app}"> Ajustadores
                    <span>${element.package}</span>
                </a>
            </li>`;
                ul.innerHTML += li.trim();   
            }
        }
});
