/// DAY 11: TaskBoard & Address Type
/// 
/// Today you will:
/// 1. Learn about the address type
/// 2. Create a TaskBoard that tracks ownership
/// 3. Understand ownership in practice
///
/// Note: You can copy code from day_10/sources/solution.move if needed
/// 
/// Related: Day 10 (Visibility), Day 12 (Building on TaskBoard)

module challenge::day_11 {
    use std::vector;
    use std::string::String;

    // Copy from day_10: TaskStatus enum and Task struct
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

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard { owner, tasks: vector::empty() }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun task_count(board: &TaskBoard): u64 {
        vector::length(&board.tasks)
    }

    public fun is_owner(board: &TaskBoard, addr: address): bool {
        board.owner == addr
    }
}

