import vdom

pub fun main() : io ()
  run-app(init(), update, view, "#app")

struct model
  username : string
  password : string
  theme : theme

type theme
  Light
  Dark
  Retro

type msg
  SetUsername(text : string)
  SetPassword(text : string)
  SetTheme(theme : theme)


fun init()
  Model("your-username", "your-password", Dark)

fun update( msg : msg, model : model ) : model
  match msg
    SetUsername(t)  -> model( username = t )
    SetPassword(t)  -> model( password = t )
    SetTheme(t)  -> model( theme = t )

fun vbox(attr, children)
  Elem("div", [
    Style("display", "flex")
    , Style("flex-direction", "column")
    , Style("background-color", "black")
    , Style("padding", "1rem")
    , Style("gap", "1rem")
    ] ++ attr, children)

fun line-input(attr)
  Elem("input", [
    Style("background-color", "black"),
    Style("border", "2px solid white"),
    Style("border-radius", "16px"),
    Style("color", "white"),
    Style("padding", "4px 8px")
  ] ++ attr, [])

fun button(attr, children)
  Elem("button", [
    Style("background-color", "white"),
    Style("color", "black"),
    Style("border", "none"),
    Style("border-radius", "16px"),
  ] ++ attr, children)
  

fun view( model : model ) : node<msg>
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
    ])

