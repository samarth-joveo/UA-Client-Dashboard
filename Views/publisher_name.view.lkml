view: publisher_name {
derived_table: {
  sql: select publisher_id,name  from idp.modelled.publisher_management_publishers where agency_id is null ;;
}
dimension: publisher_id {
  type: string
  sql: ${TABLE}.publisher_id ;;
}
dimension: name {
  type: string
  sql: ${TABLE}.name ;;
}
 }
