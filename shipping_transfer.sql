drop table if exists public.shipping_transfer cascade;

create table public.shipping_transfer(
	id serial,
	transfer_type text,
	transfer_model text,
	shipping_transfer_rate numeric(14, 3),
	primary key(id)
);

with cte_transfer as (
select regexp_split_to_array(shipping_transfer_description, ':') as re,
	   shipping_transfer_rate
from public.shipping)
insert into public.shipping_transfer(
	   transfer_type, transfer_model, shipping_transfer_rate 
)
select distinct re[1]:: text,
	   re[2]:: text,
	   shipping_transfer_rate:: numeric(14, 3)
from cte_transfer;