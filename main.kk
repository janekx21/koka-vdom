
extern import
  js file "html.js"

extern render-node(node : node) :  ()
  js "_render_node"

struct node
  tag : string
  attribues : list<attribute>
  children : list<node>
  text : string

struct attribute
  key : string
  value : string


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

