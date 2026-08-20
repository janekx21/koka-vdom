struct node
  tag : string
  children : list<node>
  attribues : list<attribute>
  text : string

struct attribute
  key : string
  value : string

fun render(node : node)
  if node.children.is-empty then
    "<" ++ node.tag ++ "/>"
  else
    "<" ++ node.tag ++ ">" ++ node.children.map(render).join  ++ "</" ++ node.tag ++ ">"

fun node(tag : string)
  Node(tag, [], [], "")

fun text(str : string)
  Node("text", [], [] , str)

fun with-children(node : node, children : list<node>)
  node(children = children)

fun main()
  node("div").with-children([node("p").with-children([text("hi")])]).render.println

