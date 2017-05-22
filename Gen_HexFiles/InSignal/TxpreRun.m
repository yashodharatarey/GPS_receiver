function Insignal=TxpreRun(filename,varname)
addpath matfiles/
load(filename);
var_in=eval(varname);
data=round(var_in*2^16);
Insignal.time=[ ];
Insignal.signals.values=data;
Insignal.signals.dimensions=1;
end