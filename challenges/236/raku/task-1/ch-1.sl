#! /usr/bin/env raku

# Perl Weekly Challenge #236 Task 1
# © 2023 Shimon Bollinger. All rights reserved.
# Last modified: Sat 30 Sep 2023 11:41:30 PM EDT
# Version 0.0.1

# begin-no-weave
# always use the latest version of Raku
use v6.*;
# end-no-weave

=begin pod
=TITLE Challenge #236 Task 1

=SUBTITLE Submitted By: Mohammad S Anwar

=head2 The Challenge

You are asked to sell juice each costs $5. You are given an array of bills. You
can only sell ONE juice to each customer but make sure you return exact change
back. You only have $5, $10 and $20 notes. You do not have any change in hand
at first.

Write a script to find out if it is possible to sell to each customers with
correct change.

=head3 Example 1

=begin code :lang<bash>

Input: @bills = (5, 5, 5, 10, 20)
Output: true

From the first 3 customers, we collect three $5 bills in order.
From the fourth customer, we collect a $10 bill and give back a $5.
From the fifth customer, we give a $10 bill and a $5 bill.
Since all customers got correct change, we output true.
=end code

=head3 Example 2

=begin code :lang<bash>

Input: @bills = (5, 5, 10, 10, 20)
Output: false

From the first two customers in order, we collect two $5 bills.
For the next two customers in order, we collect a $10 bill and give back a $5 bill.
For the last customer, we can not give the change of $15 back because we only have two $10 bills.
Since not every customer received the correct change, the answer is false.
=end code

=head3 Example 3

=begin code :lang<bash>
Input: @bills = (5, 5, 5, 20)
Output: true
=end code


=head2 The Solution

=head3 The Basic Algorithm

We'll us a hash to keep track of the number of each bill in the till.  We'll
start with no bills in the till, and then for each bill received, we'll
increment the count of that bill in the till.

If the bill is a $10, we'll decrement the count of $5 bills in the till.

If the bill is a $20, we'll also decrement the count of $5 bills in the till,
and if there are no $10 bills in the till, we'll decrement the count of $5
bills in the till by another 2.

If the count of $5 bills in the till ever goes negative, then we can't make
change, and we return 'false'.

=end pod

multi sub MAIN (
    #| The bills to be used to make change (5, 10, 20)
    *@input where all(@input) ~~ 5|10|20,
    #| Show debug prints when True
    Bool :v($verbose) = False # no-weave-this-line
    --> Str #Return 'true' if the bills can be used to make change
    ) {

=begin pod
=head3 Initialize the variables
=end pod

    my Int %bills = (5 => 0, 10 => 0, 20 => 0);
    my Str $retval = 'true';

=begin pod
=head3 Process the bills
=end pod

    for @input -> $bill {
        %bills{$bill}++;

        given $bill {
            when 10 { %bills{5}-- }
            when 20 {
                %bills{5}--;
                %bills{10} > 0
                    ?? (%bills{10} -= 1)
                    !! (%bills{5}  -= 2);
            } # end of when 20
        } # end of given $bills

        # begin-no-weave
        note "Received \$$bill, " ~
             "have %bills{5} \$5s, %bills{10} \$10s, and %bills{20} \$20s " ~
             "in the till" if $verbose; #
        # end-no-weave
        if %bills{5} < 0 {
            $retval = 'false';
            last;
        } # end of if %bills{5} < 0
    } # end of for @numbers -> $bill


=begin pod

=head3 Print and return whether the bills can be used to make change.

=end pod
    say $retval;
    return $retval;;
} # end of multi MAIN (*@input where * == 5|10|20,

=begin pod

=head1 Sample run with debug prints

(The option C<--verbose> and the debug print statements are not shown in the
above code.)

=begin code :lang<sh>

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
=end code

=head1 AUTHOR

Shimon Bollinger (L<deoac.shimon@gmail.com|mailto:deoac.shimon@gmail.com>)

Comments and Pull Requests are welcome.

=head1 RAKU SOURCE CODE

The complete source code for this solution can be found at
L<Challenge 236, Task 1|https://gist.github.com/deoac/8293603bda2684b1231638ad1853f308>


=head1 LICENCE AND COPYRIGHT

© 2023 Shimon Bollinger. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
See L<perlartistic|http://perldoc.perl.org/perlartistic.html>.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=end pod

# begin-no-weave
# multi MAINs to catch invalid input
multi sub MAIN (*@numbers where all(@numbers) ~~ Int,
                Bool :v(:$verbose)) is hidden-from-USAGE {
    note "The bills can only be 5, 10, or 20 dollars.";
    exit 1;
}

multi sub MAIN(*@args,
               Bool :v(:$verbose)) is hidden-from-USAGE {
    note "Please provide a list of bills.";
    exit 1;
}

#| Use the option '--test' to run the program with the three examples.
multi MAIN (Bool :$test!) {
    use Test;

    my @tests = [
        %{ got => MAIN(5, 5, 5, 10, 20),
           op => 'eq', expected => 'true', desc => 'Example 1' },
        %{ got => MAIN(5, 5, 10, 10, 20),
           op => 'eq', expected => 'false', desc => 'Example 2' },
        %{ got => MAIN(5, 5, 5, 20),
           op => 'eq', expected => 'true', desc => 'Example 3' },
    ];

    plan +@tests;
    for @tests {
        cmp-ok .<got>, .<op>, .<expected>, .<desc>;
    } # end of for @tests
} # end of multi MAIN (:$test!)
# end-no-weave

