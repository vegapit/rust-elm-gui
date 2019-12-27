module Index exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Encode as JE
import Json.Decode as JD

type alias Model = 
    { 
        cp: String
        , s: String
        , k: String
        , t: String
        , v: String
        , r: String
        , price: String
        , delta: String
    }

type Msg
    = SetCallPut String
    | SetS String
    | SetK String
    | SetT String
    | SetV String
    | SetR String
    | Calculate
    | ReceivedCalculation (Result Http.Error Model)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- Init

init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "Call" "100.0" "100.0" "1.0" "0.3" "0.05" "" "", Cmd.none )

-- Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetCallPut cp ->
            ( { model | cp = cp, price = "", delta = "" }, Cmd.none )
        SetS s ->
            ( { model | s = s, price = "", delta = "" }, Cmd.none )
        SetK k ->
            ( { model | k = k, price = "", delta = "" }, Cmd.none )
        SetT t ->
            ( { model | t = t, price = "", delta = "" }, Cmd.none )
        SetV v ->
            ( { model | v = v, price = "", delta = "" }, Cmd.none )
        SetR r ->
            ( { model | r = r, price = "", delta = "" }, Cmd.none )
        Calculate ->
            let
                encodedModel = model
                    |> encoderModel
            in
                ( model, apirequest encodedModel )
        ReceivedCalculation res ->
            case res of
               Ok data -> ( data, Cmd.none )
               Err _ -> ( model, Cmd.none )

apirequest : JE.Value -> Cmd Msg
apirequest encodedmodel = 
    Http.post
        { url = "/api/calculate"
        , body = jsonBody encodedmodel
        , expect = Http.expectJson ReceivedCalculation (decoderModel)
        }

encoderModel : Model -> JE.Value
encoderModel model =
    JE.object
        [ 
            ( "cp", JE.string model.cp )
            , ( "s", JE.string model.s )
            , ( "k", JE.string model.k )
            , ( "t", JE.string model.t )
            , ( "v", JE.string model.v )
            , ( "r", JE.string model.r )
            , ( "price", JE.string model.price )
            , ( "delta", JE.string model.delta )
        ]

decoderModel: JD.Decoder Model
decoderModel = 
    JD.map8
        Model
        (JD.field "cp" JD.string)
        (JD.field "s" JD.string)
        (JD.field "k" JD.string)
        (JD.field "t" JD.string)
        (JD.field "v" JD.string)
        (JD.field "r" JD.string)
        (JD.field "price" JD.string)
        (JD.field "delta" JD.string)

-- View

view : Model -> Html Msg
view model =
    div [class "container"]
        [   
            htmlTable model
        ]

htmlTable: Model -> Html Msg
htmlTable model = 
    table [] 
        [
            tr[]
                [
                    td [] [ text "CallPut" ]
                    , td [] [ select [onInput SetCallPut] [ option[value "Call"] [text "Call"], option[value "Put"] [text "Put"] ] ]
                ]
            , tr[]
                [
                    td [] [ text "Underlying" ]
                    , td [] [ input [type_ "text", onInput SetS, value model.s] [ text "100.0" ] ]
                ]
            , tr[]
                [
                    td [] [ text "Strike" ]
                    , td [] [ input [type_ "text", onInput SetK, value model.k] [ text "100.0" ] ]
                ]
            , tr[]
                [
                    td [] [ text "Time-to-expiry" ]
                    , td [] [ input [type_ "text", onInput SetT, value model.t] [ text "1.0" ] ]
                ]
            , tr[]
                [
                    td [] [ text "Volatility" ]
                    , td [] [ input [type_ "text", onInput SetV, value model.v] [ text "0.3" ] ]
                ]
            , tr[]
                [
                    td [] [ text "Risk-free Rate" ]
                    , td [] [ input [type_ "text", onInput SetR, value model.r] [ text "0.05" ] ]
                ]
            , tr[]
                [
                    td [] []
                    , td [] [ button [class "btn", onClick Calculate ] [ text "Calculate" ] ]
                ]
            , tr[] [ td [] [ text "Price" ], td[] [ text model.price ] ]
            , tr[] [ td [] [ text "Delta" ], td[] [ text model.delta ] ]
        ]

-- Main

main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }