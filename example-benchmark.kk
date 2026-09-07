import vdom
import html
import events

pub fun main() : io ()
  run-app(init(), update, view, "#app")

type msg
  Add1k
  Reset

alias model = list<int>

fun init()
  []

fun update( msg : msg, model : model ) : model
  match msg
    Add1k -> model ++ elemens(1000)
    Reset -> []

fun elemens(num)
  var l := []
  for(num) fn(i)
    l := l ++ [i]
  l

fun view( model : model ) : node<msg>
  div([], [
    button([Add1k.on-click], ["Add1k".node]),
    button([Reset.on-click], ["Reset".node]),
    div([], model.map(fn (x) div([], [x.show.node])))
    // , "hello?".node
  ])

