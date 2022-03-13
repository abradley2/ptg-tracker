import { FocusMenu } from './FocusMenu'

const node = document.createElement('div')

document.body.appendChild(node)

window.customElements.define('focus-menu', FocusMenu)

Promise.all([
  fetch('translations/translations.en.json'),
  fetch('translations/translations.es.json')
].map(async (req) => await req.then(async (res) => await res.json())))
  .then(([langEn, langEs]) => {
    const app = (window as any).Elm.Main.init({
      flags: {
        langEn,
        langEs
      },
      node
    })

    console.log(app)
  })
