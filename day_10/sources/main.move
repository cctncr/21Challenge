/// DAY 10: Visibility Modifiers (Public vs Private Functions)
/// 
/// Today you will:
/// 1. Learn about visibility modifiers (public vs private)
/// 2. Design a public API
/// 3. Write a function to complete tasks
///
/// Note: You can copy code from day_09/sources/solution.move if needed

module challenge::day_10 {
    use std::string::String;

    // Copy from day_09: TaskStatus enum and Task struct
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun is_open(task: &Task): bool {
        task.status == TaskStatus::Open
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    fun is_reward_positive(task: &Task): bool {
        task.reward > 0
    }

    public fun has_valid_reward(task: &Task): bool {
        is_reward_positive(task)
    }
}

