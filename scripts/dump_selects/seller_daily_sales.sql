select seller_daily_sales.*
from seller_daily_sales, dias, metas
where seller_daily_sales.date = dias.data
and seller_daily_sales.store_id = dias.loja_id
and dias.meta_id = metas.id
and to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_GENERAL'
