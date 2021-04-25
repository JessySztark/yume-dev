wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Admin = wOS.ALCS.Admin or {}
wOS.ALCS.Admin.BufferInfo = wOS.ALCS.Admin.BufferInfo or {}

net.Receive( "wOS.ALCS.Admin.GetBuffer", function( len, ply )

	local tbl = net.ReadTable()
	tbl = tbl or {}
	
	wOS.ALCS.Admin.BufferInfo = { Data = table.Copy( tbl ), Received = true }
	
end )