#! /usr/bin/env raku

# Perl Weekly Challenge #236 Task 2
# © 2023 Shimon Bollinger. All rights reserved.
# Last modified: Sat 30 Sep 2023 08:29:21 PM EDT
# Version 0.0.1

# begin-no-weave
# always use the latest version of Raku
use v6.*;
# end-no-weave

=begin pod
=TITLE Challenge 236 Task 2: Array Loops

=SUBTITLE Submitted By: Mark Anderson

=head2 The Challenge

You are given an array of unique integers.

Write a script to determine how many loops are in the given array.

=defn
To determine a loop: Start at an index and take the number at array[index] and then proceed to that index and continue this until you end up at the starting index.

=head3 Example 1

=begin code :lang<bash>
Input: @ints = (4,6,3,8,15,0,13,18,7,16,14,19,17,5,11,1,12,2,9,10)
Output: 3

To determine the 1st loop, start at index 0, the number at that index is 4,
proceed to index 4, the number at that index is 15, proceed to index 15 and so
on until you're back at index 0.

Loops are as below:
[4 15 1 6 13 5 0]
[3 8 7 18 9 16 12 17 2]
[14 11 19 10]

=end code

=head3 Example 2

=begin code :lang<bash>
Input: @ints = (0,1,13,7,6,8,10,11,2,14,16,4,12,9,17,5,3,18,15,19)
Output: 6

Loops are as below:
[0]
[1]
[13 9 14 17 18 15 5 8 2]
[7 11 4 6 10 16 3]
[12]
[19]
=end code

=head3 Example 3

=begin code :lang<bash>
Input: @ints = (9,8,3,11,5,7,13,19,12,4,14,10,18,2,16,1,0,15,6,17)
Output: 1

Loop is as below:
[9 4 5 7 19 17 15 1 8 12 18 6 13 2 3 11 10 14 16 0]
=end code


=head2 The Solution


=end pod

=begin pod

=head3 The Basic Algorithm

We will create a pointer to the first index of the array and attempt to find
a loop that starts with that element.

It's important to remember that each element can be a part of only U<one> loop,
even if it is a loop by itself.

Every time we find an element, we will push it to a current-loop array and set
the element to C<Nil> so that we don't use  it again.

If we find a loopN<A 'loop' is defined as a list of array element values, not
a list of the array's indices.>, we will push it to an array of loops. Note
that a loop can consist of a single element.  After we find a loop, we will
move the start pointer to the next defined element and try again.

First we will only accept input that is a list of unique integers.

=end pod


multi MAIN (#| A list of unique integers
            *@input where .all ~~ Int &&
                          .unique.elems == .elems,
            #| Show debug prints when True
            Bool :v($verbose) = False # no-weave-this-line
        ) {

=begin pod
=head3 Initialize variables
=end pod

    my Int @ints          = @input>>.Int;
    my Int $num-elems     = @ints.elems;
    my Int $start-pointer = 0;
    my Int $cur-index     = $start-pointer;

=begin pod

The current loop we are working on is stored in C<@cur-loop>. The list of all
found loops is stored in C<@all-loops>.

=end pod

    my @cur-loop  = [];
    my @all-loops = [];

=begin pod
=head3 The Main Loop

As long as there is a defined element in the array, C<$start-pointer>,
we will try to find a loop that starts with that element.

=end pod

    INDEX:
    while $start-pointer.defined {
=begin pod

We get the value of the current element and use it as the index of the
next element in the loop.

=end pod

        my $cur-value  = @ints[$cur-index];
        my $next-index = $cur-value;

=begin pod

Each value we are looking at gets pushed to the current loop array and
set to C<Nil> so that we don't use it again.

=end pod

        @cur-loop.push: $cur-value;
        @ints[$cur-index] = Nil;
        #begin-no-weave
        if $verbose {
            dd @ints;
            dd $start-pointer;
            dd $cur-index;
            dd $next-index;
            dd $cur-value;
            dd @cur-loop;
        } # end of if $verbose
        #end-no-weave

=begin pod
At this point there are three possibilities:

=end pod

        given $next-index {
=begin pod

=item We have reached an index that is greater than the number of elements in
the original array.

Thus, we have found a loop that is not closed. Each element we've
found so far is a loop by itself. So we push each element to the list of
all loops.

=end pod

            when * ≥ $num-elems {
                #begin-no-weave
                say "\e[31mFound single-item loop[s]:\e[0m ",
                    @cur-loop.map({"[$_]"}).join(' ') if $verbose;
                #end-no-weave
                @all-loops.push: $_ for @cur-loop;
            } # end of when * ≥ $num-elems
=begin pod

=item We have found a closed loop

When the next index is the same as the start pointer, we have found
a closed loop. We push the current loop to the list of all loops.

=end pod

            when $start-pointer {
                # begin-no-weave
                say "\e[32mFound a loop:\e[0m ",
                    @cur-loop.join(" ") if $verbose;
                # end-no-weave
                @all-loops.push: @cur-loop.clone;
            } # end of when $start-pointer

=begin pod
=item We have found a value that is not in the current loop.

So we continue looking for the next element in the loop by updating the current
index.

=end pod

            default {
                #begin-no-weave
                say "\e[33mContinuing loop:\e[0m ",
                    @cur-loop.join(" ") if $verbose;
                #end-no-weave
                $cur-index = $cur-value;
                next INDEX;
            } # end of default

        } # end of given $next-index
=begin pod

At this point we have found a loop or single-item loop[s]. We need to find the
next start pointer by looking for the next defined element in the array.

=end pod

        @cur-loop = [];
        $start-pointer = $cur-index = @ints.first(*.defined, :k);

        # begin-no-weave
        say "\e[34m\nStarting new loop at index $start-pointer\e[0m"
            if $start-pointer.defined && $verbose;
        # end-no-weave
    } # end of while $start-pointer.defined

    #begin-no-weave
    say "\n\n\e[35mAll loops:\n" ~ @all-loops.join("\n") ~ "\e[0m\n"
        if $verbose;
    #end-no-weave
=begin pod

=head3 Print and return the number of loops found.

=end pod

    print "Number of loops: " if $verbose; # no-weave-this-line
    say @all-loops.elems;

    return @all-loops.elems;
} # end of multi MAIN ( )

=begin pod

=head2 Sample run with debug prints

(The option C<--verbose> and the debug print statements are not shown in the
above code.)

=begin code :lang<sh>

$ ./ch-2.raku --verbose 1 0 8 5 4 3 9

Array[Int] @ints = Array[Int].new(Int, 0, 8, 5, 4, 3, 9)
Int $start-pointer = 0
Int $cur-index = 0
Int $next-index = 1
Int $cur-value = 1
Array @cur-loop = [1]
Continuing loop: 1
Array[Int] @ints = Array[Int].new(Int, Int, 8, 5, 4, 3, 9)
Int $start-pointer = 0
Int $cur-index = 1
Int $next-index = 0
Int $cur-value = 0
Array @cur-loop = [1, 0]
Found a loop: 1 0

Starting new loop at index 2
Array[Int] @ints = Array[Int].new(Int, Int, Int, 5, 4, 3, 9)
Int $start-pointer = 2
Int $cur-index = 2
Int $next-index = 8
Int $cur-value = 8
Array @cur-loop = [8]
Found single-item loop[s]: [8]

Starting new loop at index 3
Array[Int] @ints = Array[Int].new(Int, Int, Int, Int, 4, 3, 9)
Int $start-pointer = 3
Int $cur-index = 3
Int $next-index = 5
Int $cur-value = 5
Array @cur-loop = [5]
Continuing loop: 5
Array[Int] @ints = Array[Int].new(Int, Int, Int, Int, 4, Int, 9)
Int $start-pointer = 3
Int $cur-index = 5
Int $next-index = 3
Int $cur-value = 3
Array @cur-loop = [5, 3]
Found a loop: 5 3

Starting new loop at index 4
Array[Int] @ints = Array[Int].new(Int, Int, Int, Int, Int, Int, 9)
Int $start-pointer = 4
Int $cur-index = 4
Int $next-index = 4
Int $cur-value = 4
Array @cur-loop = [4]
Found a loop: 4

Starting new loop at index 6
Array[Int] @ints = Array[Int].new(Int, Int, Int, Int, Int, Int, Int)
Int $start-pointer = 6
Int $cur-index = 6
Int $next-index = 9
Int $cur-value = 9
Array @cur-loop = [9]
Found single-item loop[s]: [9]


All loops:
1 0
8
5 3
4
9

Number of loops: 5
=end code

=end pod


=begin pod

=head1 AUTHOR

Shimon Bollinger (L<deoac.shimon@gmail.com|mailto:deoac.shimon@gmail.com>)

Comments and Pull Requests are welcome.

=head1 RAKU SOURCE CODE

The complete source code for this solution can be found at
L<Challenge 236, Task 2|https://gist.github.com/deoac/9d9da96cbaaaf026b4774c98db5f7c3b>


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
# The weird matching syntax is because !~~ does not play well with Junctions.
multi MAIN (Bool :$v = False,
            *@input where !(.all ~~ IntStr)) is hidden-from-USAGE {
    note "Input must be a list of *integers*";
    exit 1;
} # end of multi MAIN (*@input where .all !~~ Int)

multi MAIN (*@input where .unique.elems != .elems,
            Bool :v(:$verbose) = False) is hidden-from-USAGE {
    note "Input must be a list of *unique* integers";
    exit 1;
} # end of multi MAIN (*@input where .unique.elems != .elems)

multi MAIN (Bool :v(:$verbose) = False) is hidden-from-USAGE {
    note "Input cannot be empty";
    exit 1;
} # end of multi MAIN ()

#| Handle the case of a single integer array
multi MAIN (Int $i!, Bool :v(:$verbose) = False) is hidden-from-USAGE {
    note "\e[31mFound a single-item loop:\e[0m [$i]" if $verbose;
    say 1;
} # end of multi MAIN (Int $i!

#| Use the option '--test' to run the program with the three examples.
multi MAIN (Bool :$test!) {
    use Test;

    #TODO Handle edge cases.
    #TODO Test 1 integer array
    my @tests = [
        %{ got => MAIN(4,6,3,8,15,0,13,18,7,16,14,19,17,5,11,1,12,2,9,10),
           op => '==', expected => 3, desc => 'Example 1' },
        %{ got => MAIN(0,1,13,7,6,8,10,11,2,14,16,4,12,9,17,5,3,18,15,19),
           op => '==', expected => 6, desc => 'Example 2' },
        %{ got => MAIN(9,8,3,11,5,7,13,19,12,4,14,10,18,2,16,1,0,15,6,17),
           op => '==', expected => 1, desc => 'Example 3' },
    ];

    plan +@tests;
    for @tests {
        cmp-ok .<got>, .<op>, .<expected>, .<desc>;
    } # end of for @tests
} # end of multi MAIN (:$test!)
# end-no-weave

