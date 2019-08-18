select feedbacks_sellers.*
from feedbacks_sellers, semanas, metas
where feedbacks_sellers.semana_id = semanas.id
and semanas.meta_id = metas.id
and to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_GENERAL'
