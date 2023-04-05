view: campaign_info {
  sql_table_name: idp.modelled.campaign_management_campaigns ;;

  dimension: campaign_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }
  dimension: campaign_name {
    type: string
    sql: ${TABLE}.NAME ;;
  }
  dimension: campaign_budget {
    type: number
    sql:  case
          when budget_cap_frequency = 'DAILY' then budget_value * DAY(LAST_DAY(CURRENT_DATE()))
          when budget_cap_frequency = 'WEEKLY' then budget_value * 4
          else budget_value
          end ;;
  }
  dimension: campaign_status {
    type: string
    sql: ${TABLE}.status ;;
  }
  measure: total_campaign_budget {
    type: sum
    sql: ${campaign_budget} ;;
  }

}
