extern import
  js file "html.js"

extern render-node(node : node) :  ()
  js "_render_node"

type node<msg>
  Text( value : string )
  Elem( tag : string, attrs : list<attribute<msg>>, children : list<node<msg>> )

type attribute<msg>
  Prop( name : string, value : string )
  Style( name : string, value : string )
  Handler( name : string, to-msg : (dom-event) -> msg )

type attr-op<msg>
  Set( a : attribute<msg> )
  Rem( a : attribute<msg> )

type child-op<msg>
  Insert( index : int, n : node<msg> )
  Remove( index : int )
  Move( from : int, to : int )
  Update( index : int, p : patch<msg> )

type patch<msg>
  PNone
  PReplace( new : node<msg> )
  PText( value : string )
  PUpdate( attrs : list<attr-op<msg>>, children : list<child-op<msg>> )

fun changed-attrs( old : list<attribute<msg>>, new : list<attribute<msg>> ) : list<attr-op<msg>>
  match new
    Nil -> []
    Cons(b,rest) ->
      val tail = changed-attrs(old, rest)
      match b
        Handler(_,_) -> Cons(Set(b), tail)   // always re-set, never diffed structurally
        _ ->
          match find-attr(b.attr-name, old)
            Nothing -> Cons(Set(b), tail)
            Just(a) -> if a.attr-equal(b) then tail else Cons(Set(b), tail) 

fun indent(depth : int) : string
  "  ".repeat(depth)

fun render(node : node, depth : int = 0)
  if node.children.is-empty then
    if node.tag == "text" then
      indent(depth) ++ node.text ++ "\n"
    else
      indent(depth) ++ "<" ++ node.tag ++ "/>\n"
  else
    indent(depth) ++ "<" ++ node.tag ++ ">\n"
      ++ node.children.map(fn (x) render(x, depth + 1)).join
      ++ indent(depth) ++ "</" ++ node.tag ++ ">\n"

fun node(tag, attr, children)
  Node(tag, attr, children, "")

fun text(str : string)
  Node("text", [], [] , str)

fun div(attr, children)
  node("div", attr, children)

fun p(attr, children)
  node("p", attr, children)

fun main()
  val root = div([], [
    p([], [
      text("HI")
    ])
  ])

  // root.render.println

  render-node(root)

