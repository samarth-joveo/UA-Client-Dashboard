view: view_combined_event {
  sql_table_name: TRACKING.MODELLED.VIEW_GROUPED_COMBINED_EVENTS ;;
  dimension: should_contribute_to_joveo_stats {
    type: yesno
    sql: ${TABLE}.SHOULD_CONTRIBUTE_TO_JOVEO_STATS ;;
  }
  parameter: measure_names {
    type: unquoted
    allowed_value: {
      label: "Applies"
      value: "app"
    }
    allowed_value: {
      label: "SignUps"
      value: "su"
    }
  }
  measure: applies_dynamic_name {
    label: "{% if measure_names._parameter_value == 'app' %}
      Applies-1
    {% else %}
      SignUps-1
    {% endif %}"
    type: number
    sql: ${Applies} ;;
    value_format: "#,##0"
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
  measure: Spend {
    type: sum
    sql: ${TABLE}.cd_spend ;;
    value_format: "#,##0.00"
  }
  measure: Clicks {
    type: sum
    sql: ${TABLE}.clicks ;;
    value_format: "#,##0"
  }
  measure: Applies {
    type: sum
    sql: ${TABLE}.applies ;;
    value_format: "#,##0"
  }
  measure: Apply_Starts {
    type: sum
    sql: ${TABLE}.apply_starts ;;
    value_format: "#,##0"
  }
  measure: Hires {
    type: sum
    sql: ${TABLE}.hires ;;
    value_format: "#,##0"
  }
  measure: CPC {
    type: number
    sql: iff(${Clicks}=0,0,${Spend}/${Clicks}) ;;
    value_format: "0.##"
  }
  measure: CPA {
    type: number
    sql: iff(${Applies}=0,0,${Spend}/${Applies}) ;;
    value_format: "0.##"
  }
  measure: CPH {
    type: number
    sql: iff(${Hires}=0,0,${Spend}/${Hires}) ;;
    value_format: "0.##"
  }
  measure: CTA {
    type: number
    sql: iff(${Clicks}=0,0,${Applies}*100/${Clicks}) ;;
    value_format: "0.##%"
  }
  measure: CTAS {
    type: number
    sql: iff(${Clicks}=0,0,${Apply_Starts}*100/${Clicks}) ;;
    value_format: "0.##%"
  }
  measure: ath {
    label: "ATH"
    type: number
    sql: iff(${Applies}=0,0,${Hires}*100/${Applies}) ;;
    value_format: "0.##%"
  }

}
