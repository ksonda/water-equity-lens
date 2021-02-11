cv_race = c(pop_race_white = "B02001_002",
              pop_race_black = "B02001_003",
              pop_race_american_indian_native_alaskan = "B02001_004",
              pop_race_asian = "B02001_005",
              pop_race_native_hawaiian_pacific_islander = "B02001_006",
              pop_race_other_race = "B02001_007",
              pop_race_two_or_more_races = "B02001_008",
              pop_hispanic = "B03002_012",
              pop_hispanic_white_alone = "B03002_013"
            )

cv_race_count = "B01001_001"

tracts_race <- tidycensus::get_acs(year=2019,
                              geography = "tract",
                              variables = cv_race,
                              geometry = TRUE,
                              state = st,
                              county = ct,
                              summary_var = cv_race_count) %>% 
  sf::st_transform(4326) %>%
  dplyr::filter(lengths(sf::st_intersects(., boundary)) > 0) %>% 
  group_by(GEOID) %>%
  mutate(estimate_percentage = 100*estimate/summary_est) %>% st_drop_geometry() %>%
  pivot_wider(id_cols = c(GEOID, NAME), names_from = variable,
              values_from = c(estimate, estimate_percentage )) %>% right_join(.,tracts,by=c("GEOID","NAME")) %>% st_as_sf()

bg_race <- tidycensus::get_acs(year=2019,
                               geography = "block group",
                               variables = cv_race,
                               geometry = TRUE,
                               state = st,
                               county = ct,
                               summary_var = cv_race_count) %>% 
  sf::st_transform(4326) %>%
  dplyr::filter(lengths(sf::st_intersects(., boundary)) > 0) %>% 
  group_by(GEOID) %>%
  mutate(estimate_percentage = 100*estimate/summary_est) %>% st_drop_geometry() %>%
  pivot_wider(id_cols = c(GEOID, NAME), names_from = variable,
              values_from = c(estimate, estimate_percentage )) %>% right_join(.,bg,by=c("GEOID","NAME")) %>% st_as_sf()


map_race_tract <- mapview(tracts_race, zcol = "estimate_percentage_pop_race_white", layer.name ="% Tract Pop. White")

map_race_bg <- mapview(bg_race, zcol = "estimate_percentage_pop_race_white", layer.name ="% Block Group Pop. White") 

mapview::sync(map_race_tract, map_race_bg)


cv_traveltime = c(pop_travel_time_work_less_5min = "B08012_002",
                  pop_travel_time_work_5_9min = "B08012_003",
                  pop_travel_time_work_10_14min = "B08012_004",
                  pop_travel_time_work_15_19min = "B08012_005",
                  pop_travel_time_work_20_24min = "B08012_006",
                  pop_travel_time_work_25_29min = "B08012_007",
                  pop_travel_time_work_30_34min = "B08012_008",
                  pop_travel_time_work_35_39min = "B08012_009",
                  pop_travel_time_work_40_44min = "B08012_010",
                  pop_travel_time_work_45_59min = "B08012_011",
                  pop_travel_time_work_60_89min = "B08012_012",
                  pop_travel_time_work_atleast_90min = "B08012_013"
                  )

cv_traveltime_count = "B08012_001"

tracts_traveltime <- tidycensus::get_acs(year=2019,
                                   geography = "tract",
                                   variables = cv_traveltime,
                                   geometry = TRUE,
                                   state = st,
                                   county = ct,
                                   summary_var = cv_traveltime_count) %>% 
  sf::st_transform(4326) %>%
  dplyr::filter(lengths(sf::st_intersects(., boundary)) > 0) %>% 
  group_by(GEOID) %>%
  mutate(estimate_percentage = 100*estimate/summary_est) %>% st_drop_geometry() %>%
  pivot_wider(id_cols = c(GEOID, NAME), names_from = variable,
              values_from = c(estimate, estimate_percentage )) %>% 
  mutate(percentage_traveltime_hour_or_more = estimate_percentage_pop_travel_time_work_60_89min + estimate_percentage_pop_travel_time_work_atleast_90min)