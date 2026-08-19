struct person
  id : string
  name : string
  role : role

fun person/show(person : person)
  ["id: " ++ person.id, "name: " ++ person.name, person.role.show].combine

fun combine( xs : list<string> ) : sep string
  "<" ++ xs.join(sep) ++ ">"

type role
  Admin
  Regular

fun role/show(role : role)
  match role
    Admin -> "Admin"
    Regular -> "Regular"

effect val sep : string

fun main()
  with val sep = " | "
  val janek = Person("oiy82", "janek", Admin)
  janek.show.println
