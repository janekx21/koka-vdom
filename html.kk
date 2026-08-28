module html

import vdom

// Lets mirror https://package.elm-lang.org/packages/elm/html/latest/Html#map

// Tags

// Headers

pub fun h1(attr, children)
  Elem("h1", attr, children)


pub fun h2(attr, children)
  Elem("h2", attr, children)

pub fun h3(attr, children)
  Elem("h3", attr, children)

pub fun h4(attr, children)
  Elem("h4", attr, children)

pub fun h5(attr, children)
  Elem("h5", attr, children)

pub fun h6(attr, children)
  Elem("h6", attr, children)

// Grouping content
  
pub fun div(attr, children)
  Elem("div", attr, children)

pub fun p(attr, children)
  Elem("p", attr, children)

pub fun hr(attr, children)
  Elem("hr", attr, children)

pub fun pre(attr, children)
  Elem("pre", attr, children)

pub fun blockquote(attr, children)
  Elem("blockquote", attr, children)

// Text
  
pub fun span(attr, children)
  Elem("span", attr, children)

pub fun a(attr, children)
  Elem("a", attr, children)

pub fun code(attr, children)
  Elem("code", attr, children)

pub fun em(attr, children)
  Elem("em", attr, children)

pub fun strong(attr, children)
  Elem("strong", attr, children)

pub fun i(attr, children)
  Elem("i", attr, children)

pub fun b(attr, children)
  Elem("b", attr, children)

pub fun u(attr, children)
  Elem("u", attr, children)

pub fun sub(attr, children)
  Elem("sub", attr, children)

pub fun sup(attr, children)
  Elem("sup", attr, children)

pub fun br(attr, children)
  Elem("br", attr, children)

// Lists

pub fun ol(attr, children)
  Elem("ol", attr, children)

pub fun ul(attr, children)
  Elem("ul", attr, children)

pub fun li(attr, children)
  Elem("li", attr, children)

pub fun dl(attr, children)
  Elem("dl", attr, children)

pub fun dt(attr, children)
  Elem("dt", attr, children)

pub fun dd(attr, children)
  Elem("dd", attr, children)

// Embedded Content

pub fun img(attr, children)
  Elem("img", attr, children)

pub fun iframe(attr, children)
  Elem("iframe", attr, children)

pub fun canvas(attr, children)
  Elem("canvas", attr, children)

pub fun math(attr, children)
  Elem("math", attr, children)

// Inputs

pub fun form(attr, children)
  Elem("form", attr, children)

pub fun input(attr, children)
  Elem("input", attr, children)

pub fun textarea(attr, children)
  Elem("textarea", attr, children)

pub fun button(attr, children)
  Elem("button", attr, children)

pub fun select(attr, children)
  Elem("select", attr, children)

pub fun option(attr, children)
  Elem("option", attr, children)

// Sections
  
pub fun section(attr, children)
  Elem("section", attr, children)

pub fun nav(attr, children)
  Elem("nav", attr, children)

pub fun article(attr, children)
  Elem("article", attr, children)

pub fun aside(attr, children)
  Elem("aside", attr, children)

pub fun header(attr, children)
  Elem("header", attr, children)

pub fun footer(attr, children)
  Elem("footer", attr, children)

pub fun address(attr, children)
  Elem("address", attr, children)

pub fun main_(attr, children)
  Elem("main", attr, children)

// Figures

pub fun figure(attr, children)
  Elem("figure", attr, children)

pub fun figcaption(attr, children)
  Elem("figcaption", attr, children)

// Tables

pub fun table(attr, children)
  Elem("table", attr, children)

pub fun caption(attr, children)
  Elem("caption", attr, children)

pub fun colgroup(attr, children)
  Elem("colgroup", attr, children)

pub fun col(attr, children)
  Elem("col", attr, children)

pub fun tbody(attr, children)
  Elem("tbody", attr, children)

pub fun thead(attr, children)
  Elem("thead", attr, children)

pub fun tfoot(attr, children)
  Elem("tfoot", attr, children)

pub fun tr(attr, children)
  Elem("tr", attr, children)

pub fun td(attr, children)
  Elem("td", attr, children)

pub fun th(attr, children)
  Elem("th", attr, children)

// Less Common Elemens
// TODO
  
