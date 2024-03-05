import wisp.{type Request, type Response}
import gleam/string_builder
import app/server.{middleware}
import app/todo_service.{handler, id_handler}

/// The HTTP request handler- your application!
/// 
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use _req <- middleware(req)

  // Wisp doesn't have a special router abstraction, instead we recommend using
  // regular old pattern matching. This is faster than a router, is type safe,
  // and means you don't have to learn or be limited by a special DSL.
  //
  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> hello_world(req)

    // This matches `/comments`.
    ["todos"] -> handler(req)

    // This matches `/todos/:id`.
    // The `id` segment is bound to a variable and passed to the handler.
    ["todos", id] -> id_handler(req, id)

    // This matches all other paths.
    _ -> wisp.not_found()
  }
}

fn hello_world(_req: Request) -> Response {
  // Later we'll use templates, but for now a string will do.
  let body = string_builder.from_string("<h1>Hello, World!</h1>")

  // Return a 200 OK response with the body and a HTML content type.
  wisp.html_response(body, 200)
}
