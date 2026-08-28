module events

import vdom

// Lets also mirror https://github.com/elm/html/blob/1.0.1/src/Html/Events.elm

// MOUSE EVENTS

pub fun on-click(action)
  Handler("click", action)


pub fun on-double-click(action)
  Handler("dbclick", action)


pub fun on-mouse-down(action)
  Handler("mousedown", action)

pub fun on-mouse-up(action)
  Handler("mouseup", action)

pub fun on-mouse-enter(action)
  Handler("mouseenter", action)

pub fun on-mouse-leave(action)
  Handler("mouseleave", action)

pub fun on-mouse-over(action)
  Handler("mouseover", action)

pub fun on-mouse-out(action)
  Handler("mouseout", action)

// FORM EVENTS


// {-| Detect [input](https://developer.mozilla.org/en-US/docs/Web/Events/input)
// events for things like text fields or text areas.

// For more details on how `onInput` works, check out [`targetValue`](#targetValue).

// **Note 1:** It grabs the **string** value at `event.target.value`, so it will
// not work if you need some other information. For example, if you want to track
// inputs on a range slider, make a custom handler with [`on`](#on).

// **Note 2:** It uses `stopPropagationOn` internally to always stop propagation
// of the event. This is important for complicated reasons explained [here][1] and
// [here][2].

// [1]: /packages/elm/virtual-dom/latest/VirtualDom#Handler
// [2]: https://github.com/elm/virtual-dom/issues/125
// -}
// onInput : (String -> msg) -> Attribute msg
// onInput tagger =
//   stopPropagationOn "input" (Json.map alwaysStop (Json.map tagger targetValue))

// Detect input events for things like text fields or text areas. You have to decode the dom-event yourself.
pub fun on-input(action)
  HandlerWith("input", fn(e) action(js-event-value(e)))

// TODO

// alwaysStop : a -> (a, Bool)
// alwaysStop x =
//   (x, True)


// {-| Detect [change](https://developer.mozilla.org/en-US/docs/Web/Events/change)
// events on checkboxes. It will grab the boolean value from `event.target.checked`
// on any input event.

// Check out [`targetChecked`](#targetChecked) for more details on how this works.
// -}
// onCheck : (Bool -> msg) -> Attribute msg
// onCheck tagger =
//   on "change" (Json.map tagger targetChecked)


// {-| Detect a [submit](https://developer.mozilla.org/en-US/docs/Web/Events/submit)
// event with [`preventDefault`](https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault)
// in order to prevent the form from changing the page’s location. If you need
// different behavior, create a custom event handler.
// -}
// onSubmit : msg -> Attribute msg
// onSubmit msg =
//   preventDefaultOn "submit" (Json.map alwaysPreventDefault (Json.succeed msg))

// Detect a submit event. TODO do the prevent default!
pub fun on-submit(action)
  Handler("submit", action)

// alwaysPreventDefault : msg -> ( msg, Bool )
// alwaysPreventDefault msg =
//   ( msg, True )



// -- FOCUS EVENTS


// {-|-}
// onBlur : msg -> Attribute msg
// onBlur msg =
//   on "blur" (Json.succeed msg)

pub fun on-blur(action)
  Handler("blur", action)

// {-|-}
// onFocus : msg -> Attribute msg
// onFocus msg =
//   on "focus" (Json.succeed msg)

pub fun on-focus(action)
  Handler("focus", action)


// -- CUSTOM EVENTS


// {-| Create a custom event listener. Normally this will not be necessary, but
// you have the power! Here is how `onClick` is defined for example:

//     import Json.Decode as Decode

//     onClick : msg -> Attribute msg
//     onClick message =
//       on "click" (Decode.succeed message)

// The first argument is the event name in the same format as with JavaScript's
// [`addEventListener`][aEL] pub function.

// The second argument is a JSON decoder. Read more about these [here][decoder].
// When an event occurs, the decoder tries to turn the event object into an Elm
// value. If successful, the value is routed to your `update` pub function. In the
// case of `onClick` we always just succeed with the given `message`.

// If this is confusing, work through the [Elm Architecture Tutorial][tutorial].
// It really helps!

// [aEL]: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
// [decoder]: /packages/elm/json/latest/Json-Decode
// [tutorial]: https://github.com/evancz/elm-architecture-tutorial/

// **Note:** This creates a [passive][] event listener, enabling optimizations for
// touch, scroll, and wheel events in some browsers.

// [passive]: https://github.com/WICG/EventListenerOptions/blob/gh-pages/explainer.md
// -}
// on : String -> Json.Decoder msg -> Attribute msg
// on event decoder =
//   VirtualDom.on event (VirtualDom.Normal decoder)


// {-| Create an event listener that may [`stopPropagation`][stop]. Your decoder
// must produce a message and a `Bool` that decides if `stopPropagation` should
// be called.

// [stop]: https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation

// **Note:** This creates a [passive][] event listener, enabling optimizations for
// touch, scroll, and wheel events in some browsers.

// [passive]: https://github.com/WICG/EventListenerOptions/blob/gh-pages/explainer.md
// -}
// stopPropagationOn : String -> Json.Decoder (msg, Bool) -> Attribute msg
// stopPropagationOn event decoder =
//   VirtualDom.on event (VirtualDom.MayStopPropagation decoder)


// {-| Create an event listener that may [`preventDefault`][prevent]. Your decoder
// must produce a message and a `Bool` that decides if `preventDefault` should
// be called.

// For example, the `onSubmit` pub function in this library *always* prevents the
// default behavior:

// [prevent]: https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault

//     onSubmit : msg -> Attribute msg
//     onSubmit msg =
//       preventDefaultOn "submit" (Json.map alwaysPreventDefault (Json.succeed msg))

//     alwaysPreventDefault : msg -> ( msg, Bool )
//     alwaysPreventDefault msg =
//       ( msg, True )
// -}
// preventDefaultOn : String -> Json.Decoder (msg, Bool) -> Attribute msg
// preventDefaultOn event decoder =
//   VirtualDom.on event (VirtualDom.MayPreventDefault decoder)


// {-| Create an event listener that may [`stopPropagation`][stop] or
// [`preventDefault`][prevent].

// [stop]: https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation
// [prevent]: https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault
// [handler]: https://package.elm-lang.org/packages/elm/virtual-dom/latest/VirtualDom#Handler

// **Note:** Check out the lower-level event API in `elm/virtual-dom` for more
// information on exactly how events work, especially the [`Handler`][handler]
// docs.
// -}
// custom : String -> Json.Decoder { message : msg, stopPropagation : Bool, preventDefault : Bool } -> Attribute msg
// custom event decoder =
//   VirtualDom.on event (VirtualDom.Custom decoder)



// -- COMMON DECODERS


// {-| A `Json.Decoder` for grabbing `event.target.value`. We use this to define
// `onInput` as follows:

//     import Json.Decode as Json

//     onInput : (String -> msg) -> Attribute msg
//     onInput tagger =
//       stopPropagationOn "input" <|
//         Json.map alwaysStop (Json.map tagger targetValue)

//     alwaysStop : a -> (a, Bool)
//     alwaysStop x =
//       (x, True)

// You probably will never need this, but hopefully it gives some insights into
// how to make custom event handlers.
// -}
// targetValue : Json.Decoder String
// targetValue =
//   Json.at ["target", "value"] Json.string


// {-| A `Json.Decoder` for grabbing `event.target.checked`. We use this to define
// `onCheck` as follows:

//     import Json.Decode as Json

//     onCheck : (Bool -> msg) -> Attribute msg
//     onCheck tagger =
//       on "input" (Json.map tagger targetChecked)
// -}
// targetChecked : Json.Decoder Bool
// targetChecked =
//   Json.at ["target", "checked"] Json.bool


// {-| A `Json.Decoder` for grabbing `event.keyCode`. This helps you define
// keyboard listeners like this:

//     import Json.Decode as Json

//     onKeyUp : (Int -> msg) -> Attribute msg
//     onKeyUp tagger =
//       on "keyup" (Json.map tagger keyCode)

// **Note:** It looks like the spec is moving away from `event.keyCode` and
// towards `event.key`. Once this is supported in more browsers, we may add
// helpers here for `onKeyUp`, `onKeyDown`, `onKeyPress`, etc.
// -}
// keyCode : Json.Decoder Int
// keyCode =
//   Json.field "keyCode" Json.int
