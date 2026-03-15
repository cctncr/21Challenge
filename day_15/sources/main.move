/// DAY 15: Read Object Model & Create FarmState Struct (no UID yet)
///
/// Today you will:
/// 1. Learn about Sui objects (conceptually)
/// 2. Create a simple struct for farm counters
/// 3. Write basic functions to increment counters
///
/// NOTE: Today we're NOT creating a Sui object yet, just a regular struct.
/// We'll add UID and make it an object tomorrow.

module challenge::day_15 {
    const MAX_PLOTS: u64 = 20;

    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector[],
        }
    }

    fun plant(counters: &mut FarmCounters, plotId: u8) {
        assert!(plotId >= 1 && (plotId as u64) <= MAX_PLOTS, E_INVALID_PLOT_ID);

        let plot_count = counters.plots.length();
        assert!(plot_count < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);

        let mut idx = 0;
        while (idx < plot_count) {
            assert!(*counters.plots.borrow(idx) != plotId, E_PLOT_ALREADY_EXISTS);
            idx = idx + 1;
        };

        counters.plots.push_back(plotId);
        counters.planted = counters.planted + 1;
    }

    fun harvest(counters: &mut FarmCounters, plotId: u8) {
        let plot_count = counters.plots.length();

        let mut idx = 0;
        let mut found_at = plot_count;
        while (idx < plot_count) {
            if (*counters.plots.borrow(idx) == plotId) {
                found_at = idx;
                break
            };
            idx = idx + 1;
        };

        assert!(found_at < plot_count, E_PLOT_NOT_FOUND);

        counters.plots.remove(found_at);
        counters.harvested = counters.harvested + 1;
    }

    #[test]
    fun test_plant_and_harvest() {
        let mut farm = new_counters();
        plant(&mut farm, 1);
        plant(&mut farm, 5);
        assert!(farm.planted == 2);
        assert!(farm.plots.length() == 2);

        harvest(&mut farm, 1);
        assert!(farm.harvested == 1);
        assert!(farm.plots.length() == 1);
    }

    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_zero() {
        let mut farm = new_counters();
        plant(&mut farm, 0);
    }

    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_over_max() {
        let mut farm = new_counters();
        plant(&mut farm, 21);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_ALREADY_EXISTS)]
    fun test_duplicate_plot() {
        let mut farm = new_counters();
        plant(&mut farm, 3);
        plant(&mut farm, 3);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_NOT_FOUND)]
    fun test_harvest_nonexistent_plot() {
        let mut farm = new_counters();
        harvest(&mut farm, 7);
    }

#[test]
    fun test_plot_limit_exact() {
        let mut farm = new_counters();
        let mut id: u8 = 1;
        while ((id as u64) <= MAX_PLOTS) {
            plant(&mut farm, id);
            id = id + 1;
        };
        assert!(farm.planted == MAX_PLOTS);
        assert!(farm.plots.length() == MAX_PLOTS);
    }
}
