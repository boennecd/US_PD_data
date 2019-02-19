/* see https://wrds-web.wharton.upenn.edu/wrds/support/code_show.cfm?path=CRSP/crspmerge.sas 
 * see https://dba.stackexchange.com/a/49555 for the way that we get the most 
 * recent record
 * see https://stackoverflow.com/a/15164733/5861244 for value weighted mean */ 
select f.date,
  sum(f.mv)                      as market_size, 
  avg(f.ret)                     as ewret, 
  avg(f.retx)                    as ewretx, 
  sum(f.ret * f.mv) / sum(f.mv)  as vwret, 
  sum(f.retx * f.mv) / sum(f.mv) as vwretx, 
  count(f.date)                  as n_firms
from
(
  select DISTINCT ON (a.permno, a.date) a.*, b.exchcd
  from 
  (
    /* stock data */
    select date, permno,
      abs(prc) * shrout as mv, /* market value */ 
      ret, retx /* return including and excluding dividends */ 
    from crsp.dsf
    WHERE date between '1940-01-01' and '2018-12-31' and permno in 
    (
      select distinct permno 
      from crspa.dsenames
      where '2018-12-31'>= NAMEDT and '1940-01-01'<= NAMEENDT
    ) and prc is not null and shrout is not null and 
        ret is not null and retx is not null
  ) as a
  left join 
  (
    /* event data with exchange code */
    select b1.permno, b1.date, b1.exchcd
    from crsp.dse as b1, 
    (
      select distinct permno, min(namedt) as minnamedt
      from crspa.dsenames
          where '2018-12-31'>= NAMEDT and '1940-01-01'<= NAMEENDT
          group by permno
    ) as b2
    where b1.date >= b2.minnamedt and b1.date <= '2018-12-31' and 
      b1.permno = b2.permno and b1.exchcd is not null
  ) as b on a.permno = b.permno and a.date >= b.date
  order by a.permno, a.date, b.date desc
) as f 
where f.exchcd in (1, 2, 3) /* respectively 1, 2, and 3 for NYSE, AMEX, and  
                               the Nasdaq Stock MarketSM */
group by f.date;
