import gleam/list

// TODO: how to make Todo type with key: int and value: string ?
// Todo = Dict(Int, String) or maybe we can use List with key pairs?
type Todo =
  List(String)

pub type AddTodoError {
  NoTodoGiven
}

// adds a new todo to the end of the list
pub fn add(todos: Todo, value: String) -> Result(Todo, AddTodoError) {
  case todos, value {
    _, "" -> Error(NoTodoGiven)
    _, _ -> Ok(list.append(todos, [value]))
  }
}

pub type RemoveTodoError {
  TodoDoesntExist
  EmptyTodoList
}

// recursively builds up a list using an accumulator to count the index it's visited
// takes O(n)
fn do_remove_from_list_by_index(
  l: List(value),
  n: Int,
  c: List(value),
  acc: Int,
) -> List(value) {
  case l, n {
    [], _ -> c
    _, n if n < 0 -> l
    [_first, ..rest], n if n == 0 -> rest
    [_first, ..rest], n if n == acc ->
      do_remove_from_list_by_index(rest, n, c, acc + 1)
    [first, ..rest], _ ->
      do_remove_from_list_by_index(rest, n, list.append(c, [first]), acc + 1)
  }
}

// removes an element from the list at the given index (n)
// returns the new list
fn remove_from_list_by_index(l: List(value), n: Int) -> List(value) {
  do_remove_from_list_by_index(l, n, [], 0)
}

pub fn remove(todos: Todo, index: Int) -> Result(Todo, RemoveTodoError) {
  let len = list.length(todos)

  case todos, index {
    [], _ -> Error(EmptyTodoList)
    _, idx if idx < 0 -> Error(TodoDoesntExist)
    _, idx if idx > len -> Error(TodoDoesntExist)
    _, _ -> Ok(remove_from_list_by_index(todos, index))
  }
}
