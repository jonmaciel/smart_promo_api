select metas.*
from metas
where to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_GENERAL'
