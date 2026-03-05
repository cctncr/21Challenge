/// DAY 5: Control Flow & Mark Habit as Done
/// 
/// Today you will:
/// 1. Learn if/else statements
/// 2. Learn how to access vector elements
/// 3. Write a function to mark a habit as completed

module challenge::day_05 {
    use std::vector;
    use std::string::String;

    public struct Habit has copy, drop {
        name: String,
        completed: bool
    }

    public fun new_habit(name: String): Habit {
        Habit { name, completed: false }
    }

    public struct HabitList has drop {
        habits: vector<Habit>
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty()
        }
    }
    public fun complete_habit(list: &mut HabitList, index: u64) {
        if (index < vector::length(&list.habits)) {
            vector::borrow_mut(&mut list.habits, index).completed = true
        }
    }
}

