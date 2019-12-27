const express = require('express')
const expresshandlebars = require('express-handlebars')
const bodyParser = require('body-parser')

const wasm = require('rust-elm-gui')

const handlebars = expresshandlebars.create({
    defaultLayout:'main'
})

let app = express()
app.set('port', 8080)
app.engine('handlebars', handlebars.engine)
app.set('view engine', 'handlebars')
app.use(express.static('public'))
app.use(bodyParser.json())

app.get('/', function(req,res){
    res.render('index')
})

app.post('/api/calculate', function(req,res) {
    let obj = req.body // BobyParser converting directly to JSON
    let calc = wasm.pricer_black76(
        obj.cp,
        parseFloat(obj.s),
        parseFloat(obj.k),
        parseFloat(obj.t),
        parseFloat(obj.v),
        parseFloat(obj.r)
    )
    obj.price = calc.get("price").toFixed(4)
    obj.delta = calc.get("delta").toFixed(4)
    res.json(obj)
})

app.listen(app.get('port'), function(){
    console.log('Express started on port ' + app.get('port') + ' - Press Ctrl+C to terminate')
})