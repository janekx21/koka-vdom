import vdom

pub fun main() : io ()
  run-app(init(), update, view, "#app")

struct model
  username : string
  password : string

type msg
  SetUsername(text : string)
  SetPassword(text : string)

// An effect that can yield nodes
effect yield
  fun yield( node : node<msg> ) : ()

// A handler that yields the node from the action
fun yield-self(action)
  val r = action()
  yield(r)
  r

fun init()
  Model("your-username", "your-password")

fun update( msg : msg, model : model ) : model
  match msg
    SetUsername(t)  -> model( username = t )
    SetPassword(t)  -> model( password = t )

fun vbox(attr, children)
  with yield-self // This yields the following node
  Elem("div", [
    Style("display", "flex")
    , Style("flex-direction", "column")
    // , Style("background-color", background-color)
    , Style("padding", "1rem")
    , Style("gap", "1rem")
    ] ++ attr, children)

fun hbox(attr, children)
  with yield-self
  Elem("div", [
    Style("display", "flex")
    , Style("flex-direction", "row")
    // , Style("background-color", background-color)
    , Style("padding", "1rem")
    , Style("gap", "1rem")
    ] ++ attr, children)

fun line-input(attr)
  with yield-self
  Elem("input", [
    // Style("background-color", background-color),
    Style("border", "2px solid black"),
    Style("border-radius", "16px"),
    // Style("color", foreground-color),
    Style("padding", "4px 8px")
  ] ++ attr, [])

fun button(attr, children)
  with yield-self
  Elem("button", [
    // Style("background-color", foreground-color),
    // Style("color", background-color),
    Style("border", "none"),
    Style("border-radius", "16px"),
    Style("padding", "8px"),
    Style("cursor", "pointer"),
  ] ++ attr, children)
 

fun view( model : model ) : node<msg>
  var nodes := []
  with fun yield(v : node<msg>)
    nodes := nodes ++ [v]
 
  vbox([Style("max-width", "15rem")],
    [
      line-input([
        Prop("type", "text"),
        Prop("value", model.username),
        HandlerWith("input", fn(ev) SetUsername(js-event-value(ev)))
      ]),
      line-input([
        Prop("type", "password"),
        Prop("value", model.password),
        HandlerWith("input", fn(ev) SetPassword(js-event-value(ev)))
      ]),
      button([], [Text("Login")]),

      Text("yielded " ++ nodes.length.show ++ " nodes:"),
      vbox([Style("border", "2px solid black")],nodes),
    ])

