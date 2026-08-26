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

effect theme-color
  val background-color : string
  val foreground-color : string
  val primary-color : string

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
    , Style("background-color", background-color)
    , Style("padding", "1rem")
    , Style("gap", "1rem")
    ] ++ attr, children)

fun hbox(attr, children)
  Elem("div", [
    Style("display", "flex")
    , Style("flex-direction", "row")
    , Style("background-color", background-color)
    , Style("padding", "1rem")
    , Style("gap", "1rem")
    ] ++ attr, children)

fun line-input(attr)
  Elem("input", [
    Style("background-color", background-color),
    Style("border", "2px solid " ++ primary-color),
    Style("border-radius", "16px"),
    Style("color", foreground-color),
    Style("padding", "4px 8px")
  ] ++ attr, [])

fun button(attr, children)
  Elem("button", [
    Style("background-color", foreground-color),
    Style("color", background-color),
    Style("border", "none"),
    Style("border-radius", "16px"),
    Style("padding", "8px"),
    Style("cursor", "pointer"),
  ] ++ attr, children)
  
fun theme-button(theme : theme)
  with theme.handle-color
  button([Handler("click", SetTheme(theme))], [Text(theme.name)])

fun theme/name(theme : theme)
  match theme
    Light -> "Light"
    Dark -> "Dark"
    Retro -> "Retro"

fun theme/handle-color(theme, action)
  with
   val background-color = match theme
     Light -> "white"
     Dark -> "black"
     Retro -> "oklch(88.272% 0.049 91.774)"
   val foreground-color = match theme
     Light -> "black"
     Dark -> "white"
     Retro -> "oklch(41% 0.112 45.904)"
   val primary-color =  match theme
     Light -> "oklch(45% 0.24 277.023)"
     Dark -> "oklch(58% 0.233 277.117)"
     Retro -> "oklch(80% 0.114 19.571)"

  action()

fun view( model : model ) : node<msg>
  with model.theme.handle-color
   
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
      hbox([], [
        theme-button(Light),
        theme-button(Dark),
        theme-button(Retro),
      ]),
    ])

