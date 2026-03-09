/// DAY 9: Enums & TaskStatus
/// 
/// Today you will:
/// 1. Learn about enums
/// 2. Replace bool with an enum
/// 3. Use match expressions

module challenge::day_09 {
    use std::string::String;

    public enum TaskStatus has drop, copy {
        Open,
        Completed,
    }

    public struct Task has drop, copy {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, status: TaskStatus::Open }
    }

    public fun is_open(task: &Task): bool {
        match (task.status) {
            TaskStatus::Open => true,
            TaskStatus::Completed => false,
        }
    }
}

