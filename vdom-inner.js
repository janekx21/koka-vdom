// vdom-dom.js
//
// Implements every `kk_dom_*` function referenced by the `extern` declarations
// in vdom.kk. A `dom-node` on the Koka side is just the real DOM node
// reference, passed through opaquely -- no id table or handle bookkeeping
// needed. Likewise a `dom-event` is just the real Event object.

// ---- element / text creation ----

function kk_dom_create_element(tag) {
  return document.createElement(tag);
}

function kk_dom_create_text(value) {
  return document.createTextNode(value);
}

// ---- text / attribute mutation ----

function kk_dom_set_text(node, value) {
  node.nodeValue = value;
}

function kk_dom_set_attr(node, name, value) {
  if (name.indexOf("style:") === 0) {
    node.style[name.slice(6)] = value;
  } else {
    if (name === "value") {
      node.value = value;
    }else{
      node.setAttribute(name, value);
    }
  }
}

function kk_dom_remove_attr(node, name) {
  if (name.indexOf("style:") === 0) {
    node.style[name.slice(6)] = "";
  } else {
    node.removeAttribute(name);
  }
}

// ---- event handlers ----
// Assignment (not addEventListener) is deliberate: a vdom only ever wants one
// handler per event name on a given node, so overwriting `.onNAME` is both
// simpler and naturally idempotent across re-renders.


function kk_dom_set_handler(node, name, callback) {
  node["on" + name] = callback; // callback is already a plain JS function
}

function kk_dom_remove_handler(node, name) {
  node["on" + name] = null;
}

function kk_dom_prevent_default(ev) {
  ev.preventDefault();
}

function kk_dom_event_target(ev) {
  return ev.target;
}

// ---- tree structure ----

function kk_dom_append_child(parent, child) {
  parent.appendChild(child);
}

function kk_dom_remove_child(parent, index) {
  var child = parent.childNodes[index];
  if (child) parent.removeChild(child);
}

function kk_dom_replace_child(parent, index, newNode) {
  var oldChild = parent.childNodes[index];
  if (oldChild) {
    parent.replaceChild(newNode, oldChild);
  } else {
    parent.appendChild(newNode);
  }
}

function kk_dom_child_at(parent, index) {
  return parent.childNodes[index];
}

// ---- mounting ----

function kk_dom_mount_root(node, selector) {
  // var host = document.querySelector(selector);
  document.body.appendChild(node);
}


// vdom-dom.js (or vdom-inner.js, matching your rename)
function kk_dom_event_value(ev) {
  return ev.target.value;
}
