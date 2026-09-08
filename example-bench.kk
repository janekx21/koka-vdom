import vdom
import html
import events

pub fun main() : io ()
  run-app(init(), update, view, "#app")

type msg
  SetOneThousendRows
  SetTenThousendRows
  AddOneThousendRows

alias model = list<string>

fun init()
  []


fun init-list(n) : list<string>
  var l := []
  range/for(0, n, fn(i) {
      l := l ++ [int/show(i)]
      ()
    })
  l
  

fun update( msg : msg, model : model ) : model
  match msg
    SetOneThousendRows -> init-list(1000)
    SetTenThousendRows -> init-list(10000)
    AddOneThousendRows -> init-list(1000) ++ model
        
      
fun view( model : model ) : node<msg>
  div([], [
    button([SetOneThousendRows.on-click], ["SetOneThousendRows".node]),
    button([SetTenThousendRows.on-click], ["SetTenThousendRows".node]),
    button([AddOneThousendRows.on-click], ["AddOneThousendRows".node]),
    div([], model.map(fn(t) div([], [t.node])))
  ])

