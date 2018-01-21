--use of an intersect, to find the staff addresses
SELECT staff.address_id 
FROM staff INTERSECT 
SELECT address.address_id 
FROM address;

--find staff addresses and order alphabetically on surname
SELECT staff.first_name,staff.last_name,address.address,address.address2,address.district 
FROM staff
INNER JOIN address ON staff.address_id = address.address_id
ORDER BY staff.last_name DESC;

--for academic purpose only, this returns all addresses, regardless of if there is a staff
--member associated or not, so there are blank columns in the results
SELECT staff.first_name,staff.last_name,address.address 
FROM staff
RIGHT JOIN address ON staff.address_id = address.address_id
ORDER BY staff.last_name DESC;