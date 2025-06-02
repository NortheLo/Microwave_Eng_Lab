[FFT of time domain data]
{
   Npanes: 1
   {
      traces: 3 {524290,0,"V(high_freq)"} {524291,0,"V(low_freq)"} {524292,0,"V(mod)"}
      X: ('M',0,1000,0,1.31071e+08)
      Y[0]: (' ',0,1e-15,30,1)
      Y[1]: (' ',0,-200,40,200)
      Log: 1 2 0
      PltMag: 1
   }
}
[Transient Analysis]
{
   Npanes: 1
   {
      traces: 3 {524290,0,"V(low_freq)"} {524291,0,"V(high_freq)"} {524292,0,"V(mod)"}
      X: ('m',1,0,0.0001,0.001)
      Y[0]: (' ',1,-1.5,0.3,1.5)
      Y[1]: ('_',0,1e+308,0,-1e+308)
      Volts: (' ',0,0,1,-1.5,0.3,1.5)
      Log: 0 0 0
   }
}
