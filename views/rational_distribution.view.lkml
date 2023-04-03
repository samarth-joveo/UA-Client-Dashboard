view: rational_distribution {
  derived_table: {
    sql:  WITH
      agency_info AS (
          SELECT id,concat(name,' - ',currency) name
          FROM idp.modelled.campaign_management_agencies where {% condition agency_name %} concat(display_name,' - ',currency)  {% endcondition %}
      ),
      client_info AS (
          SELECT id, name
          FROM idp.modelled.campaign_management_clients where {% condition client_name %} name {% endcondition %}
      ),
      cam_info AS (
          SELECT id, name
          FROM idp.modelled.campaign_management_campaigns where {% condition campaign_name %} name {% endcondition %}
      ),
      jg_info AS (
          SELECT id, name
          FROM idp.modelled.campaign_management_jobgroups where {% condition jg_name %} name {% endcondition %}
      ),
      stats AS (
          SELECT
              publisher_id,
              SUM(cd_spend) AS CDSpend
          FROM
              tracking.modelled.VIEW_GROUPED_COMBINED_EVENTS vte
              JOIN client_info ON vte.client_id = client_info.id
              JOIN cam_info ON vte.campaign_id = cam_info.id
              JOIN jg_info ON vte.job_group_id = jg_info.id
              JOIN agency_info ON vte.agency_id = agency_info.id
          WHERE
             {% condition date_filter %} event_publisher_date {% endcondition %}
              AND should_contribute_to_joveo_stats = TRUE
          GROUP BY
              publisher_id order by sum(cd_spend) desc
      ),
      stats2 AS (
          SELECT
              publisher_id
          FROM
              stats
          LIMIT
              4
      )
          SELECT
              CASE
                  WHEN publisher_id IN (SELECT publisher_id FROM stats2) THEN publisher_id
                  ELSE 'Other'
              END AS publisher_group,
              agency_id, publisher_id, dayname(event_publisher_date) day_of_week,job_state,job_country,job_city,
              sum(case
                  when is_valid = true then (event_spend * (1E0 / (1E0 - (publisher_entity_markdown / 100))) * (1E0 + (agency_markup / 100)) * (1E0 + (effective_cd_markup / 100)) * d_logic_ratio)
                  else 0E0
                end) as total_cdspend,
              sum( case when (
                    event_type = 'CLICK'
                    and is_valid = true
                  ) then event_count
                  else 0
                end) as total_clicks,
                sum(case
                  when (
                    event_type = 'CONVERSION'
                    and conversion_type = 'APPLY'
                  ) then event_count
                  else 0
                end) as total_applies,
                case
                  when to_time(event_timestamp) <= time_from_parts(3,0,0) then '00:00 - 03:00'
                  when to_time(event_timestamp) > time_from_parts(3,0,0) and to_time(event_timestamp) <= time_from_parts(6,0,0) then '03:00 - 06:00'
                  when to_time(event_timestamp) > time_from_parts(6,0,0) and to_time(event_timestamp) <= time_from_parts(9,0,0) then '06:00 - 09:00'
                  when to_time(event_timestamp) > time_from_parts(9,0,0) and to_time(event_timestamp) <= time_from_parts(12,0,0) then '09:00 - 12:00'
                  when to_time(event_timestamp) > time_from_parts(12,0,0) and to_time(event_timestamp) <= time_from_parts(15,0,0) then '12:00 - 15:00'
                  when to_time(event_timestamp) > time_from_parts(15,0,0) and to_time(event_timestamp) <= time_from_parts(18,0,0) then '15:00 - 18:00'
                  when to_time(event_timestamp) > time_from_parts(18,0,0) and to_time(event_timestamp) <= time_from_parts(21,0,0) then '18:00 - 21:00'
                  else '21:00 - 24:00'
                  end time_split
          FROM
              tracking.modelled.view_tracking_event vte
              JOIN client_info ON vte.client_id = client_info.id
              JOIN cam_info ON vte.campaign_id = cam_info.id
              JOIN jg_info ON vte.job_group_id = jg_info.id
              JOIN agency_info ON vte.agency_id = agency_info.id
          WHERE
             {% condition date_filter %} event_publisher_date {% endcondition %}
              AND should_contribute_to_joveo_stats = TRUE
          GROUP BY
              agency_id, publisher_id, dayname(event_publisher_date),publisher_group, time_split,job_city, job_state,job_country
      ;;
  }
  filter: agency_name {
    type: string
  }
  filter: client_name {
    type: string
  }
  filter: campaign_name {
    type: string
  }
  filter: jg_name {
    type: string
  }
  filter: date_filter {
    type: date
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
  dimension: agency_id {
    type: string
    sql: ${TABLE}.agency_id ;;
  }
  dimension: day_of_week {
    type: string
    sql: ${TABLE}.day_of_week  ;;
  }
  dimension: time_split {
    type: string
    sql: ${TABLE}.time_split  ;;
  }
  dimension: publisher {
    type: string
    sql: ${TABLE}.publisher_group  ;;
  }
  measure: spend {
    type: sum
    sql: ${TABLE}.total_cdspend ;;
  }
  measure: clicks {
    type: sum
    sql: ${TABLE}.total_clicks ;;
  }
  measure: applies {
    type: sum
    sql: ${TABLE}.total_applies ;;
  }
  measure: cpc {
    type: number
    sql: iff(${clicks}=0,0,${spend}/${clicks}) ;;
  }
  measure: cpa {
    type: number
    sql: iff(${applies}=0,0,${spend}/${applies}) ;;
  }
  measure: cta {
    type: number
    sql: iff(${clicks}=0,0,${applies}/${clicks}) ;;
  }
  dimension: publisher_name {
    type: string
    sql: coalesce(${publisher_name_override.name},${publisher_name.name},${publisher}) ;;
  }
 }
