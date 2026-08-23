import vdom

pub fun main() : io ()
  run-app(init(), update, view, "#app")

type msg
  Input( text : string )
  AddItem
  Reset

struct model
  text : string
  items : list<string>

fun init()
  Model("hi", [])

fun update( msg : msg, model : model ) : model
  match msg
    Input(t)  -> model( text = t )
    AddItem -> model(text = "", items = model.items ++ [model.text])
    Reset -> model(items = [])

fun view( model : model ) : node<msg>
  Elem("div", [], [
    Elem("input", [
      Prop("type", "text"),
      Prop("value", model.text),
      HandlerWith("input", fn(ev) Input(js-event-value(ev)))
    ], []),
    Elem("button", [Handler("click", AddItem)], [Text("Add")]),
    Elem("button", [Handler("click", Reset)], [Text("Reset")]),
    Text("You typed: " ++ model.text),
    Elem("ul", [],
      model.items.map(fn (item) { Elem("li", [], [Text(item)]) })
    )
  ])

