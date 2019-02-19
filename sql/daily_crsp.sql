-- modified parts of crspmerge.sas
-- see https://wrds-web.wharton.upenn.edu/wrds/support/code_show.cfm?path=CRSP/crspmerge.sas

-- You need to load the string and replace 
--  {STAT_DATE} {END_DATE} {S}
-- dates should be ISO-8601 format, YYYY-MM-DD (maybe?)

-- {S}sf is the stock data
-- {S}se is the events data
-- {S}senames is further meta data?

-- stock data
select permco, permno, date, prc, shrout, ret, retx
    from crsp.{S}sf
    where date between '{STAT_DATE}' and '{END_DATE}' and permno in
    (select distinct permno 
      from crsp.{S}senames
      WHERE '{END_DATE}' >= NAMEDT and '{STAT_DATE}' <= NAMEENDT)
    order by permno, date;
    
-- event data
select a.date, a.permno, a.exchcd
   from crsp.{S}se as a,
    (select distinct c.permno, min(c.namedt) as minnamedt from
      (select permno, namedt, nameendt
        from crsp.{S}senames
        WHERE '{END_DATE}'>= NAMEDT and '{STAT_DATE}'<= NAMEENDT) as c
      group by c.permno) as b
   where a.date >= b.minnamedt and a.date <= '{END_DATE}' and 
   -- notice the not null check on exchcd
    a.permno = b.permno and a.exchcd IS NOT NULL 
   order by a.permno, a.date;
