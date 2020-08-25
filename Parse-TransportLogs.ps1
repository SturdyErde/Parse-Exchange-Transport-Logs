$smtplogpath = read-host "What is the path of the folder containing SMTP logs"
write-output "Reading in source SMTP log files from $smtplogpath and parsing for message sends"
$FilteredLogs = (select-string $smtplogpath\*.log -pattern "Queued").Line
write-output  "Reading parsed logs from $smtplogpath"
$SMTPTransactions = Convertfrom-Csv -InputObject $FilteredLogs -Header dt,connector,session,sequence-number,local,remote,event,data,context
$Results = $SMTPTransactions.remote -replace '(.*):(.*)','$1' | Group-Object | Select-Object Count, @{Name="IPAddress";Expression={ $_.Name }}, @{Name="Hostname";Expression={ ([System.Net.Dns]::GetHostEntry($_.Name)).HostName }} | Sort-Object count -Descending
