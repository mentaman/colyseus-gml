var join_room_name = argument[0];
var options = json_decode( (argument_count > 1) ? argument[1] : "{}" );

var request_id = global.colyseus_request_id++;
ds_map_add(options, "requestId", request_id);

show_debug_message("SCRIPT: colyseus_join_room");

//
// build data structure for join request
//
var request_packet = ds_list_create();
ds_list_add(request_packet, COLYSEUS_PROTOCOL.JOIN_ROOM);
ds_list_add(request_packet, join_room_name);
ds_list_add(request_packet, options);
ds_list_mark_as_map(request_packet, 2);

// store join options on request id
global.colyseus_connecting_rooms[?request_id] = request_packet;
// ds_map_add_list(global.colyseus_connecting_rooms, request_id, );

var buffer = buffer_create(1, buffer_grow, 1);
msgpack_encode(buffer, request_packet);
network_send_raw(global.colyseus_client, buffer, buffer_tell(buffer));