#! /usr/bin/env raku

# Perl Weekly Challenge #236 Task 2
# © 2023 Shimon Bollinger. All rights reserved.
# Last modified: Sat 30 Sep 2023 08:58:53 PM EDT
# Version 0.0.1

# begin-no-weave
# always use the latest version of Raku
use v6.*;
# end-no-weave

=begin pod
=TITLE Challenge

=SUBTITLE Submitted By:

=head2 The Challenge

=head3 Example 1

=begin code :lang<bash>
=end code

=head3 Example 2

=begin code :lang<bash>
=end code

=head3 Example 3

=begin code :lang<bash>
=end code


=head2 The Solution


=head3 The Basic Algorithm

=end pod


multi MAIN (#|
            *@input

            #| Show debug prints when True
            Bool :v($verbose) = False # no-weave-this-line
        ) {
} # end of multi MAIN (*@input

=begin pod

=head2 Sample run with debug prints

(The option C<--verbose> and the debug print statements are not shown in the
above code.)

=begin code :lang<sh>

$ ./ch-X.raku --verbose
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

#| Use the option '--test' to run the program with the three examples.
multi MAIN (Bool :$test!) {
    use Test;

    my @tests = [
        %{ got => MAIN(),
           op => '==', expected => , desc => 'Example 1' },
        %{ got => MAIN(),
           op => '==', expected => , desc => 'Example 2' },
        %{ got => MAIN(),
           op => '==', expected => , desc => 'Example 3' },
    ];

    plan +@tests;
    for @tests {
        cmp-ok .<got>, .<op>, .<expected>, .<desc>;
    } # end of for @tests
} # end of multi MAIN (:$test!)
# end-no-weave

