param(
  [Parameter(Mandatory=$true)]
  $file
)

$lines = Get-Content -Path $file 

foreach ($l in $lines) {
  $array = $l.Split("=")
  $name = $array[0]
  $value = $array[1]
  write-host "Setting env $name to $value"
  [System.Environment]::SetEnvironmentVariable($name,$value)
}