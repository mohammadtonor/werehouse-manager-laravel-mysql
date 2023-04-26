CREATE PROCEDURE `Create_Exit_Request_and_Details_from_Orders`()
BEGIN
      DECLARE val INT ;
			DECLARE counter2 int;
			DECLARE zone_count int;
			DECLARE zone_title VARCHAR(50);
			DECLARE zone_title_farsi VARCHAR(50);
			declare zone_line_start int;
			DECLARE zone_line_finish int;
			DECLARE zone_id int;
			DECLARE order_count_max int DEFAULT 50;
			DECLARE exit_request_count_max int DEFAULT 15;
			DECLARE exit_request_count_current int;
			DECLARE exit_request_item_max int;
			DECLARE exit_request_iterate_max int;
			DECLARE exit_start_limit int;
			DECLARE exit_end_limit int;
			DECLARE total_item_per_request int;
			DECLARE total_exit_request_count int;
			DECLARE last_exit_request_id int;

     
			SELECT count(*) into zone_count from zones;
			
		  SET val =1;
			while val <= zone_count DO
			
			  SELECT id ,title, title_farsi,line_start, line_finish 
				into zone_id, zone_title, zone_title_farsi,zone_line_start, zone_line_finish 
				from zones where id = val;
				
				 SELECT COUNT(DISTINCT product_id) into total_item_per_request FROM
         (SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max  ) tbl
         INNER JOIN werehouses.order_details od on tbl.id = od.order_id 
         inner JOIN product_shelves sp on od.Product_id = sp.product_id 
         INNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(@zone,'%') and sh.line_number BETWEEN @start2 and @finish
         GROUP BY od.id ORDER BY od.id) as tbl; 
				
				IF total_item_per_request <= exit_request_count_max  THEN
				   
					 SELECT sum(sum_count_first) into total_exit_request_count from 
           (
	         SELECT product_id , count_first,SUM(count_first) sum_count_first,count(product_id) FROM
           (
	         SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max  ) tbl
           INNER JOIN werehouses.order_details od on tbl.id = od.order_id 
           inner JOIN product_shelves sp on od.Product_id = sp.product_id 
           INNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(zone_title,'%') and sh.line_number BETWEEN zone_line_start and zone_line_finish
           GROUP BY od.id ORDER BY od.id) as tbl GROUP BY product_id 
		       ) as tbl2; 
					
					 INSERT INTO exit_requests(title,zone_id,total_exit_count,exit_request_status_id,total_exited_count,current_user_id,created_at) VALUES(zone_title_farsi,zone_id ,total_exit_request_count,1,0,1,CURRENT_TIMESTAMP);
					 
					 SELECT id into last_exit_request_id FROM exit_requests ORDER BY id DESC limit 1;
					 
					 INSERT INTO exit_request_details(product_id,request_count,exit_request_id,created_at) 
					 SELECT product_id ,SUM(count_first) sum_count_first,last_exit_request_id,CURRENT_TIMESTAMP FROM
           (
	         SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max  ) tbl
           INNER JOIN werehouses.order_details od on tbl.id = od.order_id 
           inner JOIN product_shelves sp on od.Product_id = sp.product_id 
           INNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(zone_title,'%') and sh.line_number BETWEEN zone_line_start and zone_line_finish
           GROUP BY od.id ORDER BY od.id) as tbl GROUP BY product_id;
					 
					 SELECT id into last_exit_request_id FROM exit_requests ORDER BY id DESC LIMIT 1;
					 
					 UPDATE order_details od JOIN(
					      SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max  ) tbl
                INNER JOIN werehouses.order_details od on tbl.id = od.order_id 
                inner JOIN product_shelves sp on od.Product_id = sp.product_id 
                INNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(zone_title,'%') and sh.line_number BETWEEN zone_line_start and zone_line_finish
                GROUP BY od.id ORDER BY od.id
					 ) as tbl
					 on od.id = tbl.od_id
					 set od.exit_request_id = last_exit_request_id;
					 
        ELSE
				
					IF MOD(total_item_per_request,exit_request_count_max) != 0 THEN
						 set exit_request_iterate_max = FLOOR(total_item_per_request/exit_request_count_max) + 1;
          ELSE
					   SET exit_request_iterate_max = total_item_per_request/exit_request_count_max; 
          END IF;

				  set counter2 = 0;
				  WHILE counter2 < exit_request_iterate_max DO
				   set exit_start_limit = counter2 * exit_request_count_max;
					 
					 SELECT sum(sum_count_first) into total_exit_request_count from 
           (
	         SELECT product_id , count_first,SUM(count_first) sum_count_first,count(product_id) FROM
           (
	         SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max  ) tbl
           INNER JOIN werehouses.order_details od on tbl.id = od.order_id 
           inner JOIN product_shelves sp on od.Product_id = sp.product_id 
           INNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(zone_title,'%') and sh.line_number BETWEEN        
					 zone_line_start and zone_line_finish
           GROUP BY od.id ORDER BY od.id) as tbl GROUP BY product_id limit exit_start_limit,exit_request_count_max
		       ) as tbl2; 
					 
					 INSERT INTO exit_requests(title,zone_id,total_exit_count,exit_request_status_id,total_exited_count,current_user_id,created_at) VALUES(zone_title_farsi,zone_id ,total_exit_request_count,1,0,1,CURRENT_TIMESTAMP);
					 
					 SELECT id into last_exit_request_id FROM exit_requests ORDER BY id DESC limit 1;
					 
					 INSERT INTO exit_request_detailes (product_id,request_count,exit_request_id,created_at) 
					 SELECT product_id ,SUM(count_first) sum_count_first,last_exit_request_id,CURRENT_TIMESTAMP FROM
           (
	         SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max  ) tbl
           INNER JOIN order_details od on tbl.id = od.order_id 
           inner JOIN product_shelves sp on od.Product_id = sp.product_id 
           INNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(zone_title,'%') and sh.line_number BETWEEN  zone_line_start and zone_line_finish
           GROUP BY od.id ORDER BY od.id) as tbl GROUP BY product_id limit exit_start_limit,exit_request_count_max ;
					 
					  UPDATE order_details od JOIN(
						SELECT od_id from 
						    (SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max  ) tbl
                INNER JOIN werehouses.order_details od on tbl.id = od.order_id 
                inner JOIN product_shelves sp on od.Product_id = sp.product_id 
                INNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(zone_title,'%') and sh.line_number BETWEEN zone_line_start and zone_line_finish
                GROUP BY od.id ORDER BY od.id) as tbl1 WHERE 
							EXISTS (
							  select product_id,od_id from 
					     (SELECT product_id ,od_id FROM (
	              SELECT od.product_id product_id,od.id od_id,od.count count_first FROM (SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max ) tbl
                INNER JOIN order_details od on tbl.id = od.order_id 
                inner JOIN product_shelves sp on od.Product_id = sp.product_id 
                iNNER JOIN shelves sh on sh.id = sp.shelve_id  where sh.title like CONCAT(zone_title,'%') and sh.line_number BETWEEN  zone_line_start and zone_line_finish
                GROUP BY od.id ORDER BY od.id) as tbl GROUP BY product_id limit exit_start_limit,exit_request_count_max ) as tbl2 
							where tbl1.product_id = tbl2.product_id)
					 ) as tbl
					 on od.id = tbl.od_id
					 set od.exit_request_id = last_exit_request_id,od.updated_at = CURRENT_TIMESTAMP;
					 
 					 set counter2 = counter2 +1;
          END WHILE;
        END IF;
        SET val = val + 1;
      END WHILE;
			
			UPDATE orders o JOIN(SELECT id FROM orders o ORDER BY Priority DESC,id limit order_count_max ) as tbl on o.id = tbl.id set o.has_exit_request = 1,o.updated_at = CURRENT_TIMESTAMP;
			
END
#########################################################################################################################################################################################################

CREATE PROCEDURE `Pickup_operation`(
IN curent_user_id_IN int,IN shelve_id_IN int,
out exit_reqest_id_out int, out product_id_out int,out shelve_id_out int,out shelve_title_out VARCHAR(200))
BEGIN
DECLARE user_access_str VARCHAR(200);
DECLARE exit_request_id_current int;
DECLARE current_user_id_updated int;
DECLARE shelve_id_current int;
DECLARE shelve_id_current_updated int;

SELECT shelve_access into user_access_str FROM user_access WHERE user_id = curent_user_id_IN;

 SELECT ex_id,sh_id into exit_request_id_current,shelve_id_current from 
 (
   SELECT exr.id ex_id,exr.periority ex_per,exr.current_user_id ex_usr,
  exrd.product_id product_id,sh.title sh_title,sh.id sh_id,
	sum(exrd.request_count) sum_req_count,sum(exrd.exited_count) sum_ext_count 
	from exit_requests exr 
 INNER JOIN exit_request_detailes exrd on exr.id = exrd.exit_request_id
 INNER JOIN product_shelves sp on sp.product_id = exrd.product_id
 INNER JOIN shelves sh on sh.id = sp.shelve_id
 where (exr.current_user_id = 0 or exr.current_user_id= curent_user_id_IN) AND  sh.title  REGEXP user_access_str
 GROUP BY exr.id,exrd.product_id ORDER BY exr.periority DESC, exr.current_user_id DESC, exr.id,sh.id) tbl 
 WHERE sum_req_count != sum_ext_count  limit 1;
 
 IF shelve_id_IN = '' OR ISNULL(shelve_id_IN) or shelve_id_IN = 0 THEN
 SET shelve_id_current_updated = shelve_id_current;
 else 
 SET shelve_id_current_updated = shelve_id_IN;
 end if;

SELECT current_user_id INTO current_user_id_updated FROM exit_requests WHERE id = exit_request_id_current;
IF current_user_id_updated != curent_user_id_IN THEN
UPDATE exit_requests  set current_user_id = curent_user_id_IN whERE id = exit_request_id_current;
END if;

SELECT ex_id,product_id,ex_per,ex_usr ,sh_title ,sh_id into exit_reqest_id_out, product_id_out,shelve_title_out,shelve_id_out from (
 SELECT ex_id,product_id,ex_per,ex_usr ,sh_title ,sh_id ,sum_req_count,sum_ext_count from 
 (SELECT exr.id ex_id,exr.periority ex_per,exr.current_user_id ex_usr,exrd.product_id product_id,sh.title sh_title,sh.id sh_id ,sum(exrd.request_count) sum_req_count,sum(exrd.exited_count)   sum_ext_count from exit_requests exr 
 INNER JOIN exit_request_detailes exrd on exr.id = exrd.exit_request_id
 INNER JOIN product_shelves sp on sp.product_id = exrd.product_id
 INNER JOIN shelves sh on sh.id = sp.shelve_id
 where (exr.current_user_id = 0 or exr.current_user_id= curent_user_id_IN) AND  sh.title  REGEXP 'sh1-c'
 GROUP BY exr.id,exrd.product_id ORDER BY exr.periority DESC, exr.current_user_id DESC, exr.id,sh.id ) tbl WHERE sum_req_count != sum_ext_count and ex_id = exit_request_id_current and sh_id >= shelve_id_current_updated
 UNION
 SELECT ex_id,product_id,ex_per,ex_usr ,sh_title ,sh_id ,sum_req_count,sum_ext_count from 
 (SELECT exr.id ex_id,exr.periority ex_per,exr.current_user_id ex_usr,exrd.product_id product_id,sh.title sh_title,sh.id sh_id ,sum(exrd.request_count) sum_req_count,sum(exrd.exited_count)   sum_ext_count from exit_requests exr 
 INNER JOIN exit_request_detailes exrd on exr.id = exrd.exit_request_id
 INNER JOIN product_shelves sp on sp.product_id = exrd.product_id
 INNER JOIN shelves sh on sh.id = sp.shelve_id
 where (exr.current_user_id = 0 or exr.current_user_id= curent_user_id_IN) AND  sh.title  REGEXP 'sh1-c'
 GROUP BY exr.id,exrd.product_id ORDER BY exr.periority DESC, exr.current_user_id DESC, exr.id,sh.id DESC) tbl WHERE sum_req_count != sum_ext_count and ex_id = exit_request_id_current and sh_id < shelve_id_current_updated
 limit 1) as tbl;

END

#########################################################################################################################################################################################################

CREATE `Insert_and_Update_on_Exit_Request_Detailes`(
IN `product_id_in` int,IN `shelve_id_in` int,
IN `basket_id_in` int,IN `exit_request_id_in` int,
IN `exited_count_in` int, IN `not_exited_count_in` int,
IN `current_user_id_in` int
)
BEGIN
DECLARE exit_request_in_basket_id int;
DECLARE product_shelve_count_curent int;
DECLARE product_shelve_id int;
DECLARE total_exit_request_count int;
DECLARE total_exited_request_count int;
DECLARE total_exited_request_updated int;
DECLARE total_not_exited_request int;
DECLARE total_sum_exited_not_exited int;
SELECT exit_request_id into exit_request_in_basket_id FROM baskets WHERE id = basket_id_in;
IF exit_request_in_basket_id = 0  THEN 
UPDATE baskets SET exit_request_id = exit_request_id_in WHERE id = basket_id_in;
END IF;


SELECT total_exit_count,total_exited_count into total_exit_request_count,total_exited_request_count FROM exit_requests WHERE id = exit_request_id_in;
IF exited_count_in = 1 THEN
INSERT INTO exit_request_detailes(product_id,shelve_id,basket_id, exit_request_id_in, exited_count,not_exited_count,current_user_id,created_at) 
VALUES(product_id_in,shelve_id_in,basket_id_in,exit_request_id_in,1,0,current_user_id_in,CURRENT_TIMESTAMP);
SELECT id ,product_count into product_shelve_id, product_shelve_count_curent FROM product_shelves WHERE product_id = product_id_in and shelve_id = shelve_id_in;
UPDATE product_shelves SET product_count = product_shelve_count_curent - 1 WHERE id = product_shelve_id;
UPDATE exit_requests SET total_exited_count = total_exited_request_count + 1 WHERE id = exit_request_id_in;

ELSEif not_exited_count_in = 1 THEN 
INSERT INTO exit_request_detailes(product_id,shelve_id,basket_id, exit_request_id_in, exited_count,not_exited_count,current_user_id,created_at) 
VALUES(product_id_in,shelve_id_in,basket_id_in,exit_request_id_in,0,1,current_user_id_in,CURRENT_TIMESTAMP);
END IF;

SELECT SUM(exited_count),SUM(not_exited_count) into total_exited_request_updated,total_not_exited_request FROM exit_request_detailes WHERE exit_request_id = exit_request_id_in;
set total_sum_exited_not_exited = total_exited_request_updated + total_not_exited_request;
IF total_exit_request_count = total_exited_request_updated THEN
UPDATE exit_requests set status_id = 4 WHERE id = exit_request_id_in;
ELSEIF total_exit_request_count = total_sum_exited_not_exited THEN
UPDATE exit_requests set status_id = 3 WHERE id = exit_request_id_in;
end IF;

END

#########################################################################################################################################################################################################

CREATE PROCEDURE `Get_order_details_id_order_id_for_sorting`(
IN product_id_in int,IN basket_id_in int,
out order_detail_id_out int,out order_id_out int,OUT id_exit_request_detailes_out int,
out basket_id_in_sorting_out int, OUT sorting_location_out VARCHAR(100))
BEGIN
DECLARE exit_request_id_by_basket_id int;
DECLARE order_id_for_basket int;

SELECT exit_request_id INTO exit_request_id_by_basket_id from baskets WHERE id = basket_id_in;

SELECT od.order_id,od.id,tbl.id into order_id_for_basket, order_detail_id_out ,id_exit_request_detailes_out from order_details od 
INNER JOIN ( SELECT exd.id ,exd.exit_request_id FROM exit_request_detailes exd
WHERE exd.basket_id = basket_id_in  AND exd.product_id = product_id_in and exd.is_sorted = 0 limit 1
) as tbl on od.exit_request_id = tbl.exit_request_id 
WHERE od.count > od.sorted_count AND od.product_id = product_id_in
ORDER BY od.id limit 1;

set order_id_out = order_id_for_basket;
SELECT basket_sorting_id,location_sorting into basket_id_in_sorting_out,sorting_location_out from orders WHERE id = order_id_for_basket;

END
#########################################################################################################################################################################################################

CREATE PROCEDURE `Update_on_Orders_and_Orders_details`(
IN order_detail_id_IN int,IN order_id_IN int,IN id_exit_request_detailes_IN int,
IN basket_id_in_sorting_IN int, IN sorting_location_out VARCHAR(100)
)
BEGIN
DECLARE basket_id_in_sorting_order int;
DECLARE sorting_location_order VARCHAR(100);
DECLARE sorted_count_current int;
DECLARE total_sum_count int;
DECLARE total_sum_sorted_count int;
DECLARE exit_request_id_orders int;
DECLARE count_basket_is_not_sorted int;
DECLARE basket_id_from_pkup int;

SELECT basket_sorting_id,location_sorting into basket_id_in_sorting_order,sorting_location_order FROM orders WHERE id = order_id_IN;
IF ISNULL(basket_id_in_sorting_order)  and  ISNULL(sorting_location_order) THEN
UPDATE orders set basket_sorting_id = basket_id_in_sorting_IN, location_sorting = sorting_location_out WHERE id = order_id_IN;
END IF;

SELECT sorted_count INTO sorted_count_current FROM order_details WHERE id = order_detail_id_IN;
UPDATE order_details SET sorted_count = sorted_count_current + 1 WHERE id = order_detail_id_IN;

UPDATE exit_request_detailes set is_sorted = 1 WHERE id = id_exit_request_detailes_IN;

SELECT sum(count),SUM(sorted_count) into total_sum_count,total_sum_sorted_count FROM order_details WHERE order_id = order_id_IN;
IF total_sum_count = total_sum_sorted_count THEN
UPDATE orders SET status_id = 3 WHERE id = order_id_IN;
END IF;

SELECT basket_id into basket_id_from_pkup from exit_request_detailes WHERE id = id_exit_request_detailes_IN;
SELECT exit_request_id into exit_request_id_orders from order_details WHERE id = order_detail_id_IN;  
SELECT COUNT(*) into count_basket_is_not_sorted FROM exit_request_detailes WHERE exit_request_id = exit_request_id_orders and basket_id = basket_id_from_pkup and is_sorted = 0;
IF count_basket_is_not_sorted = 0 THEN
UPDATE baskets SET exit_request_id = 0 WHERE id = basket_id_from_pkup;
END if;
END
