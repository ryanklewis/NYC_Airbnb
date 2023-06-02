-- First I want to simply select all elements of the dataset in order to review the different components and get a sense for the data

select *
from nyc_airbnb_data

/* I want to add a new column to the table which deceiphers new listings from non-new listings.
   New listings are noted as listings that have no reviews at all. As there are no data fields
   which indicate the last booking or number of bookings, this is the best data field to use.
*/ 


Alter Table nyc_airbnb_data
Add new_listing VARCHAR(50)

Update nyc_airbnb_data
	Set new_listing = 'Yes'
	Where last_review IS NULL

Update nyc_airbnb_data
	Set new_listing = 'No'
	Where last_review IS NOT NULL

	
/* In addition to the new listings indication, I have also added a column which notes whether or not the host has a high
   number of listings or not. Those hosts with 10 or more listings are denoted as having a high number of listings.
*/ 


Alter Table nyc_airbnb_data
Add high_host_count VARCHAR(50)

Update nyc_airbnb_data
	Set high_host_count = 'Yes'
	Where calculated_host_listings_count >= 10

Update nyc_airbnb_data
	Set high_host_count = 'No'
	Where calculated_host_listings_count < 10



/* Here I am starting to aggregate out the data between new and non-new listings. I am looking to see if there are any nuances
or trends in the new listings which may be different from the non-new listings by neighborhoods and room types.
*/ 


select neighbourhood_group, neighbourhood, new_listing, count(name) as listing_count
from nyc_airbnb_data

group by neighbourhood_group, neighbourhood, new_listing
order by listing_count DESC

select room_type, new_listing, count(name) as listing_count
from nyc_airbnb_data

group by room_type, new_listing
order by listing_count DESC


/* I am able to put together a nice distribution of where most listings are in the NYC area as well as where the new listings 
are compared to the distribution of non-new listings
*/ 




/* Next, I am curious to see if there are hosts which have a vast stake in the market or if it seems to be a fairly competitive 
marketplace. We do this by taking a look at the host id's which have the highest count of listings. 
*/

select host_id, host_name, count(name) as listing_count
from nyc_airbnb_data

group by host_id, host_name
order by listing_count DESC


/* Next, I utilize the high_host_count column which was created earlier. I am curious how their distribution of listings stacks 
up against hosts with a low number of listings.
*/

select high_host_count, avg(price) as average_price, count(name) as listing_count
from nyc_airbnb_data

group by high_host_count

select high_host_count, neighbourhood_group, avg(price) as average_price, count(name) as listing_count
from nyc_airbnb_data

group by high_host_count, neighbourhood_group
order by neighbourhood_group ASC


select high_host_count, new_listing, count(name) as listing_count
from nyc_airbnb_data

group by high_host_count, new_listing
order by high_host_count ASC


/* Hosts that have a high number of listings have a significantly higher percentage of their total listings as new listings
than do hosts with a low number of listings. This could draw attention to the profitability of airbnb as those hosts with
many listings are adding new listings at a higher rate than those with a low number of listings. It would be interesting to
take a look at the revenue drawn from each of these non-new listings for a calendar year and see how the distribution compares 
between hosts with a high number of listings and those with a low number of listings. Another interesting data point to analyze
could have been which listings are full time airbnb listings and which are only part time listings.

*/




-- Creating views to store data for later use within visualization tools to depict data in an easily digestible format.

Create View NighborhoodListings as
select neighbourhood_group, neighbourhood, new_listing, count(name) as listing_count
from nyc_airbnb_data

group by neighbourhood_group, neighbourhood, new_listing
-- order by listing_count DESC


Create View RoomTypeListings as
select room_type, new_listing, count(name) as listing_count
from nyc_airbnb_data

group by room_type, new_listing
--order by listing_count DESC


Create View LargestHosts as
select host_id, host_name, count(name) as listing_count
from nyc_airbnb_data

group by host_id, host_name
--order by listing_count DESC


Create View HighvLowHost as
select high_host_count, avg(price) as average_price, count(name) as listing_count
from nyc_airbnb_data

group by high_host_count


Create View HighvLowHostNeighborhood as
select high_host_count, neighbourhood_group, avg(price) as average_price, count(name) as listing_count
from nyc_airbnb_data

group by high_host_count, neighbourhood_group
--order by neighbourhood_group ASC


Create View HighvLowHostNewListing as
select high_host_count, new_listing, count(name) as listing_count
from nyc_airbnb_data

group by high_host_count, new_listing
--order by high_host_count ASC

