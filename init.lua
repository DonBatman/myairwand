core.register_tool("myairwand:wand", {
    description = "A wand to place nodes in the air",
    inventory_image = "myairwand_wand.png",
    
    on_use = function(itemstack, user, pointed_thing)
        local player_name = user:get_player_name()
        
        local pos = user:get_pos()
        pos.y = pos.y + user:get_properties().eye_height
        
        local dir = user:get_look_dir()
        local place_pos = vector.round(vector.add(pos, vector.multiply(dir, 3)))

        if core.is_protected(place_pos, player_name) then
            core.chat_send_player(player_name, "This area is protected!")
            return
        end

        local node_at_pos = core.get_node(place_pos)
        local node_def = core.registered_nodes[node_at_pos.name]
        if not node_def or not node_def.buildable_to then
            return 
        end

        local inv = user:get_inventory()
        local wield_index = user:get_wield_index()
        local target_slot = wield_index + 1
        
        if target_slot > inv:get_size("main") then return end
        
        local stack_to_place = inv:get_stack("main", target_slot)

        if not stack_to_place:is_empty() then
            local item_name = stack_to_place:get_name()
            local item_def = core.registered_items[item_name]
            
            if item_def and item_def.type == "node" then
                core.set_node(place_pos, {name = item_name})
                
                core.sound_play("default_place_node", {pos = place_pos, gain = 0.5}, true)

                if not core.settings:get_bool("creative_mode") then
                    stack_to_place:take_item()
                    inv:set_stack("main", target_slot, stack_to_place)
                end
            end
        end
    end,
})

core.register_craft({
    output = "myairwand:wand",
    recipe = {
        {"", "", "default:steel_ingot"},
        {"", "default:steel_ingot", ""},
        {"default:glass", "", ""},
    }
})
