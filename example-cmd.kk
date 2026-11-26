import vdom
import html
import events

pub fun main() : io ()
  run-app-cmd(init(), update, view, "#app")

type msg
  GetData
  GotData(body : string)

alias model = remote-string

type remote-string
  NotAsked
  Loading
  Succ(body : string)

fun remote-string/show(value : remote-string)
  match value
    NotAsked -> "Not Asked"
    Loading -> "Loading ..."
    Succ(data) -> "Success: " ++ data
  

fun init() : (model, cmd<msg>)
  (NotAsked, None)

fun update( msg : msg, model : model ) : (model, cmd<msg>)
  match msg
    GetData -> (Loading, HttpRequest("GET", "http://example.com", "", fn(x) GotData(x)))
    GotData(data) -> (Succ(data), None)

fun view( model : model ) : node<msg>
  div([], [
    h1([],[text("Cmd Example")]),
    model.show.node,
    button([GetData.on-click], ["get data".node]),
  ])

