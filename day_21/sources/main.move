/// DAY 21: Final Tests & Cleanup

module challenge::day_21 {
    use sui::event;

    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use std::unit_test::assert_eq;

    // Copy from day_20: All structs and functions
    
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
            plots: vector::empty(),
        }
    }

    fun plant(counters: &mut FarmCounters, plotId: u8) {
        // Check if plotId is valid (between 1 and 20)
        assert!(plotId >= 1 && plotId <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        
        // Check if we've reached the plot limit
        let len = vector::length(&counters.plots);
        assert!(len < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
        // Check if plot already exists in the vector
        let mut i = 0;
        while (i < len) {
            let existing_plot = vector::borrow(&counters.plots, i);
            assert!(*existing_plot != plotId, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        };
        
        counters.planted = counters.planted + 1;
        vector::push_back(&mut counters.plots, plotId);
    }

    fun harvest(counters: &mut FarmCounters, plotId: u8) {
        let len = vector::length(&counters.plots);
                
        // Check if plot exists in the vector and find its index
        let mut i = 0;
        let mut found_index = len; 
        while (i < len) {
            let existing_plot = vector::borrow(&counters.plots, i);
            if (*existing_plot == plotId) {
                found_index = i;
            };
            i = i + 1;
        };
        
        // Assert that plot was found (found_index < len means we found it)
        assert!(found_index < len, E_PLOT_NOT_FOUND);
        
        // Remove the plot from the vector
        vector::remove(&mut counters.plots, found_index);
        counters.harvested = counters.harvested + 1;
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: new_counters(),
        }
    }

    entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::share_object(farm);
    }

    fun plant_on_farm(farm: &mut Farm, plotId: u8) {
        plant(&mut farm.counters, plotId);
    }

    fun harvest_from_farm(farm: &mut Farm, plotId: u8) {
        harvest(&mut farm.counters, plotId);
    }

    fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    public struct PlantEvent has copy, drop {
        planted_after: u64,
    }

    entry fun plant_on_farm_entry(farm: &mut Farm, plotId: u8) {
        plant_on_farm(farm, plotId);
        let planted_count = total_planted(farm);
        event::emit(PlantEvent {
            planted_after: planted_count,
        });
    }

    entry fun harvest_from_farm_entry(farm: &mut Farm, plotId: u8) {
        harvest_from_farm(farm, plotId);
    }

    #[test]
    fun test_create_farm() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));

        test_scenario::next_tx(&mut s, @0xA);
        let f = test_scenario::take_shared<Farm>(&s);
        assert_eq!(total_planted(&f), 0);
        assert_eq!(total_harvested(&f), 0);
        test_scenario::return_shared(f);

        test_scenario::end(s);
    }

    #[test]
    fun test_planting_increases_counter() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));

        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        plant_on_farm(&mut f, 1);
        assert_eq!(total_planted(&f), 1);
        assert_eq!(total_harvested(&f), 0);
        test_scenario::return_shared(f);

        test_scenario::end(s);
    }

    #[test]
    fun test_harvesting_increases_counter() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));

        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        plant_on_farm(&mut f, 1);
        harvest_from_farm(&mut f, 1);
        assert_eq!(total_planted(&f), 1);
        assert_eq!(total_harvested(&f), 1);
        test_scenario::return_shared(f);

        test_scenario::end(s);
    }

    #[test]
    fun test_multiple_operations() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));

        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        plant_on_farm(&mut f, 3);
        plant_on_farm(&mut f, 5);
        plant_on_farm(&mut f, 18);
        harvest_from_farm(&mut f, 5);
        assert_eq!(total_planted(&f), 3);
        assert_eq!(total_harvested(&f), 1);
        test_scenario::return_shared(f);

        test_scenario::end(s);
    }

    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_zero() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));
        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        plant_on_farm(&mut f, 0);
        test_scenario::return_shared(f);
        test_scenario::end(s);
    }

    #[test]
    #[expected_failure(abort_code = E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id_too_large() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));
        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        plant_on_farm(&mut f, 21);
        test_scenario::return_shared(f);
        test_scenario::end(s);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_ALREADY_EXISTS)]
    fun test_duplicate_plot() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));
        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        plant_on_farm(&mut f, 7);
        plant_on_farm(&mut f, 7);
        test_scenario::return_shared(f);
        test_scenario::end(s);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_LIMIT_EXCEEDED)]
    fun test_plot_limit() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));
        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        let mut i: u8 = 1;
        while (i <= 20) {
            plant_on_farm(&mut f, i);
            i = i + 1;
        };
        plant_on_farm(&mut f, 1); // 21st attempt — should abort
        test_scenario::return_shared(f);
        test_scenario::end(s);
    }

    #[test]
    #[expected_failure(abort_code = E_PLOT_NOT_FOUND)]
    fun test_harvest_nonexistent_plot() {
        let mut s = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut s));
        test_scenario::next_tx(&mut s, @0xA);
        let mut f = test_scenario::take_shared<Farm>(&s);
        harvest_from_farm(&mut f, 9);
        test_scenario::return_shared(f);
        test_scenario::end(s);
    }
}

