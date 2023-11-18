drop table if exists public.shipping_agreement cascade;

create table public.shipping_agreement(
	agreement_id integer not null,
	agreement_number text not null,
	agreement_rate numeric(14, 2) not null,
	agreement_commission numeric(14, 2) not null,
	primary key(agreement_id)
);

with cte_vendor as (
select regexp_split_to_array(vendor_agreement_description, ':') as re  
from shipping)
insert into public.shipping_agreement
select distinct re[1]:: integer, 
	   re[2]:: text, 
	   re[3]:: numeric(14, 2), 
	   re[4]:: numeric(14, 2)
from cte_vendor;