/// DAY 8: New Module & Simple Task Struct
/// 
/// Today you will:
/// 1. Start a new project: Task Bounty Board
/// 2. Create a Task struct
/// 3. Write a constructor function

module challenge::day_08 {
    use std::string::String;

    public struct Task has drop, copy {
        title: String,
        reward: u64,
        done: bool,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, done: false }
    }
}

