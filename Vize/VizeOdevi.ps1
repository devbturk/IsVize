$netstat = @()

$TCPConnections = Get-NetTCPConnection | Select-Object State, LocalAddress, LocalPort, OwningProcess, RemoteAddress, RemotePort

foreach ($TCPConnection in $TCPConnections)
{
    $Process = Get-Process -Id $TCPConnection.OwningProcess

    $netstat += New-Object -TypeName PSObject -Property ([ordered]@{
        ProcessName  = $Process.ProcessName
        Protocol     = "TCP"
        LocalAddress = $TCPConnection.LocalAddress
        LocalPort     = $TCPConnection.LocalPort
        RemoteAddress =  $TCPConnection.RemoteAddress
        RemotePort    = $TCPConnection.LocalPort
        State       = $TCPConnection.State
        PID         = $TCPConnection.OwningProcess        
    })
}

$UDPEndpoints   = Get-NetUDPEndpoint | Select-Object LocalAddress, LocalPort, OwningProcess

foreach ($UDPEndpoint in $UDPEndpoints)
{
    $Process = Get-Process -Id $UDPEndpoint.OwningProcess

    $netstat += New-Object -TypeName PSObject -Property ([ordered]@{
        ProcessName  = $Process.ProcessName
        Protocol     = "UDP"
        LocalAddress = $UDPEndpoint.LocalAddress
        LocalPort    = $UDPEndpoint.LocalPort
        PID          = $UDPEndpoint.OwningProcess        
    })
}
cd ~\Desktop
$netstat | Format-Table -AutoSize | Out-File .\output.txt