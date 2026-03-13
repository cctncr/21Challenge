/// DAY 13: Simple Aggregations (Total Reward, Completed Count)
/// 
/// Today you will:
/// 1. Write functions that iterate over vectors
/// 2. Calculate totals and counts
/// 3. Practice with control flow
///
/// Note: You can copy code from day_12/sources/solution.move if needed

module challenge::day_13 {
    use std::vector;
    use std::string::String;
    use std::option::{Self, Option};

    // Copy from day_12: All structs and functions
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun find_task_by_title(board: &TaskBoard, title: &String): Option<u64> {
        let len = vector::length(&board.tasks);
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            if (*&task.title == *title) {
                return option::some(i)
            };
            i = i + 1;
        };
        option::none()
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    public fun total_reward(board: &TaskBoard): u64 {
        let mut sum = 0u64;
        let mut i = 0;
        let len = vector::length(&board.tasks);
        while (i < len) {
            sum = sum + vector::borrow(&board.tasks, i).reward;
            i = i + 1;
        };
        sum
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let mut count = 0u64;
        let mut i = 0;
        let len = vector::length(&board.tasks);
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            if (task.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    #[test]
    fun test_total_reward() {
        use std::string;
        let mut board = new_board(@0x1);
        add_task(&mut board, new_task(string::utf8(b"Task A"), 100));
        add_task(&mut board, new_task(string::utf8(b"Task B"), 250));
        add_task(&mut board, new_task(string::utf8(b"Task C"), 50));
        assert!(total_reward(&board) == 400, 0);
    }

    #[test]
    fun test_completed_count() {
        use std::string;
        let mut board = new_board(@0x1);
        let mut t1 = new_task(string::utf8(b"Task A"), 100);
        let t2 = new_task(string::utf8(b"Task B"), 200);
        let mut t3 = new_task(string::utf8(b"Task C"), 300);
        complete_task(&mut t1);
        complete_task(&mut t3);
        add_task(&mut board, t1);
        add_task(&mut board, t2);
        add_task(&mut board, t3);
        assert!(completed_count(&board) == 2, 0);
    }
}

