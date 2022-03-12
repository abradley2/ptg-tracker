const node = document.createElement('div')

document.body.appendChild(node)

Promise.all([
    fetch('translations/translations.en.json'),
    fetch('translations/translations.es.json'),
].map((req) => req.then((res) => res.json())))
    .then(([langEn, langEs]) => {
        console.log({ langEn, langEs })
        const app = (window as any).Elm.Main.init({
            flags: {
                langEn,
                langEs
            },
            node
        })

        console.log(app)
    })

