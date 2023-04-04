view: view_combined_event {
  sql_table_name: TRACKING.MODELLED.VIEW_GROUPED_COMBINED_EVENTS ;;
  dimension: should_contribute_to_joveo_stats {
    type: yesno
    sql: ${TABLE}.SHOULD_CONTRIBUTE_TO_JOVEO_STATS ;;
  }
  dimension: publisher_name {
    type: string
    sql: coalesce(${publisher_name_override.name},${publisher_name.name}) ;;
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
  measure: cd_spend_measure {
    type: sum
    sql: ${TABLE}.cd_spend ;;
    value_format: "#,##0.00"
  }
  measure: clicks_measure {
    type: sum
    sql: ${TABLE}.clicks ;;
    value_format: "#,##0"
  }
  measure: applies_measure {
    type: sum
    sql: ${TABLE}.applies ;;
    value_format: "#,##0"
  }
  measure: apply_starts_measure {
    type: sum
    sql: ${TABLE}.apply_starts ;;
    value_format: "#,##0"
  }
  measure: hires {
    type: sum
    sql: ${TABLE}.hires ;;
    value_format: "#,##0"
  }
  measure: cpc {
    type: number
    sql: iff(${clicks_measure}=0,0,${cd_spend_measure}/${clicks_measure}) ;;
    value_format: "0.##"
  }
  measure: cpa {
    type: number
    sql: iff(${applies_measure}=0,0,${cd_spend_measure}/${applies_measure}) ;;
    value_format: "0.##"
  }
  measure: cph {
    type: number
    sql: iff(${hires}=0,0,${cd_spend_measure}/${hires}) ;;
    value_format: "0.##"
  }
  measure: cta {
    type: number
    sql: iff(${clicks_measure}=0,0,${applies_measure}*100/${clicks_measure}) ;;
    value_format: "0.##%"
  }
  measure: ctas {
    type: number
    sql: iff(${clicks_measure}=0,0,${apply_starts_measure}*100/${clicks_measure}) ;;
    value_format: "0.##%"
  }
  measure: ath {
    type: number
    sql: iff(${applies_measure}=0,0,${hires}*100/${applies_measure}) ;;
    value_format: "0.##%"
  }
}
