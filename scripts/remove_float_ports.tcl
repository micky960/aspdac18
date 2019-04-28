foreach_in_collection abc [get_ports * -filter "direction == in"] {
        set pqr [get_attribute $abc full_name]
        set cnt [sizeof_collection [all_connected [get_ports $pqr]]]
        if {$cnt == 0} {remove_port $pqr
        echo "create_port -direction in $pqr" >> ../../Results/$design/create_port_${design_i}.tcl
        }
}
