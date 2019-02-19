/* see the order by at the end */
select distinct on (a.permno, a.date, d.gvkey) 
  a.*, b.HSICCD /* current SIC code */, b.NCUSIP,
  b.SICCD /* historical (time-varying) SIC code */,
  c.linktype, c.linkprim, c.linkdt, c.linkenddt, d.*
from 
  (select a1.cusip, a1.permno, a1.permco, a1.date, a1.vol, a1.ret, a1.retx,
   a1.prc,
   date_trunc('month', a1.date) as datetrunc
   from crsp.msf as a1
   where $1 >= a1.date and a1.date >= $2) as a 
/* join with names table */ 
inner join 
  (select * 
   from crsp.msenames as b1
   /* take only securities with the right share code */
   where b1.shrcd in (10, 11, 12, 30, 31, 32)) as b
on a.permno = b.permno and 
  a.date >= b.namedt and a.date <= b.nameendt
/* join with link table */
inner join 
  (select * 
   from crsp.Ccmxpf_linktable as c1
   where 
     /* linktype */
     c1.linktype in ('LC', 'LU', 'LS') and
     /* primary Link Marker */
     c1.linkprim in ('P', 'C')) as c
on a.permno = c.lpermno and 
  c.linkdt <= a.date and
  a.date <= coalesce(c.linkenddt, CURRENT_DATE)
/* take only those where we have an gvkey match. See Bharath et al (2008) for debt variables */ 
inner join 
  (select 
   d1.gvkey, d1.datadate,
   d1.dlcq,   /* Debt in Current Liabilities */
   d1.dlttq,  /* Long-Term Debt - Total */
   date_trunc('month', d1.datadate) as datadatetrunc,
   d1.fyearq, /* Fiscal Year */ 
   d1.fyr,    /* Fiscal Year-end Month */ 
   d1.tic,    /* Ticker Symbol */
   d1.conm    /* Company Name */  
   from comp.fundq as d1
  /* Take financial statements from 1 year back */
   where $1 >= d1.datadate and d1.datadate >= $2 - INTERVAL '12 month') as d
on 
  c.gvkey = d.gvkey and 
  a.datetrunc >= d.datadatetrunc and 
  d.datadatetrunc + INTERVAL '12 month' >= a.datetrunc
/* see https://stackoverflow.com/a/24042515/5861244 */
order by a.permno, a.date desc, d.gvkey, b.namedt desc, d.datadatetrunc desc;
