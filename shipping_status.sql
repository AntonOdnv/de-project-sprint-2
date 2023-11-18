drop table if exists public.shipping_status cascade;

create table public.shipping_status(
	shipping_id int8 not null,
	status text null,
	state text null,
	shipping_start_fact_datetime timestamp,
	shipping_end_fact_datetime timestamp,
	primary key(shipping_id)
);

with cte_status as (
	select shippingid, 
		   max(state_datetime) as max_dt
	from shipping
	group by shippingid 
)
insert into public.shipping_status(
	shipping_id, 
	status, 
	state, 
	shipping_start_fact_datetime, 
	shipping_end_fact_datetime
)
select shippingid:: int8,  
	   min(case 
		   when state_datetime = max_dt then status
	   end):: text as status,
	   min(case 
		   when state_datetime = max_dt then state
	   end):: text as state,
	   min(case 
	   		when state = 'booked' then state_datetime
	   end)::timestamp as shipping_start_fact_datetime,
	   max(case 
	   		when state = 'recieved' then state_datetime
	   end)::timestamp as shipping_end_fact_datetime
from (
	select shippingid, status, state, state_datetime, max_dt
	from shipping
	left join cte_status using(shippingid)
	) as tmp
group by shippingid;