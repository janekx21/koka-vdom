// vdom.kk
//
// A small Elm-architecture virtual DOM for Koka.
//   - node<m> / attribute<m>   : the vdom tree, parametric in a message type
//   - diff / patch<m>            : structural diff producing a patch list
//   - dom-node / dom-event         : opaque (:: V) handles into the real JS DOM
//   - js-*                         : plain `io` extern calls into the real browser DOM
//   - run-app                      : Elm-style runtime (init, update, view)
//
// Pairs with vdom-dom.js, which implements the `kk_dom_*` functions referenced
// by the `extern` declarations below.
//
// DOM access is done via plain `io` extern calls rather than a user-defined
// `effect dom` + handler. A handler's scope only lasts as long as the block
// that installs it runs, but a UI needs to keep responding to browser events
// (clicks, etc.) firing from a fresh call into the JS event loop, long after
// that block has returned -- an effect handler has nothing to hand back to
// evidence lookup at that point. Plain `io` calls have no such scope to
// outlive, so they work correctly from any callback at any time.


// ----------------------------------------------------------------------------
// Opaque handles into the JS world. Koka never inspects these; it only ever
// passes them to `dom` operations or receives them back.
// ----------------------------------------------------------------------------

type dom-node :: V
type dom-event :: V


// ----------------------------------------------------------------------------
// FFI bindings. Each `extern` here delegates to a plain function defined in
// vdom-dom.js, spliced into the generated JS module by `extern import`.
// ----------------------------------------------------------------------------

extern import
  js file "vdom-inner.js"

// NOTE: every one of these is marked `io`. There is deliberately no `effect
// dom` / handler layer anymore -- a normal Koka handler is scoped to the
// dynamic extent of the block that installs it, and that block (run-app's
// body) returns as soon as the initial mount is done. A click fired later
// comes from a fresh call into the JS event loop with no relation to that
// original call stack, so a handler-scoped effect has nothing left to look
// up by the time it fires (that was the `ev is undefined` crash). Plain
// `io` extern calls have no dynamic scope to lose, so they work from any
// callback, at any time, permanently.

extern js-create-element( tag : string ) : io dom-node
  js "kk_dom_create_element"

extern js-create-text( value : string ) : io dom-node
  js "kk_dom_create_text"

extern js-set-text( n : dom-node, value : string ) : io ()
  js "kk_dom_set_text"

extern js-set-attr( n : dom-node, name : string, value : string ) : io ()
  js "kk_dom_set_attr"

extern js-remove-attr( n : dom-node, name : string ) : io ()
  js "kk_dom_remove_attr"

extern js-set-handler( n : dom-node, name : string, callback : (dom-event) -> io () ) : io ()
  js "kk_dom_set_handler"

extern js-remove-handler( n : dom-node, name : string ) : io ()
  js "kk_dom_remove_handler"

extern js-append-child( parent : dom-node, child : dom-node ) : io ()
  js "kk_dom_append_child"

extern js-remove-child( parent : dom-node, index : int ) : io ()
  js "kk_dom_remove_child"

extern js-replace-child( parent : dom-node, index : int, new-node : dom-node ) : io ()
  js "kk_dom_replace_child"

extern js-child-at( parent : dom-node, index : int ) : io dom-node
  js "kk_dom_child_at"

extern js-mount-root( n : dom-node, selector : string ) : io ()
  js "kk_dom_mount_root"

extern js-prevent-default( ev : dom-event ) : io ()
  js "kk_dom_prevent_default"

extern js-event-target( ev : dom-event ) : io dom-node
  js "kk_dom_event_target"


// ----------------------------------------------------------------------------
// The virtual DOM tree, parametric in a message type `m`.
// ----------------------------------------------------------------------------

type node<m>
  Text( value : string )
  Elem( tag : string, attrs : list<attribute<m>>, kids : list<node<m>> )

type attribute<m>
  Prop( name : string, value : string )
  Style( name : string, value : string )
  Handler( name : string, m : m )                        // fixed message, e.g. onClick Increment
  HandlerWith( name : string, decode : (dom-event) -> m )  // needs event data, e.g. onInput

type attr-op<m>
  Set( a : attribute<m> )
  Rem( a : attribute<m> )

type child-op<m>
  Insert( index : int, n : node<m> )
  Remove( index : int )
  Move( from : int, to : int )
  Update( index : int, p : patch<m> )

type patch<m>
  PNone
  PReplace( new : node<m> )
  PText( value : string )
  PUpdate( attrs : list<attr-op<m>>, children : list<child-op<m>> )


// ----------------------------------------------------------------------------
// Diffing. Handler / HandlerWith are never compared structurally (closures
// aren't comparable, and it isn't worth threading an explicit m-equality
// function through just to skip an already-O(1) property assignment) -- they
// are always re-set on every diff.
// ----------------------------------------------------------------------------

fun attr-name( a : attribute<m> ) : string
  match a
    Prop(n,_)        -> n
    Style(n,_)       -> n
    Handler(n,_)     -> n
    HandlerWith(n,_) -> n

fun attr-equal( a : attribute<m>, b : attribute<m> ) : bool
  match (a, b)
    (Prop(n1,v1), Prop(n2,v2))   -> n1 == n2 && v1 == v2
    (Style(n1,v1), Style(n2,v2)) -> n1 == n2 && v1 == v2
    _ -> False   // Handler / HandlerWith: handled specially in changed-attrs

fun find-attr( name : string, attrs : list<attribute<m>> ) : maybe<attribute<m>>
  match attrs
    Nil -> Nothing
    Cons(a,rest) -> if a.attr-name == name then Just(a) else find-attr(name, rest)

fun diff-attrs( old : list<attribute<m>>, new : list<attribute<m>> ) : list<attr-op<m>>
  removed-attrs(old, new) ++ changed-attrs(old, new)

fun removed-attrs( old : list<attribute<m>>, new : list<attribute<m>> ) : list<attr-op<m>>
  match old
    Nil -> []
    Cons(a,rest) ->
      if find-attr(a.attr-name, new).is-nothing
        then Cons(Rem(a), removed-attrs(rest, new))
        else removed-attrs(rest, new)

fun changed-attrs( old : list<attribute<m>>, new : list<attribute<m>> ) : list<attr-op<m>>
  match new
    Nil -> []
    Cons(b,rest) ->
      val tail = changed-attrs(old, rest)
      match b
        Handler(_,_)     -> Cons(Set(b), tail)
        HandlerWith(_,_) -> Cons(Set(b), tail)
        _ ->
          match find-attr(b.attr-name, old)
            Nothing -> Cons(Set(b), tail)
            Just(a) -> if a.attr-equal(b) then tail else Cons(Set(b), tail)

fun diff-children( old : list<node<m>>, new : list<node<m>> ) : div list<child-op<m>>
  diff-children-at(old, new, 0)

fun diff-children-at( old : list<node<m>>, new : list<node<m>>, i : int ) : div list<child-op<m>>
  match (old, new)
    (Nil, Nil)               -> []
    (Nil, Cons(y,ys))        -> Cons(Insert(i,y), diff-children-at([], ys, i + 1))
    (Cons(_,xs), Nil)        -> Cons(Remove(i), diff-children-at(xs, [], i))
    (Cons(x,xs), Cons(y,ys)) ->
      val rest = diff-children-at(xs, ys, i + 1)
      match diff(x, y)
        PNone -> rest
        p     -> Cons(Update(i,p), rest)
    _ -> []

fun diff( old : node<m>, new : node<m> ) : div patch<m>
  match (old, new)
    (Text(a), Text(b)) -> if a == b then PNone else PText(b)
    (Elem(t1,a1,c1), Elem(t2,a2,c2)) ->
      if t1 != t2 then PReplace(new)
      else
        val attrs = diff-attrs(a1, a2)
        val kids  = diff-children(c1, c2)
        if attrs.is-empty && kids.is-empty then PNone else PUpdate(attrs, kids)
    _ -> PReplace(new)   // different constructor -> tear down, rebuild


// ----------------------------------------------------------------------------
// Mounting a fresh tree, and applying a patch to an existing one. Both take a
// `dispatch` function that turns a produced `m` into an actual io () action
// -- this is what lets `view` stay a pure `(model) -> node<m>` function.
// ----------------------------------------------------------------------------

fun mount( dispatch : (m) -> io (), n : node<m> ) : io dom-node
  match n
    Text(v) -> js-create-text(v)
    Elem(tag, attrs, kids) ->
      val el = js-create-element(tag)
      attrs.foreach fn(a)
        match a
          Prop(name,value)         -> js-set-attr(el, name, value)
          Style(name,value)        -> js-set-attr(el, "style:" ++ name, value)
          Handler(name,m)        -> js-set-handler(el, name, fn(_ev) dispatch(m))
          HandlerWith(name,decode) -> js-set-handler(el, name, fn(ev) dispatch(decode(ev)))
      kids.foreach fn(c) js-append-child(el, mount(dispatch, c))
      el

fun apply-patch( dispatch : (m) -> io (), parent : dom-node, index : int, p : patch<m> ) : io ()
  match p
    PNone       -> ()
    PReplace(n) -> js-replace-child(parent, index, mount(dispatch, n))
    PText(v)    -> js-set-text(js-child-at(parent, index), v)
    PUpdate(attr-ops, child-ops) ->
      val el = js-child-at(parent, index)
      attr-ops.foreach fn(op)
        match op
          Set(Prop(name,value))         -> js-set-attr(el, name, value)
          Set(Style(name,value))        -> js-set-attr(el, "style:" ++ name, value)
          Set(Handler(name,m))        -> js-set-handler(el, name, fn(_ev) dispatch(m))
          Set(HandlerWith(name,decode)) -> js-set-handler(el, name, fn(ev) dispatch(decode(ev)))
          Rem(Prop(name,_))             -> js-remove-attr(el, name)
          Rem(Style(name,_))            -> js-remove-attr(el, "style:" ++ name)
          Rem(Handler(name,_))          -> js-remove-handler(el, name)
          Rem(HandlerWith(name,_))      -> js-remove-handler(el, name)
      child-ops.foreach fn(op)
        match op
          Insert(_,n)  -> js-append-child(el, mount(dispatch, n))
          Remove(i)    -> js-remove-child(el, i)
          Move(_,_)    -> ()
          Update(i,p2) -> apply-patch(dispatch, el, i, p2)


// ----------------------------------------------------------------------------
// The Elm-architecture runtime. This is the only place `ref` is used --
// app code (init/update/view) stays completely pure.
// ----------------------------------------------------------------------------

fun run-app( init : model, update : (m, model) -> model, view : (model) -> node<m>, selector : string ) : io ()
  val root = js-create-element("div")
  js-mount-root(root, selector)

  val current-model = ref(init)
  val current-tree  = ref(view(init))

  fun dispatch( m )
    current-model := update(m, !current-model)
    val next = view(!current-model)
    apply-patch(dispatch, root, 0, diff(!current-tree, next))
    current-tree := next

  val mounted = mount(dispatch, !current-tree)
  js-append-child(root, mounted)


// ----------------------------------------------------------------------------
// Example app: a click counter, Elm-style.
// ----------------------------------------------------------------------------

struct model
  count : list<string>

type msg
  Increment
  Decrement

fun init() : model
  Model([])

fun update( msg : msg, model : model ) : model
  match msg
    Increment -> model( count = model.count ++ ["A"] )
    Decrement -> model( count = model.count )

fun view( model : model ) : node<msg>
  Elem("div", [], [
    Text("Clicks: " ++ model.count.show),
    Elem("button", [Handler("click", Increment)], [Text("+1")]),
    Elem("button", [Handler("click", Decrement)], [Text("-1")])
  ] ++ model.count.map(fn (x) { Elem("div", [], [Text("X")]) }))

pub fun main() : io ()
  run-app(init(), update, view, "#app")
