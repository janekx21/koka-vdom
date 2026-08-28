The Elm Architecture (TEA) in koka with a virtual dom in koka.

Here is the good old counter example.

```kk
import vdom
import html
import events

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
  div([], [
    button([Decrease.on-click], ["-".node]),
    model.show.node,
    button([Increase.on-click], ["+".node])
  ])
```

Or just the vdom version

```kk
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
```

Build example with
```
koka --target js example-todo.kk
```

Or develop using
```
watchexec -e kk -r "koka --target js example-effect.kk"
```

Serve with
```
http-server <out-dir>
```



