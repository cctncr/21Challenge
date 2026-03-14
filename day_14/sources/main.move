/// DAY 14: Tests for Bounty Board
/// 
/// Today you will:
/// 1. Write comprehensive tests
/// 2. Test all the functions you've created
/// 3. Practice test organization
///
/// Note: You can copy code from day_13/sources/solution.move if needed

module challenge::day_14 {
    use std::vector;
    use std::string::String;
    use std::option::{Self, Option};

    #[test_only]
    use std::unit_test::assert_eq;
    use std::string;

    // Copy from day_13: All structs and functions
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

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    public fun total_reward(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut total = 0;
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            total = total + task.reward;
            i = i + 1;
        };
        total
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let len = vector::length(&board.tasks);
        let mut count = 0;
        let mut i = 0;
        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            if (task.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    // Note: assert! is a built-in macro in Move 2024 - no import needed!

    #[test]
    fun test_create_board_and_add_task() {
        let mut board = new_board(@0xAB);
        assert_eq!(vector::length(&board.tasks), 0);

        add_task(&mut board, new_task(string::utf8(b"Hunt the dragon"), 500));
        assert_eq!(vector::length(&board.tasks), 1);
    }

    #[test]
    fun test_complete_task_updates_count() {
        let mut board = new_board(@0xAB);
        add_task(&mut board, new_task(string::utf8(b"Patrol the walls"), 200));
        add_task(&mut board, new_task(string::utf8(b"Collect herbs"), 75));
        add_task(&mut board, new_task(string::utf8(b"Escort merchant"), 300));

        assert_eq!(completed_count(&board), 0);

        complete_task(vector::borrow_mut(&mut board.tasks, 1));
        complete_task(vector::borrow_mut(&mut board.tasks, 2));

        assert_eq!(completed_count(&board), 2);
    }

    #[test]
    fun test_total_reward_sums_all_tasks() {
        let mut board = new_board(@0xAB);
        add_task(&mut board, new_task(string::utf8(b"Slay goblins"), 150));
        add_task(&mut board, new_task(string::utf8(b"Find relic"), 400));
        add_task(&mut board, new_task(string::utf8(b"Deliver letter"), 30));

        assert_eq!(total_reward(&board), 580);
    }

    #[test]
    fun test_empty_board_has_zero_reward_and_count() {
        let board = new_board(@0xFF);
        assert_eq!(total_reward(&board), 0);
        assert_eq!(completed_count(&board), 0);
    }
}

