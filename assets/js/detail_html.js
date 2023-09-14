const head = document.querySelector('head')
const meta = document.createElement('meta')
const body = document.querySelector('body')
meta.setAttribute('name', 'viewport')
meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, viewport-fit=cover')
head.appendChild(meta)

const style = document.createElement('style')
style.innerHTML = `
  * {margin: 0; padding: 0;}
  html {width: 100%; overflow-x: hidden;}
  body {display: inline-block; width: 100%; padding: 5px; box-sizing: border-box; }
  img {max-width: 100%; height: auto;}
`
head.appendChild(style)
