view: view_tracking_event {
 sql_table_name: TRACKING.MODELLED.view_tracking_event ;;
  dimension: should_contribute_to_joveo_stats {
    type: yesno
    sql: ${TABLE}.SHOULD_CONTRIBUTE_TO_JOVEO_STATS ;;
  }
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
  dimension: date {
    type: date
    sql: ${TABLE}.event_publisher_date ;;
  }
  dimension: agency_id {
    type: string
    sql: ${TABLE}.agency_id ;;
  }
  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }
  dimension: campaign_id {
    type: string
    sql: ${TABLE}.campaign_id ;;
  }
  dimension: JOB_GROUP_ID {
    type: string
    sql: ${TABLE}.JOB_GROUP_ID ;;
  }
  dimension: publisher_id {
    type: string
    sql: ${TABLE}.publisher_id ;;
  }
  dimension: Publisher {
    type: string
    sql: ${TABLE}.publisher_name ;;
  }
  measure: Spend {
    type: sum
    sql: case
    when ${TABLE}.is_valid = true then (${TABLE}.event_spend * (1E0 / (1E0 - (${TABLE}.publisher_entity_markdown / 100))) * (1E0 + (${TABLE}.agency_markup / 100)) * (1E0 + (${TABLE}.effective_cd_markup / 100)) * ${TABLE}.d_logic_ratio)
    else 0E0
  end  ;;
  }
  measure: Clicks {
    type: sum
    sql: case when (
        ${TABLE}.event_type = 'CLICK'
        and ${TABLE}.is_valid = true
      ) then ${TABLE}.event_count
      else 0
    end ;;
  }
  measure: Applies {
    type: sum
    sql: case
      when (
        ${TABLE}.event_type = 'CONVERSION'
        and ${TABLE}.conversion_type = 'APPLY'
      ) then ${TABLE}.event_count
      else 0
    end ;;
  }
  measure: Hires {
    type: sum
    sql: sum(case
      when (
        ${TABLE}.event_type = 'CONVERSION'
        and ${TABLE}.conversion_type = 'HIRE'
      ) then ${TABLE}.event_count
      else 0
    end) ;;
  }
  dimension: day_of_week {
    type: string
    sql: dayname(${date})  ;;
  }
  measure: CPC {
    type: number
    sql: iff(${Clicks}=0,0,${Spend}/${Clicks}) ;;
  }
  measure: CPA {
    type: number
    sql: iff(${Applies}=0,0,${Spend}/${Applies}) ;;
  }
  measure: CPH {
    type: number
    sql: iff(${Hires}=0,0,${Spend}/${Hires}) ;;
  }
  measure: CTA {
    type: number
    sql: iff(${Clicks}=0,0,${Applies}/${Clicks}) ;;
  }
  dimension: time_split {
    type: string
    sql: case
      when to_time(${TABLE}.event_timestamp) <= time_from_parts(3,0,0) then '00:00 - 03:00'
      when to_time(${TABLE}.event_timestamp) > time_from_parts(3,0,0) and to_time(${TABLE}.event_timestamp) <= time_from_parts(6,0,0) then '03:00 - 06:00'
      when to_time(${TABLE}.event_timestamp) > time_from_parts(6,0,0) and to_time(${TABLE}.event_timestamp) <= time_from_parts(9,0,0) then '06:00 - 09:00'
      when to_time(${TABLE}.event_timestamp) > time_from_parts(9,0,0) and to_time(${TABLE}.event_timestamp) <= time_from_parts(12,0,0) then '09:00 - 12:00'
      when to_time(${TABLE}.event_timestamp) > time_from_parts(12,0,0) and to_time(${TABLE}.event_timestamp) <= time_from_parts(15,0,0) then '12:00 - 15:00'
      when to_time(${TABLE}.event_timestamp) > time_from_parts(15,0,0) and to_time(${TABLE}.event_timestamp) <= time_from_parts(18,0,0) then '15:00 - 18:00'
      when to_time(${TABLE}.event_timestamp) > time_from_parts(18,0,0) and to_time(${TABLE}.event_timestamp) <= time_from_parts(21,0,0) then '18:00 - 21:00'
      else '21:00 - 24:00'
      end ;;
  }
 }
