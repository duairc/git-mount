git mount
=========

This is a really simple script that connects Ruby's [Grit](http://github.com/mojombo/grit) and [FuseFS](http://fusefs.sourceforge.net/) libraries together. You can do `git mount /tmp/blah` in your git repository, and then in `/tmp/blah` you will have a (read-only) filesystem where view the different branches and tags of your repository simultaneously.

It is horrendously slow for even moderately sizes repositories though... I suspect the bottleneck is Grit, but on a moral level the idea of `ls` having to interpret Ruby code offends me. I fully intend to rewrite this in C, but in case that never happens, here's what I have so far.

By the way, you can unmount the filesystem with `fusermount -u /tmp/blah`.
