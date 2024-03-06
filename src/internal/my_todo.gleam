import gleam/list
import simplifile
import gleam/string
import gleam/io

// note the directory and file have to be made beforehand
const file_path = "./testdata/todo.txt"

type Todo =
  List(String)

pub type AddTodoError {
  NoTodoGiven
}

// adds a new todo to the end of the list
pub fn add(todos: Todo, value: String) -> Result(Todo, AddTodoError) {
  case todos, value {
    _, "" -> Error(NoTodoGiven)
    [], _ -> Ok([value])
    _, _ -> Ok(list.append(todos, [value]))
  }
}

fn update_element_helper(
  arr: List(a),
  index: Int,
  new_value: a,
  current_index: Int,
) -> List(a) {
  // Pattern match on the array
  case arr {
    // If the array is empty, return an empty array
    [] -> []
    // If the current index matches the index we want to update, replace the element
    [_head, ..tail] if current_index == index -> [new_value, ..tail]
    // If the current index doesn't match, keep the element and recursively call the helper function
    [head, ..tail] -> [
      head,
      ..update_element_helper(tail, index, new_value, current_index + 1)
    ]
  }
}

// Define a function to update an element of an array by index
pub fn update_by_index(arr: List(a), index: Int, new_value: a) -> List(a) {
  // Define a helper function to iterate through the array

  // Call the helper function with the initial current_index set to 0
  update_element_helper(arr, index, new_value, 0)
}

pub fn save(todos: Todo) {
  todos
  |> string.join(",")
  |> simplifile.write(to: file_path)
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

// reads todos from the file
pub fn get() -> Todo {
  let assert Ok(contents) = simplifile.read(from: file_path)
  io.debug(contents)
  case contents {
    "" -> []
    _ -> string.split(contents, ",")
  }
}
