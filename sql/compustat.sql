select distinct on (q.gvkey, q.datadate)
  q.gvkey, q.tic,
  q.consol, /* Level of Consolidation - Company Interim Descriptor */
  q.indfmt, /* Industry Format */ 
  q.datafmt, /* Data Format */ 
  q.costat, /* A=Active,I=Inactive */
  q.fyearq , /* Fiscal Year */
  q.fyr, /* Fiscal Year-end Month */ 
  q.datadate, /* E.g., for annual company data items this item equals the fiscal 
                 period end date */
  q.exchg, /* Stock Exchange Code: 11	New York Stock Exchange
                                   12	American Stock Exchange
                                   14	NASDAQ-NMS Stock Market   */
  q.cusip, q.conm, /* Company Name */ 
  q.WCAPQ, q.ATQ, q.REQ, q.OIADPQ, q.SALEQ, q.NIQ, q.LTQ, q.ACTQ, 
  a.WCAP , a.AT , a.RE , a.OIADP , a.SALE , a.NI , a.LT , a.ACT ,
  
  q.DLCQ, q.LCTQ, q.DLTTQ, q.CHEQ, q.RECTQ, q.SEQQ, q.TXDITCQ, 
  a.DLC , a.LCT , a.DLTT , a.CHE , a.RECT , a.SEQ , a.TXDITC ,
  
  q.TXDBQ, q.PSTKQ, q.mibq, q.ceqq,
  a.TXDB , a.PSTK , a.mib , a.ceq ,
  
  /* extra columns which are only in the annual data set */
  a.ITCB, a.PSTKRV, a.PSTKL,
  
  a.datadate as a_datadate, a.fyear as a_fyear, a.fyr as a_fyr, a.sich
from compm.fundq as q
left join compm.funda as a on
  a.gvkey = q.gvkey and 
  a.datadate <= q.datadate and  a.datadate + INTERVAL '12 month' >= q.datadate
where q.datadate >= '{MIN_DATE}' and q.gvkey not in {GVKEY_EXL}
/* join the most recent annual data */
order by q.gvkey, q.datadate, a.datadate desc 
