# todo_app

Day 1 of using gleam.
A simple TODO HTTP API application.

[![Package Version](https://img.shields.io/hexpm/v/todo_app)](https://hex.pm/packages/todo_app)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/todo_app/)

```sh
gleam add todo_app
```
```gleam
import todo_app

pub fn main() {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/todo_app>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```

Run some commands:

## Create a new todo

```bash
curl -X POST \
  http://localhost:8080/todos \
  -H 'Content-Type: application/json' \
  -d '{"message":"my new todo"}' 
```

## update a todo
```bash
curl -X PUT \ 
  http://localhost:8080/todos/0 \
  -H 'Content-Type: application/json' \
  -d '{"message":"first"}'
```

## delete a todo
```bash
curl -X DELETE http://localhost:8080/todos/0
```


## get all todos
```bash
curl http://localhost:8080/todos
```

## get a todo by its ID
```bash
curl http://localhost:8080/todos/0
```


