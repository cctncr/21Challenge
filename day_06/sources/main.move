/// DAY 6: String Type for Habit Names
/// 
/// Today you will:
/// 1. Learn about the String type
/// 2. Convert vector<u8> to String
/// 3. Update Habit to use String instead of vector<u8>
///
/// Note: You can copy code from day_05/sources/solution.move if needed

module challenge::day_06 {
    use std::vector;
    use std::string::{Self, String};

    // Copy from day_05: Habit struct (will be updated to use String)
    public struct Habit has copy, drop {
        name: String,
        completed: bool,
    }

    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    // Copy from day_05: HabitList struct
    public struct HabitList has drop {
        habits: vector<Habit>,
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

    public fun make_habit(name_bytes: vector<u8>): Habit {
        new_habit(string::utf8(name_bytes))
    }
}

