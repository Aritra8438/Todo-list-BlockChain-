<template>
  <div>
    <h1 class="center">{{ msg }}</h1>
    <h2 class="secondary">App developed using blockchain and VueJS</h2>
    <div class="sameline" v-if="accountFetched == true">
      <h3>Connected account :: &nbsp</h3>
      <h3 class="forcolor">{{ account }}</h3>
    </div>
    <div v-else class="sameline"><button @click="validate" class="connect">CONNECT TO METAMASK ACCOUNT</button></div>
    <br />
    <div class="samelineleft">
      &nbsp &nbsp <input type="text" placeholder="Add more tasks" autocomplete="false" v-model="task" style="border-radius: 10px; font-size:18pt; height: 50px;
  width: 400px; "> &nbsp &nbsp
      <button @click="addTask" style="background-color:aqua; border-radius: 10px;">Add task</button>
    </div>
    <br />
    <div class="sameline"><button @click="fetchTasks" class="fetch">Fetch tasks</button></div>
    <br />
    <br />
    <div v-if="tasksFetched == true" class="todo">
      <div>Your Unfinished tasks</div>
      <br />
      <div v-for=" i in taskCount" :key="i" v-if="deleted[i - 1] == false && completed[i - 1] == false"
        class="sameline">
        <h2>{{ tasks[i - 1] }}</h2> &nbsp &nbsp
        <button @click="toggleComplete(i)" style="border-radius: 10px; font-size:12pt; height: 50px;
          width: 200px; "> mark as finished </button>
        <button @click="toggleDelete(i)" style="border-radius: 10px; font-size:12pt; height: 50px;
          width: 200px; "> delete </button>
      </div>
    </div>
    <br />
    <div v-if="tasksFetched == true" class="completed">
      <div>Tasks you have finished</div>
      <br />
      <div v-for="i in taskCount" :key="i" v-if="completed[i - 1] == true && deleted[i - 1] == false" class="sameline">
        <h2>{{ tasks[i - 1] }}</h2> &nbsp &nbsp
        <button @click="toggleComplete(i)" style="border-radius: 10px; font-size:12pt; height: 50px;
          width: 200px; "> mark as unfinished </button>
        <button @click="toggleDelete(i)" style="border-radius: 10px; font-size:12pt; height: 50px;
          width: 200px; "> delete </button>
      </div>
    </div>
    <br />
    <div v-if="tasksFetched == true" class="sameline"><button @click="toggleShowDeleted" class="showDeleted">Show
        Deleted
        tasks</button></div>
    <br />
    <div v-if="tasksFetched == true && showDeleted == true" class="deleted">
      <div>Deleted Tasks</div> <br />
      <div v-for="i in taskCount" :key="i" v-if="deleted[i - 1] == true" class="sameline">
        <h2>{{ tasks[i - 1] }}</h2> &nbsp &nbsp
        <button @click="toggleDelete(i)" style="border-radius: 10px; font-size:12pt; height: 50px;
          width: 200px; "> undo delete </button>
      </div>
    </div>
  </div>
</template>

<script>
import { todolist } from '../contracts';
export default {
  name: 'HelloWorld',
  data() {
    return {
      msg: 'Welcome to Todo List App',
      account: "Hi",
      accountFetched: false,
      contract: "",
      task: "",
      tasks: [],
      tasksFetched: false,
      completed: [],
      deleted: [],
      taskCount: 0,
      todoTaskCount: 0,
      deletedTaskCount: 0,
      CompletedTaskCount: 0,
      showDeleted: false,
      showDeletedText: "Show Deleted tasks",
    }
  },
  methods: {
    async validate() {
      await ethereum
        .request({ method: 'eth_requestAccounts' })
        .then((accounts) => {
          this.account = accounts[0];
          this.accountFetched = true;
        })
      console.log("validated");
      todolist.setProvider(web3.currentProvider);
      await todolist
        .deployed()
        .then((response) => {
          this.contract = response
        })
      console.log("deployed");
      this.getTaskCount();
    },
    async getTaskCount() {
      await this.contract
        .taskCount({ from: this.account })
        .then((response) => {
          response = response;
          this.taskCount = response.words[0];
          console.log(response.words[0]);
        })
        .catch((error) => {
          console.log(error);
        })
      console.log("fetched TaskCount");
    },
    async addTask() {
      this.taskCount = 0;
      this.getTaskCount();
      await this.contract
        .createTask(this.task, { from: this.account })
        .then((response) => {
          console.log(response);
          this.fetchTasks;
        })
        .catch((error) => {
          console.log(error);
        })
      this.fetchTasks();
      this.taskCount--;
      this.taskCount++;
    },
    async fetchTasks() {
      this.getTaskCount();
      console.log(this.taskCount);
      for (let i = 1; i <= this.taskCount; i++) {
        await this.getTask(i);
      }
      console.log(this.tasks);
      this.tasksFetched = true;
      this.taskCount -= 2; this.taskCount += 2;
    },
    async getTask(index) {
      await this.contract
        .tasks(index, { from: this.account })
        .then((response) => {
          this.tasks[index - 1] = response.content;
          this.deleted[index - 1] = response.deleted;
          this.completed[index - 1] = response.completed;
        })
        .catch((error) => {
          console.log(error);
        })
    },
    async toggleComplete(index) {
      await this.contract
        .completed(index, { from: this.account })
        .then((response) => {
          console.log("Complete Toggled");
        })
        .catch((error) => {
          console.log(error);
        })
      this.fetchTasks();
    },
    async toggleDelete(index) {
      await this.contract
        .deleted(index, { from: this.account })
        .then((response) => {
          console.log("Delete Toggled");
        })
        .catch((error) => {
          console.log(error);
        })
      this.fetchTasks();
    },
    toggleShowDeleted() {
      this.showDeleted = !this.showDeleted;
      if (showDeletedText == "Show Deleted tasks") {
        showDeletedText: "Hide Deleted tasks";
      }
      else {
        showDeletedText: "Show Deleted tasks";
      }
    }
  },
  mounted() {
    console.log("Mounted");
  },
  beforeMount() {
    console.log("beforeMount");
  },
  beforeUpdate() {
    console.log("beforeUpdate");
  },
  updated() {
    console.log("updated");
  }
}
</script>

<style>
.center {
  margin: auto;
  width: 50%;
  border: 3px solid rgb(5, 1, 238);
  padding: 10px;
  background-color: rgb(5, 1, 238);
  color: white;
  text-align: center;
}

.todo {
  margin: auto;
  width: 50%;
  border: 3px solid rgb(5, 1, 238);
  padding: 10px;
  background-color: rgb(145, 144, 223);
  color: black;
  text-align: center;
}

.completed {
  margin: auto;
  width: 50%;
  border: 3px solid rgb(0, 133, 7);
  padding: 10px;
  background-color: rgb(203, 236, 171);
  color: black;
  text-align: center;
}

.deleted {
  margin: auto;
  width: 50%;
  border: 3px solid rgb(240, 0, 0);
  padding: 10px;
  background-color: rgb(218, 163, 155);
  color: black;
  text-align: center;
}

.secondary {
  color: rgb(5, 1, 238);
  text-align: center;
}

.sameline {
  display: flex;
  justify-content: center;
}

.samelineleft {
  display: flex;
}

.connect {
  text-align: center;
  background-color: aquamarine;
  height: 50px;
  width: 300px;
}

.showDeleted {
  text-align: center;
  background-color: red;
  height: 50px;
  width: 300px;
  color: white;
}

.fetch {
  text-align: center;
  background-color: rebeccapurple;
  height: 50px;
  width: 300px;
  color: white;
}

.forcolor {
  color: rgb(44, 172, 101);
}
</style>
