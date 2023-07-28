# my-lemon-bar

My own configuration (minus some things I deliberately omitted) of lemonbar.
Some of the code within `lemonbar_scripts` (`cpu_usage.pl`, `mpd.sh`, and
`memory.awk`) was copied from i3blocks scripts I found online, credits to the
respective authors for these scripts.

## INSTALLATION

Just copy/clone these scripts somewhere on your filesystem and run

    env LEMONBARDIR=<your directory> lemonbar.sh

Be sure to read through the source code to customize the bar according to your
likings (also, as said before, I omitted things)

## A quick explation of all this works

Basically there are three functions piped one into each other:
* `lemonbar_out`
* `the_lemonbar`
* `lemonbar_in`

`lemonbar_out`'s concern is to organize the input that `the_lemonbar` has to
show.  This is achieved by running all the scripts in `lemonbar_scripts` folder
and to wait until one of them has wrote something into its data file. When
something changes everything is read and outputted in `the_lemonbar`.

`the_lemonbar`'s concern is to graphically render the bar in your window
manager/desktop environment. Its output (which is triggered by clicking areas
defined in lemonbar, refer to [its manual](https://manpages.debian.org/testing/lemonbar/lemonbar.1.en.html)
for further information) will be passed to `lemonbar_in`.

`lemonbar_in`'s concern is to trigger actions accordingly to what has been
clicked. For example, when left clicking the `mpd` area the play/pause of the
current song (if any) will be toggled.
