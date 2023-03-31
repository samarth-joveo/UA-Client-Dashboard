# Define the database connection to be used for this model.
connection: "idp"
include: "/Views/*.view.lkml"                # include all views in the views/ folder in this project

datagroup: ui_client_dashboard_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: ui_client_dashboard_default_datagroup


explore: client_info {}
explore: campaign_info {}
explore: jg_info {}
explore: jg_budget {}
explore: agency_info {}
explore: publisher_name {}
explore: source_wise_spend {
  join: publisher_name {
    type: left_outer
    sql_on: ${source_wise_spend.publisher} =  ${publisher_name.publisher_id};;
    relationship: many_to_one
  }
  join: publisher_name_override {
    type: left_outer
    sql_on: ${source_wise_spend.publisher} = ${publisher_name_override.publisher_id} and ${source_wise_spend.agency_id} = ${publisher_name_override.agency_id} ;;
    relationship: many_to_one
  }
}
explore: rational_distribution {
  join: publisher_name {
    type: left_outer
    sql_on: ${rational_distribution.publisher} =  ${publisher_name.publisher_id};;
    relationship: many_to_one
  }
  join: publisher_name_override {
    type: left_outer
    sql_on: ${rational_distribution.publisher} = ${publisher_name_override.publisher_id} and ${rational_distribution.agency_id} = ${publisher_name_override.agency_id} ;;
    relationship: many_to_one
  }
  join: loc_normalisation {
    type: left_outer
    sql_on: ${rational_distribution.job_city} = ${loc_normalisation.job_city} and ${loc_normalisation.job_state} = ${rational_distribution.job_state} and ${loc_normalisation.job_country} = ${rational_distribution.job_country} ;;
    relationship: many_to_one
  }

}
explore: trend_comparison {
  join: publisher_name {
    type: left_outer
    sql_on: ${trend_comparison.publisher_id} =  ${publisher_name.publisher_id};;
    relationship: many_to_one
  }
  join: publisher_name_override {
    type: left_outer
    sql_on: ${publisher_name.publisher_id} = ${publisher_name_override.publisher_id} and ${trend_comparison.agency_id} = ${publisher_name_override.agency_id} ;;
    relationship: many_to_one
  }
  join: agency_info {
    type: left_outer
    sql_on: ${trend_comparison.agency_id} = ${agency_info.agency_id} ;;
    relationship: many_to_one
  }
  join: client_info {
    type: left_outer
    sql_on: ${trend_comparison.client_id} = ${client_info.client_id} ;;
    relationship: many_to_one
  }
  join: campaign_info {
    type: left_outer
    sql_on: ${trend_comparison.campaign_id} = ${campaign_info.campaign_id} ;;
    relationship: many_to_one
  }
  join: jg_info {
    type: left_outer
    sql_on: ${trend_comparison.job_group_id} = ${jg_info.job_group_id} ;;
    relationship: many_to_one
  }
}
explore: view_combined_event {
  sql_always_where: ${should_contribute_to_joveo_stats} = TRUE ;;
  join: sponsored_job_count {
    type: left_outer
    sql_on: ${sponsored_job_count.agency_id} = ${view_combined_event.agency_id} and ${sponsored_job_count.client_id} = ${view_combined_event.client_id} and ${sponsored_job_count.campaign_id} = ${view_combined_event.campaign_id} and ${sponsored_job_count.job_group_id} = ${view_combined_event.JOB_GROUP_ID} and ${view_combined_event.date} = ${sponsored_job_count.date} ;;
    relationship: many_to_one
  }
  join: jg_info {
    type: left_outer
    sql_on: ${view_combined_event.JOB_GROUP_ID} = ${jg_info.job_group_id} ;;
    relationship: many_to_one
  }
  join: jg_budget {
    type: left_outer
    sql_on: ${view_combined_event.JOB_GROUP_ID} = ${jg_budget.job_group_id} ;;
    relationship: many_to_one
  }
  join: campaign_info {
    type: left_outer
    sql_on: ${view_combined_event.campaign_id} = ${campaign_info.campaign_id} ;;
    relationship: many_to_one
  }
  join: client_info {
    type: left_outer
    sql_on: ${view_combined_event.client_id} = ${client_info.client_id} ;;
    relationship: many_to_one
  }
  join: agency_info {
    type: left_outer
    sql_on: ${view_combined_event.agency_id} = ${agency_info.agency_id} ;;
    relationship: many_to_one
  }
  join: publisher_name {
    type: left_outer
    sql_on: ${view_combined_event.publisher_id} = ${publisher_name.publisher_id} ;;
    relationship: many_to_one
  }
  join: publisher_name_override {
    type: left_outer
    sql_on: ${view_combined_event.publisher_id} = ${publisher_name_override.publisher_id} and ${view_combined_event.agency_id} = ${publisher_name_override.agency_id}  ;;
    relationship: many_to_one
  }
}
