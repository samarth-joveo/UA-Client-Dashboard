view: jg_info {
  sql_table_name: idp.modelled.campaign_management_jobgroups ;;

  dimension: job_group_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }
  dimension: job_group_name {
    type: string
    sql: ${TABLE}.NAME ;;
  }
}
