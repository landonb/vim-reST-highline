################################################################
``vim-reST-highline`` |em_dash| reST horizontal rule highlighter
################################################################

.. |em_dash| unicode:: 0x2014 .. em dash

About This Plugin
=================

This plugin highlights lines of repeated characters
(that aren't otherwise a reST section header), so
that you can add colorful delimiters to your reST
documents.

*Supercharge your notetaking and recordkeeping!*

Install this plugin and make your reStructuredText markup more lively.

Why You Might Want to Use This Plugin
=====================================

(Of all the author's reStructuredText plugins, this is the last
one you might want. Not to undersell it, but first check out
`Tips: Related supercharged reST plugins`_, below, if you have
not already demoed or installed my other reST plugins.)

This plugin works quite simply: if you repeat the same character
eight or more times on a line, and there are no other characters
besides whitespace, that line is specially highlighted.

The author used to use this feature, e.g., to draw a line of
pipes, and they'd be highlighted in green::

  Blah blah blah some text.

  |||||||||||||||||

  Blah blah blah some more text.

Or to draw a line of dollar signs, and they'd be highlighted
with a cyan background, e.g.,::

  Blah blah blah some text.

  $$$$$$$$$$$$$$$$$

  Blah blah blah some more text.

But recently, the author has just been using a row of seven dashes
as a delimiter, which the built-in ``runtime/syntax/rst.vim`` rules
highlight in purple.

- You can easily insert such a line of dashes using the ``<Ctrl-->``
  (Ctrl-minus) shortcut, if you install `vim-ovm-seven-of-spines
  <https://github.com/landonb/vim-ovm-seven-of-spines>`__.

Nonetheless, this plugin still exists, because it's how I used to
roll, until I realized that a short horizontal rule of seven dashes
was enough to delineate one sub-section of my notes from another,
without creating a new section header.

E.g., I might have a section for some bug that I want to fix, and
then I'll use the seven-dash approach to separate my different
thoughts on the subject, such as::

  #########################################################
  FIXME/2022-09-24: Move reST HR highlights to a new plugin
  #########################################################

  FIXME/2022-09-24 22:11: Split the vim-reSTfold plugin to
  spin-off the HR highlights.

  -------

  SPIKE/2022-09-24 22:12: Verify that syntax load order does
  not interfere with the `rstSections` rule from vim-reSTfold.

  -------

  ################################################
  FIXME/2022-09-24: Some other issue I want to fix
  ################################################

  Blah blah blah.

  -------

Tips: Related supercharged reST plugins
=======================================

Consider these complementary reST highlights plugins that pair
well with this plugin to help you take notes in Vim:

- Advanced reST document section folder.

  `https://github.com/landonb/vim-reSTfold#🙏
  <https://github.com/landonb/vim-reSTfold#🙏>`__

  Supercharge your notetaking and recordkeeping!

  Add section folding to your reST notes so you can,
  e.g., collapse a 10,000-line-long TODO file and get a
  nice high-level view of all the things you wanna do.

- Additional syntax highlight rules.

  `https://github.com/landonb/vim-reST-highdefs#🎨
  <https://github.com/landonb/vim-reST-highdefs#🎨>`__

  Colorize email addresses and host names, and disable spell checking
  on emails, hosts, and acronyms (all-capital words).

- Special so-called *FIVER* syntax rules.

  `https://github.com/landonb/vim-reST-highfive#🖐
  <https://github.com/landonb/vim-reST-highfive#🖐>`__

  Highlight action words.

  E.g., "FIXME" is emphasized (in bright, bold yellow), and so is
  "FIXED" (crossed-out and purple), and so are "MAYBE", "LEARN",
  "ORDER", and "CHORE", and a few other choice five-letter words.

  Why five letters? So that you can use action words in section
  headers, and then the heading titles align nicely when folded.
  (Really, it's only important that each action word is the same
  width, and not necessarily that it's five long — but *FIXME* is
  the ultimate developer action word, so might as well be five.)

Installation
============

Installation is easy using the packages feature (see ``:help packages``).

To install the package so that it will automatically load on Vim startup,
use a ``start`` directory, e.g.,

.. code-block:: bash

    mkdir -p ~/.vim/pack/landonb/start
    cd ~/.vim/pack/landonb/start

If you want to test the package first, make it optional instead
(see ``:help pack-add``):

.. code-block:: bash

    mkdir -p ~/.vim/pack/landonb/opt
    cd ~/.vim/pack/landonb/opt

Clone the project to the desired path:

.. code-block:: bash

    git clone https://github.com/landonb/vim-reST-highline.git

If you installed to the optional path, tell Vim to load the package:

.. code-block:: vim

   :packadd! vim-reST-highline

Just once, tell Vim to build the online help:

.. code-block:: vim

   :Helptags

Then whenever you want to reference the help from Vim, run:

.. code-block:: vim

   :help vim-reST-highline

License
=======

Copyright (c) Landon Bouma. This work is distributed
wholly under CC0 and dedicated to the Public Domain.

https://creativecommons.org/publicdomain/zero/1.0/

