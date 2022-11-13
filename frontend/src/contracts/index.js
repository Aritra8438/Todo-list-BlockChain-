import contract from "truffle-contract";

import TodoList from "../../../backend/build/contracts/TodoList.json";

const todolist = contract(TodoList);
export { todolist };
