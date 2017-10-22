:local testip1 8.8.4.4
:local testip2 77.88.8.1

:local recursivedistance 100

:local recint $interface

:if ($bound=1) do={
:local count [/ip route print count-only where comment="rt-$interface"]
:if ($count=0) do={
    /ip route
        add gateway=$"gateway-address" comment="rt-$interface" routing-mark="$interface"
        add distance=20 dst-address="$testip1" gateway=$"gateway-address" comment="rt-$interface" 
        add distance=20 dst-address="$testip2" gateway=$"gateway-address" comment="rt-$interface" 

        add check-gateway=ping distance=$"recursivedistance" gateway="$testip1,$testip2" target-scope=30  comment="rec-rt-$interface" 

    /ip route rule
        add action=lookup-only-in-table routing-mark="$interface" table="$interface" comment="rt-$interface" 
        add action=lookup-only-in-table table="$interface" comment="rec-rt-$interface" dst-address="$testip1"
        add action=lookup-only-in-table table="$interface" comment="rec-rt-$interface" dst-address="$testip2"

    /ip firewall mangle
        add action=mark-connection chain=prerouting in-interface="$interface" \
            new-connection-mark="$interface" passthrough=yes comment="rt-$interface" 
        add action=mark-routing chain=prerouting connection-mark="$interface" \
            new-routing-mark="$interface" passthrough=yes comment="rt-$interface" 


} else={
    /ip route 
        set [ find where comment="rt-$interface" ] gateway=$"gateway-address"

    /ip firewall mangle

        set [ find where comment="rt-$interface" ] action=mark-connection chain=prerouting in-interface="$interface" \
            new-connection-mark="$interface" passthrough=yes
        set [ find where comment="rt-$interface" ] action=mark-routing chain=prerouting connection-mark="$interface" \
            new-routing-mark="$interface" passthrough=yes

}
} else={

   /ip route rule
        remove [find table="$recint"]

    /ip route rule
        remove [find table="$interface"]

    :log info [find table="$interface"]

    /ip firewall mangle
        remove [find comment="rt-$interface"]
    /ip firewall connection
        remove [find connection-mark="$interface"]
}
