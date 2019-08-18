select eventos.*
from eventos, store_daily_sales, dias, metas
where eventos.store_daily_sale_id = store_daily_sales.id
and store_daily_sales.date = dias.data
and store_daily_sales.store_id = dias.loja_id
and dias.meta_id = metas.id
and to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_EXTRA'
