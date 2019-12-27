## Rust/Elm Webapp

This example is part of a tutorial showing how to create a highly interactive web page with [Elm](https://elm-lang.org) which uses [Rust](https://rust-lang.org) functions exported through [WebAssembly](https://webassembly.org).

The webapp runs on [Express - Node.js](https://expressjs.com/).

### Software Requirements

The program requires recent versions of:
* [Rustup](https://rustup.rs)
* [Wasm Pack](https://rustwasm.github.io/wasm-pack/)
* [Node.js](https://nodejs.org) 
* [Elm Compiler](https://github.com/elm/compiler)

### Install & Run

To run the example on your local machine, run from your terminal:

`git clone https://github.com/vegapit/rust-elm-gui.git`
`cd rust-elm-gui`
`wasm-pack build --release --target nodejs`
`cd www`
`npm install`
`elm make elm/Index.elm --output=public/js/index.js`
`node main.js`

Open your browser to [http://localhost:8080/](http://localhost:8080/) to see it in action
