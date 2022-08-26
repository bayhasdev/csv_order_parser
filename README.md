# csv_order_parser

Exercise 2: Problem solving case 
building using flutter web. 

Exercise Description :
There is a csv file that keeps a record of n order details for orders made at an online shopping website. The file has a .csv extension.
Each line contains a single record with the following columns, in order:
• Id of the order placed
• Area where the order was delivered
• Name of the product
• Quantity of the product delivered in that order
• Brand of the ordered product
 Create
is the name of the input file given in the input including the .csv extension. Each file must contain r rows where r is the number of distinct products. Data should be comma delimited, and the row order does not matter.
The structure of each file is as follows:
1. 0_input_file_name - In the first column, list the product Name. The second column should contain the average quantity of the product purchased per order.
2. 1_input_file_name - In the first column, list the product Name. The second column should be the most popular Brand for that product. Most popular is defined as the brand with the most total orders for the item, not the quantity purchased. If two or more brands have the same popularity for a product, include any one.
The value of the average quantity will be considered correct if the absolute difference between your answer and the jury's answer is less than 1e-3 (0.001)


- [online demo](https://bayhasdev.github.io/csv_order_parser.github.io/#/)
 
