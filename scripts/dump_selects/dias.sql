select dias.*
from dias, metas
where dias.meta_id = metas.id
and to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_GENERAL'
