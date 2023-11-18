drop table if exists public.shipping_info cascade;

create table public.shipping_info(
	shipping_id int8 not null,
	vendor_id int8,
	payment_amount numeric(14, 2),
	shipping_plan_datetime timestamp,
	shipping_transfer_id int8 not null, 
 	shipping_agreement_id int8 not null, 
 	shipping_country_rate_id int8 not null, 
 	primary key(shipping_id),
 	foreign key(shipping_transfer_id) references public.shipping_transfer(id) on update cascade, 
 	foreign key(shipping_agreement_id) references public.shipping_agreement(agreement_id) on update cascade, 
 	foreign key(shipping_country_rate_id) references public.shipping_country_rates(id) on update cascade
);

insert into public.shipping_info
select distinct shippingid, 
	   vendorid as vendor_id,
	   payment_amount,
	   shipping_plan_datetime,
	   st.id as shipping_transfer_id,
	   split_part(vendor_agreement_description, ':', 1)::int8 as shipping_agreement_id,
	   scr.id as shipping_country_rate_id
from shipping as sh
left join (
		select id, concat(transfer_type,':',transfer_model) as shipping_transfer_description
		from shipping_transfer) st 
		using(shipping_transfer_description)
left join shipping_country_rates scr using(shipping_country)