// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TodoList {
    uint256 public taskCount;
    uint256 public completedCount;
    uint256 public deletedCount;

    constructor() {
        taskCount = 0;
        completedCount = 0;
        deletedCount = 0;
    }

    struct Task {
        uint256 id;
        string content;
        bool completed;
        bool deleted;
    }

    mapping(uint256 => Task) public tasks;

    function createTask(string memory _content) public returns (Task memory) {
        taskCount++;
        Task memory task = Task(taskCount, _content, false, false);
        tasks[taskCount] = task;
        return task;
    }

    function completed(uint256 index) public {
        if (tasks[index].completed == true) {
            tasks[index].completed = false;
            completedCount--;
        } else {
            tasks[index].completed = true;
            completedCount++;
        }
    }

    function deleted(uint256 index) public {
        if (tasks[index].deleted == false) {
            tasks[index].deleted = true;
            deletedCount++;
        } else {
            tasks[index].deleted = false;
            deletedCount--;
        }
    }
}
