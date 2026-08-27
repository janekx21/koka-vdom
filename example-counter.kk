import vdom

pub fun main() : io ()
  run-app(init(), update, view, "#app")

type msg
  Increase
  Decrease

alias model = int

fun init()
  0

fun update( msg : msg, model : model ) : model
  match msg
    Increase -> model + 1
    Decrease -> model - 1

fun view( model : model ) : node<msg>
  Elem("div", [], [
    Elem("button", [Handler("click", Decrease)], [Text("-")]),
    Text(model.show),
    Elem("button", [Handler("click", Increase)], [Text("+")])
  ])

