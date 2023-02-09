/*Our goal is to find the year-on-year (y-o-y) growth rate for Wayfair's user spend.

Our multi-step approach for solving the question:

Summarizing user_transactions table into a table containing the yearly spend information.
Find the prior year's spend and keep the information parallel with current year's spend row.
Get the variance between current year and prior year's spend and apply the y-o-y growth rate formula.

Step 1

First, we need to obtain the year by using EXTRACT on the transaction date as written in the code below.*/

SELECT 
  EXTRACT(YEAR FROM transaction_date) AS year, 
  product_id,
  spend AS curr_year_spend 
FROM user_transactions

/* Step 2

Next, we convert the query in step 1 into a CTE called yearly_spend (you can name the CTE as you wish). With 
this CTE, we then calculate the prior year’s spend for each product. We can do so by applying LAG 
function onto each year and partitioning by product id to calculate the prior year's spend for the given product.
*/

WITH yearly_spend 
AS (
-- Insert query above
)

SELECT 
  *, 
  LAG(curr_year_spend, 1) OVER (
    PARTITION BY product_id 
    ORDER BY product_id, year) AS prev_year_spend 
FROM yearly_spend;


/*Step 3

Finally, we wrap the query above in another CTE called yearly_variance.

Year-on-Year Growth Rate = (Current Year's Spend - Prior Year’s Spend) / Prior Year’s Spend x 100

In the final query, we apply the y-o-y growth rate formula and round the results to 2 nearest decimal places.
*/


WITH yearly_spend 
AS (
-- Insert above query
), 
yearly_variance 
AS (
-- Insert above query
) 

SELECT 
  year,
  product_id, 
  curr_year_spend, 
  prev_year_spend, 
  ROUND(100 * (curr_year_spend - prev_year_spend)/ prev_year_spend, 2) AS yoy_rate 
FROM yearly_variance;

/Solution
WITH yearly_spend AS (
  SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year, 
    product_id,
    spend AS curr_year_spend
  FROM user_transactions
), 
yearly_variance AS (
  SELECT 
    *, 
    LAG(curr_year_spend, 1) OVER (
      PARTITION BY product_id
      ORDER BY product_id, year) AS prev_year_spend 
  FROM yearly_spend) 

SELECT 
  year,
  product_id, 
  curr_year_spend, 
  prev_year_spend, 
  ROUND(100 * (curr_year_spend - prev_year_spend)/ prev_year_spend,2) AS yoy_rate 
FROM yearly_variance;
