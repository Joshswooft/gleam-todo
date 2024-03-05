import wisp.{type Request, type Response}
import gleam/string_builder
import gleam/http.{Delete, Get, Post, Put}
import internal/my_todo
import gleam/result
import gleam/io

// handler runs some pattern matching which decides on what OP the todo service should make
pub fn handler(req: Request) -> Response {
  io.debug("/todos handler")
  case req.method {
    Get -> get_all(req)
    Post -> add(req)
    _ -> wisp.not_found()
  }
}

// handler is for the /todos/{id} route
pub fn id_handler(req: Request, id) -> Response {
  io.debug(id)
  case req.method {
    Get -> get(req, id)
    Delete -> delete(req, id)
    Put -> update(req, id)

    _ -> wisp.not_found()
  }
}

// returns all the todos we have
pub fn get_all(_request: Request) -> Response {
  let todos = ["my todos"]
  let body = string_builder.from_strings(todos)

  wisp.html_response(body, 200)
}

// TODO: write logic to get a todo by its ID
pub fn get(_request: Request, _id: String) -> Response {
  wisp.html_response(string_builder.from_string("foo"), 200)
}

// TODO: handle removing a todo
pub fn delete(_request: Request, _id: String) -> Response {
  wisp.html_response(string_builder.from_string("foo"), 200)
}

// TODO: handle updating a todo
pub fn update(_request: Request, _id: String) -> Response {
  wisp.html_response(string_builder.from_string("foo"), 200)
}

// adds a new todo to the list
pub fn add(_request: Request) -> Response {
  // get the value we wish to make from the request

  // how do we get the current todos?
  let todos =
    []
    |> my_todo.add("some value")

  case result.is_error(todos) {
    True -> wisp.internal_server_error()
    False -> {
      let t = result.unwrap(todos, [])

      let body = string_builder.from_strings(t)

      wisp.html_response(body, 200)
    }
  }
}
