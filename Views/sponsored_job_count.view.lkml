view: sponsored_job_count {
derived_table: {
  sql: select agency_id,client_id,campaign_id,job_group_id,date,max(sponsored_jobs_count) sponsored_jobs_count  from JOBS.MODELLED.HISTORICAL_JOB_COUNT group by agency_id,client_id,campaign_id,job_group_id,date ;;
}
dimension: row_number {
  primary_key: yes
  type: number
  sql: concat(${agency_id},${client_id},${campaign_id},${job_group_id},${date});;
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
dimension: job_group_id {
  type: string
  sql: ${TABLE}.job_group_id ;;
}
dimension: date {
  type: date
  sql: ${TABLE}.date;;
}
measure: sponsored_jobs_count {
  type: sum
  sql: ${TABLE}.sponsored_jobs_count ;;
}
 }
