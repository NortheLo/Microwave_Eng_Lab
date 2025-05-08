clear; clc;

db_2_lin    = @(g) 10^(g / 10);

f_lna = db_2_lin(2.5);
f_mix = db_2_lin(11);
f_ifa = db_2_lin(15);
f_ad  = db_2_lin(55);

g_lna = db_2_lin(18);
g_mix = db_2_lin(-11);
g_ifa = db_2_lin(35);

 f_sys =  f_lna +...
         (f_mix - 1) / (g_lna) +...
         (f_ifa - 1) / (g_lna * g_mix) +...
         (f_ad  - 1)  / (g_lna * g_mix * g_ifa)

 f_sys_db = 10 * log10(f_sys)