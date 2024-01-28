create view psych_titles as
select *
from (select * from titles
where type = "psychology") dt_psych
;