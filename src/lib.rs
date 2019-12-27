extern crate js_sys;
extern crate itertools;
extern crate wasm_bindgen;

mod black76;

use wasm_bindgen::prelude::*;
use js_sys::Map;
use crate::black76::{Black76, CallPut};

#[wasm_bindgen]
pub fn pricer_black76(callput: &str, s: f64, k: f64, t: f64, v: f64, r: f64) -> Map {
    let cp = match callput {
        "Call" => CallPut::Call,
        "Put" => CallPut::Put,
        _ => panic!("Option type unknown")
    };
    let opt = Black76::new(cp, s, k, t, v, r);
    let res = Map::new();
    res.set( &JsValue::from_str("price"), &JsValue::from_f64(opt.price()) );
    res.set( &JsValue::from_str("delta"), &JsValue::from_f64(opt.delta()) );
    res
}
