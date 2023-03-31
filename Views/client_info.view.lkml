view: client_info {
  sql_table_name: idp.modelled.campaign_management_clients ;;

  dimension: client_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }
  dimension: client_name {
    type: string
    sql: ${TABLE}.NAME ;;
  }
  dimension: client_budget {
    type: number
    sql:  case
          when budget_cap_frequency = 'DAILY' then budget_value * DAY(LAST_DAY(CURRENT_DATE()))
          when budget_cap_frequency = 'WEEKLY' then budget_value * 4
          else budget_value
          end ;;
  }
  measure: total_client_budget {
    type: sum
    sql: ${client_budget} ;;
  }

}
