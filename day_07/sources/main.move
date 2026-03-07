/// DAY 7: Unit Tests for Habit Tracker
///
/// Today you will:
/// 1. Learn how to write tests in Move
/// 2. Write tests for your habit tracker
/// 3. Use assert! macro
///
/// Note: You can copy code from day_06/sources/solution.move if needed

module challenge::day_07 {
    use std::vector;
    use std::string::{Self, String};
    use std::unit_test::assert_eq; // ile yapmak istedim; testleri geciyor ama build'de sorun cikariyor anlamadim.

    // Copy from day_06: Habit struct with String
    public struct Habit has copy, drop {
        name: String,
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    public fun make_habit(name_bytes: vector<u8>): Habit {
        let name = string::utf8(name_bytes);
        new_habit(name)
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(),
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    public fun complete_habit(list: &mut HabitList, index: u64) {
        let len = vector::length(&list.habits);
        if (index < len) {
            let habit = vector::borrow_mut(&mut list.habits, index);
            habit.completed = true;
        }
    }

    #[test]
    public fun test_add_habits() {
        let mut list =  empty_list();
        let habit1 = new_habit(b"habit1".to_string());
        let habit2 = new_habit(b"habit2".to_string());
        add_habit(&mut list, habit1);
        add_habit(&mut list, habit2);
        let length = vector::length(&list.habits);
        assert_eq!(length, 2);
    }

    #[test]
    fun test_complete_habit() {
        let mut list = empty_list();
        let habit = new_habit(b"habit".to_string());
        add_habit(&mut list, habit);
        complete_habit(&mut list, 0);
        let completed_habit = vector::borrow(&list.habits, 0);
        assert_eq!(completed_habit.completed, true);
    }
}

