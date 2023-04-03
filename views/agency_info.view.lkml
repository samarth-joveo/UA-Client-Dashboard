view: agency_info {
  sql_table_name: IDP.MODELLED.CAMPAIGN_MANAGEMENT_AGENCIES ;;
  dimension: agency_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }
  dimension: agency_name {
    type: string
    sql: ${TABLE}.display_name ;;
  }
  dimension: agency_currency {
    type: string
    sql: ${TABLE}.CURRENCY ;;
  }
  dimension: agency_name_display {
    type: string
    sql: CONCAT(${agency_name},' - ',${agency_currency}) ;;
  }
}
