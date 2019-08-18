select grouped_lost_reasons.*
from grouped_lost_reasons, dias, metas
where grouped_lost_reasons.date = dias.data
and grouped_lost_reasons.store_id = dias.loja_id
and dias.meta_id = metas.id
and to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_EXTRA'
