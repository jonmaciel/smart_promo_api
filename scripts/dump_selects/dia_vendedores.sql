select dia_vendedores.*
from dia_vendedores, metas
where dia_vendedores.meta_id = metas.id
and to_char(to_date(metas.nome, 'MM/YYYY'), 'YYYYMM') >= 'MIN_MONTH_GENERAL'
