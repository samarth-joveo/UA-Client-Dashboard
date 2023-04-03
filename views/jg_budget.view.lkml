view: jg_budget {
  sql_table_name: idp.modelled.jg_caps_view ;;

  dimension: job_group_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.JOBGROUP_ID ;;
  }
  dimension: job_group_budget {
    type: number
    sql: ${TABLE}.JG_BUDGET_CAP_MONTHLY_BUDGET ;;
  }
  measure: total_job_group_budget {
    type: sum
    sql: ${job_group_budget} ;;
  }
 }
