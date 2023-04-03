view: loc_normalisation {
  sql_table_name: (select job_city,job_state,job_country,any_value(distinct joveo_city) joveo_city, any_value(distinct joveo_state) joveo_state,any_value(distinct joveo_country) joveo_country  from jobs.intermediate.location_hash_lookup where norm = TRUE and is_valid = TRUE group by job_city,job_state,job_country) ;;
  dimension: job_city {
    type: string
    sql: ${TABLE}.job_city ;;
  }
  dimension: job_state {
    type: string
    sql: ${TABLE}.job_state ;;
  }
  dimension: job_country {
    type: string
    sql: ${TABLE}.job_country ;;
  }
  dimension: joveo_city {
    type: string
    sql: ${TABLE}.joveo_city ;;
  }
  dimension: joveo_state {
    map_layer_name: us_states
    sql: ${TABLE}.joveo_state ;;
  }
  dimension: joveo_country {
    map_layer_name: countries
    sql: ${TABLE}.joveo_country ;;
  }
 }
