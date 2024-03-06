import wisp.{type Request, type Response}
import gleam/string_builder
import gleam/http.{Delete, Get, Post, Put}
import internal/my_todo
import gleam/result
import gleam/io
import gleam/int
import gleam/string
import gleam/list

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
  wisp.ok()
  |> wisp.string_body(string.join(my_todo.get(), ","))
}

// gets a single todo by its id
pub fn get(_request: Request, id: String) -> Response {
  let assert Ok(id_num) = int.base_parse(id, 10)

  let all_todos = my_todo.get()

  case list.at(all_todos, id_num) {
    Error(_) -> wisp.not_found()
    Ok(contents) ->
      wisp.ok()
      |> wisp.string_body(contents)
  }
}

// deletes a todo by its id (the index of the todo)
// e.g. ["todo1", "todo2", "todo3"], id = 1 would delete "todo2"
pub fn delete(_request: Request, id: String) -> Response {
  let assert Ok(id_num) = int.base_parse(id, 10)

  let todos = my_todo.get()

  case my_todo.remove(todos, id_num) {
    Error(error) -> {
      case error {
        my_todo.TodoDoesntExist -> wisp.not_found()
        my_todo.EmptyTodoList -> wisp.no_content()
      }
    }
    Ok(updated_todos) -> {
      case my_todo.save(updated_todos) {
        Ok(_) -> {
          // need changing
          let body = string_builder.from_strings(updated_todos)
          wisp.html_response(body, 200)
        }
        Error(_) -> wisp.internal_server_error()
      }
    }
  }
}

// TODO: handle updating a todo
pub fn update(_request: Request, id: String) -> Response {
  let assert Ok(id_num) = int.base_parse(id, 10)

  // TODO: get value from request we wish to add
  let value: String = "goose"
  let all_todos = my_todo.get()

  case list.at(all_todos, id_num) {
    Error(_) -> wisp.bad_request()
    Ok(_) -> {
      let updated_todos = my_todo.update_by_index(all_todos, id_num, value)

      case result.is_error(my_todo.save(updated_todos)) {
        True -> wisp.internal_server_error()
        False ->
          wisp.ok()
          |> wisp.string_body(string.join(updated_todos, ","))
      }
    }
  }

  wisp.html_response(string_builder.from_string("foo"), 200)
}

// adds a new todo to the list
pub fn add(_request: Request) -> Response {
  // get the value we wish to make from the request

  // TODO: get value from request we wish to add

  let todos = my_todo.get()

  case my_todo.add(todos, "new todo") {
    Error(_) -> wisp.internal_server_error()
    Ok(updated_todos) -> {
      io.debug(updated_todos)
      case result.is_error(my_todo.save(updated_todos)) {
        True -> wisp.internal_server_error()
        False ->
          wisp.ok()
          |> wisp.string_body(string.join(updated_todos, ","))
      }
    }
  }
}
