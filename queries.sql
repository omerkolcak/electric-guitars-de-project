/* Average, minimum and maximum guitar price */
select avg(price) avg_price, min(price) min_price, max(price) max_price
from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg

/*  Avg guitar price, avg guitar_score  and total guitar count by each brand. */
select gf.brand, count(*) as guitar_count, round(avg(eg.price),2) as avg_price,
        round(avg(eg.guitar_score),2) as avg_score
from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg
join steady-copilot-413818.electric_guitars_dataset.guitar_info gf on eg.info_id = gf.info_id
group by gf.brand
order by avg_price desc;

/* Average price for origin of the guitar */
select gf.made_in, round(avg(eg.price),2) as avg_price
from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg
join steady-copilot-413818.electric_guitars_dataset.guitar_info gf on eg.info_id = gf.info_id
group by gf.made_in
order by avg_price desc

/* Top 10 most used body woods */
select body_material, wood_count
from (
  select gb.body_material, 
          row_number() over(order by count(*) desc) as rank, 
          count(*) as wood_count
  from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg
  join steady-copilot-413818.electric_guitars_dataset.guitar_body gb
  on eg.body_id = gb.body_id
  group by gb.body_material
) where rank <= 10;

/* Avg price for pickup and wood quality */
select has_top_brand_pickups, has_expensive_wood, avg(price) as avg_price
from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg
join steady-copilot-413818.electric_guitars_dataset.guitar_strengths_and_weaknesses stwk
on eg.st_and_wk_id = stwk.st_and_wk_id
group by has_top_brand_pickups, has_expensive_wood

/* Neck joint and guitar price */
select neck_joint, round(avg(eg.price),2) as avg_price
from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg
join steady-copilot-413818.electric_guitars_dataset.guitar_neck gn
on eg.neck_id = gn.neck_id
group by neck_joint

/* Most 5 common used neck shapes */
select shape, shape_count
from (
  select shape, row_number() over(order by count(*) desc) as rank,
          count(*) as shape_count
  from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg
  join steady-copilot-413818.electric_guitars_dataset.guitar_neck gn
  on eg.neck_id = gn.neck_id
  group by shape
) where rank <= 5;

/* Build a table to use in data analytics */
create or replace table steady-copilot-413818.electric_guitars_dataset.table_analytics as (
select model_name, price, guitar_score, guitar_color, body_material, bridge, body_type,
       pickup_configuration, switch, volume_controls, tone_controls, fretboard_material,
       frets, fret_number, fretboard_radius, brand, series, year, made_in, strings, 
       neck_joint, neck_material, scale_size, shape, nut, nut_width, has_locking_tuners,
       has_tremolo, has_top_brand_pickups, has_expensive_wood, has_neck_through_build,
       has_high_quality_nut
from steady-copilot-413818.electric_guitars_dataset.electric_guitars eg
join steady-copilot-413818.electric_guitars_dataset.guitar_body gb 
on eg.body_id = gb.body_id
join steady-copilot-413818.electric_guitars_dataset.guitar_electronics ge
on eg.electronics_id = ge.electronics_id
join steady-copilot-413818.electric_guitars_dataset.guitar_fretboard gf
on gf.fretboard_id = eg.fretboard_id
join steady-copilot-413818.electric_guitars_dataset.guitar_info gi
on gi.info_id = eg.info_id
join steady-copilot-413818.electric_guitars_dataset.guitar_neck gn
on eg.neck_id = gn.neck_id
join electric_guitars_dataset.guitar_strengths_and_weaknesses stwk
on stwk.st_and_wk_id = eg.st_and_wk_id );


