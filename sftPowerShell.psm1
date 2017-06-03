function Invoke-SftCommand
{
	param
	(
		[parameter(Mandatory=$false)]
		[ValidateSet('config','dash','device-info','enroll','list-accounts','list-servers','login','logout','proxycommand','rdp','resolve','ssh','unenroll','use','version','help')]
		[string]$Command,
		[parameter(Mandatory=$false)]
		[string]$Argument
	)

	try
	{
		$ErrorActionPreference = 'Stop';
		$Error.Clear();
		
		$CmdLine = "sft $($Command)";

		switch ($Command)
		{
			'device-info'
			{
				$CmdLine += ' |ConvertFrom-Json';
			}
			'list-accounts'
			{
				$CmdLine += " |ForEach-Object {if (`$_.Substring(0,12).Trim() -ne 'USERNAME'){New-Object -TypeName psobject -Property @{Username = `$_.Substring(0,12).Trim();Account = `$_.Substring(12,16).Trim();Url = `$_.Substring(28,30).Trim();Id = `$_.Substring(58,40).Trim();Status = `$_.Substring(98,33).Trim() }}} |Select-Object -Property Username, Account, Url, Id, Status";
			}
			'list-servers'
			{
				$CmdLine += " |ForEach-Object {if (`$_.Substring(0,33).Trim() -ne 'HOSTNAME'){New-Object -TypeName psobject -Property @{ HostName = `$_.Substring(0,33).Trim();OsType = `$_.Substring(33,11).Trim(); ProjectName = `$_.Substring(44,47).Trim(); ID = `$_.Substring(91,40); AccessAddress = `$_.Substring(131,33).Trim() }}} |Select-Object -Property Hostname, OsType, ProjectName, Id, AccessAddress"
			}
			default
			{
				if ($Argument)
				{
					$CmdLine += " $($Argument)";
				}
			}
		}

		Invoke-Expression -Command $CmdLine
	}
	catch
	{
		throw $_;
	}
}