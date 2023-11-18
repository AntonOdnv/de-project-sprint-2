create or replace view shipping_datamart as
select shipping_id,
	   vendor_id,
	   st.transfer_type as transfer_type,
	   case 
	   	 when sst_full.shipping_end_fact_datetime is not null
	   	 	then extract(day from (sst_full.shipping_end_fact_datetime - sst_full.shipping_start_fact_datetime))
	   end as full_day_at_shipping,
	   case 
	   	 when sst_full.shipping_end_fact_datetime > si.shipping_plan_datetime then 1
	   	 else 0
	   end as is_delay,	   
	   case 
	   	 when sst_full.shipping_end_fact_datetime is not null then 1
	   	 else 0
	   end as is_shipping_finish,
	   case 
	   	 when sst_full.shipping_end_fact_datetime > si.shipping_plan_datetime 
	   	 	then extract(day from (sst_full.shipping_end_fact_datetime - si.shipping_plan_datetime))
	   	 else 0
	   end as delay_day_at_shipping,
	   payment_amount,
	   payment_amount*(scr.shipping_country_base_rate + sa.agreement_rate + st.shipping_transfer_rate) as vat,
	   payment_amount*sa.agreement_commission as profit
from shipping_info si 
left join (
		select id, transfer_type, shipping_transfer_rate 
		from shipping_transfer) st 
		on si.shipping_transfer_id = st.id
left join (
		select shipping_id, shipping_end_fact_datetime, shipping_start_fact_datetime
		from shipping_status) sst_full 
		using(shipping_id)
left join (
		select id, shipping_country_base_rate
		from shipping_country_rates) scr 
		on si.shipping_country_rate_id = scr.id
left join (
		select agreement_id, agreement_rate, agreement_commission
		from shipping_agreement) sa 
		on si.shipping_agreement_id = sa.agreement_id;