select queue_app_event_reasons.*
from queue_app_event_reasons, eventos, store_daily_sales, dias, metas
where queue_app_event_reasons.queue_app_event_id = eventos.id
and eventos.store_daily_sale_id = store_daily_sales.id
and store_daily_sales.date = dias.data
and store_daily_sales.store_id = dias.loja_id
and dias.meta_id = metas.id
and to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_EXTRA'
