# Challenge #236 Task 1
>Submitted By: Mohammad S Anwar


## Table of Contents
[The Challenge](#the-challenge)  
[Example 1](#example-1)  
[Example 2](#example-2)  
[Example 3](#example-3)  
[The Solution](#the-solution)  
[The Basic Algorithm](#the-basic-algorithm)  
[Initialize the variables](#initialize-the-variables)  
[Process the bills](#process-the-bills)  
[Print and return whether the bills can be used to make change.](#print-and-return-whether-the-bills-can-be-used-to-make-change)  
[Sample run with debug prints](#sample-run-with-debug-prints)  
[AUTHOR](#author)  
[RAKU SOURCE CODE](#raku-source-code)  
[LICENCE AND COPYRIGHT](#licence-and-copyright)  

----
## The Challenge
You are asked to sell juice each costs $5. You are given an array of bills. You can only sell ONE juice to each customer but make sure you return exact change back. You only have $5, $10 and $20 notes. You do not have any change in hand at first.

Write a script to find out if it is possible to sell to each customers with correct change.

### Example 1
```
Input: @bills = (5, 5, 5, 10, 20)
Output: true

From the first 3 customers, we collect three $5 bills in order.
From the fourth customer, we collect a $10 bill and give back a $5.
From the fifth customer, we give a $10 bill and a $5 bill.
Since all customers got correct change, we output true.

```
### Example 2
```
Input: @bills = (5, 5, 10, 10, 20)
Output: false

From the first two customers in order, we collect two $5 bills.
For the next two customers in order, we collect a $10 bill and give back a $5 bill.
For the last customer, we can not give the change of $15 back because we only have two $10 bills.
Since not every customer received the correct change, the answer is false.

```
### Example 3
```
Input: @bills = (5, 5, 5, 20)
Output: true


```
## The Solution
### The Basic Algorithm
We'll us a hash to keep track of the number of each bill in the till. We'll start with no bills in the till, and then for each bill received, we'll increment the count of that bill in the till.

If the bill is a $10, we'll decrement the count of $5 bills in the till.

If the bill is a $20, we'll also decrement the count of $5 bills in the till, and if there are no $10 bills in the till, we'll decrement the count of $5 bills in the till by another 2.

If the count of $5 bills in the till ever goes negative, then we can't make change, and we return 'false'.





```
    1| multi sub MAIN (
    2|     *@input where all(@input) ~~ 5|10|20,
    3|     --> Str 
    4|     ) {

```




### Initialize the variables




```
    5|     my Int %bills = (5 => 0, 10 => 0, 20 => 0);
    6|     my Str $retval = 'true';

```




### Process the bills




```
    7|     for @input -> $bill {
    8|         %bills{$bill}++;
    9| 
   10|         given $bill {
   11|             when 10 { %bills{5}-- }
   12|             when 20 {
   13|                 %bills{5}--;
   14|                 %bills{10} > 0
   15|                     ?? (%bills{10} -= 1)
   16|                     !! (%bills{5}  -= 2);
   17|             } 
   18|         } 
   19| 
   20|         if %bills{5} < 0 {
   21|             $retval = 'false';
   22|             last;
   23|         } 
   24|     } 

```




### Print and return whether the bills can be used to make change.




```
   25|     say $retval;
   26|     return $retval;;
   27| } 

```




# Sample run with debug prints
(The option `--verbose` and the debug print statements are not shown in the above code.)

```
$ ./ch-1.raku -verbose 5 5 10 20
Received $5, have 1 $5s, 0 $10s, and 0 $20s in the till
Received $5, have 2 $5s, 0 $10s, and 0 $20s in the till
Received $10, have 1 $5s, 1 $10s, and 0 $20s in the till
Received $20, have 0 $5s, 0 $10s, and 1 $20s in the till
true

./ch-1.raku -verbose 5 5 10 10 20
Received $5, have 1 $5s, 0 $10s, and 0 $20s in the till
Received $5, have 2 $5s, 0 $10s, and 0 $20s in the till
Received $10, have 1 $5s, 1 $10s, and 0 $20s in the till
Received $10, have 0 $5s, 2 $10s, and 0 $20s in the till
Received $20, have -1 $5s, 1 $10s, and 1 $20s in the till
false

```
# AUTHOR
Shimon Bollinger ([deoac.shimon@gmail.com](mailto:deoac.shimon@gmail.com.md))

Comments and Pull Requests are welcome.

# RAKU SOURCE CODE
The complete source code for this solution can be found at [Challenge 236, Task 1](https://gist.github.com/deoac/)

# LICENCE AND COPYRIGHT
© 2023 Shimon Bollinger. All rights reserved.

This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself. See [perlartistic](http://perldoc.perl.org/perlartistic.html).

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.







----
Rendered from  at 2023-10-01T03:26:45Z
sh