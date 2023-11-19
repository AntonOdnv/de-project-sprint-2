drop table if exists public.shipping_country_rates cascade;

create table public.shipping_country_rates(
	id serial,
	shipping_country varchar(30),
    shipping_country_base_rate numeric(3, 2),
	primary key(id)
);

insert into public.shipping_country_rates(shipping_country, shipping_country_base_rate)
select distinct shipping_country, shipping_country_base_rate
from public.shipping;