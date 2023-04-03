view: publisher_name_override {
 derived_table: {
  sql: select publisher_id,agency_id,name  from idp.modelled.publisher_management_publishers where agency_id is not null ;;
}
dimension: publisher_id {
  type: string
  sql: ${TABLE}.publisher_id ;;
}
  dimension: agency_id {
    type: string
    sql: ${TABLE}.agency_id ;;
  }
dimension: name {
  type: string
  sql: ${TABLE}.name ;;
}


}
