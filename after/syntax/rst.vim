" Powerful (Cleverful!) reST section folder
" Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
" Project: https://github.com/landonb/vim-reST-highline#➖
" License: GPLv3
"  vim:tw=0:ts=2:sw=2:et:norl:

" +----------------------------------------------------------------------+

" REFER: See complementary reST highlights plugins from this author
"        (pairs well with this plugin to help you take notes in Vim):
"
"   https://github.com/landonb/vim-reSTfold#🙏
"   https://github.com/landonb/vim-reST-highdefs#🎨
"   https://github.com/landonb/vim-reST-highfive#🖐
"   https://github.com/landonb/vim-reST-highline#➖

" REFER: See the reST syntax file included with Vim.
" - E.g.:
"     /usr/share/vim/vim81/syntax/rst.vim
"   Or maybe:
"     ${HOME}/.local/share/vim/vim81/syntax/rst.vim
" See also the most current upstream source of the same:
"   https://github.com/marshallward/vim-restructuredtext

" +----------------------------------------------------------------------+

" SAVVY/2022-09-24: Note that Vim *normally* adds new `syn match` rules
" to the end of the syntax rules list (what you see when you run either
" `:syn`, or `:TabMessage syn`), but not always!
"
" - When determining highlighting, per `:help syn`, Vim uses the last-
"   matching syntax rule to decide how to highlight a given match.
"
"   - Or it uses the item that starts in an earlier position! (See below)
"
" - Normally, your script load order (see `:scriptnames`) determines
"   the order you see syntax rules listed (what `:syn` shows).
"
"   - But not always!
"
" - I didn't find this documented, but I found that, in practice,
"   if you clear an existing syntax rule (`:syn clear X`) and then
"   redefine it (`:syn match X ...`):
"
"   - The newly *redefined* rule keeps the same order as the previous rule!
"
" - My concern (and why I learned this unwritten rule) was that, after
"   splitting this plugin from vim-reSTfold#🙏, I thought there might
"   be a load-order race condition issue between the two plugins.
"
"   - Specifically, I was concerned that the syntax matches herein would
"     override the other plugin's `syn match rstSections` rule (which
"     highlights true reST section headers) if this plugin loaded *after*
"     the other plugin (in which case, this plugin's `syn match` rules
"     would win because they would come after the `rstSections` rule).
"
"     - Well, unless the other rule matches at an earlier position. (See below)
"
"   - I'm not referring to rstFakeHRAll (defined below), which requires a
"     blank line above and below the FakeHR to be highlighted (which would
"     not be a true reST section header, so it wouldn't match rstSections).
"
"     - But I am talking about the other matches, e.g., rstFakeHRStars only
"       checks that the line below is blank.
"
"     - Indeed, if you `syn clear rstSections`, you'll see that some of the
"       rules below will highlight what was matched by rstSections. E.g.,
"       a word line followed by a line of asterisks is normally matched
"       by rstSections, but if you `:syn clear rstSections`, then
"       rstFakeHRStars steps in to highlight it.
"
" - Nonetheless, load order does not matter for the two plugins in question.
"
"   - To test, I renamed rstSections in the other plugin to rstSectionsTWO
"     (so that it wouldn't just re-assume the same load order as the
"     built-in rstSections rule, as I explained above). And then I tested
"     loading rstFakeHRStars before and after rstSectionsTWO (and I also
"     confirmed via `:syn` that the load order changed between tests).
"     But it made no difference!
"
"   - What I think is happening is that rstSections (or rstSectionsTWO,
"     from my test) always matches from an earlier position than the
"     rules below, so rstSections always wins, regardless of its order
"     in the syntax list.
"
"   - Per `:help syn`:
"
"       PRIORITY						*:syn-priority*
"
"       When several syntax items may match, these rules are used:
"
"       1. When multiple Match or Region items start in the same position, the item
"          defined last has priority.
"       2. A Keyword has priority over Match and Region items.
"       3. An item that starts in an earlier position has priority over items that
"          start in later positions.
"
"     So my guess is that Priority rule #3 applies.
"
"     Which means, 73 lines of comment later, we don't have to worry about
"     load order between this plugin's syntax rules (vim-reST-highline) and
"     the other plugin's syntax rules (vim-reSTfold), regardless of their
"     overlapping patterns, because vim-reSTfold will always win, due to
"     matching from an earlier position in the text. Which is what we want,
"     for the rules in this plugin to be subordinate to vim-reSTfold.

" +----------------------------------------------------------------------+

" *** Custom reST rules/reST extension: Pseudo-Horizontal Rule Highlights

function! s:reST_highline_Apply_Highlights()
  " 2018-01-30: SO 🆒!
  "
  "   This is pretty cool. And it only serves one purpose:
  "     Making me color-happy when reSTing.
  "   That is, if I repeat the same character 8 or more times
  "     on its own line, it'll be highlighted!
  "   You can fiddle with the highlights for specific characters
  "     below.
  "   In this way, you can create more visually appealing reST
  "     documents (albeit only when shown in Vim; they'll otherwise
  "     render to HTML without this special highlighting), and you
  "     can more easily highlight document delimiters, such as a
  "     using a row of dashes (but ensuring the preceding line is
  "     blank, otherwise the preceding line and the dashes would be
  "     interpreted as a normal reST section header).

  " - The HR match interferes with rstSections (see vim-reSTfold#🙏),
  "   whether it's defined before or after, and I'm not sure what's up,
  "   so only highlight when HR is followed by newlines, to avoid conflict.
  "   - (And note that `\n\n` sorta works, but the highlight only works if
  "      there are two trailing blank lines; whereas using just `\n` works,
  "      but then the top line of a real section header gets hijack-highlighted
  "      (the top line of the header should be rstSections like the header
  "      title and the bottom line of the header, but instead the top line
  "      gets a rstFakeHRAll match).
  "
  " - Note that the captured (.) character \1 matches case-insensitively.
  "   - E.g., `e` will match `E`, so
  "       EEeeeeEEEEEEeee
  "     will match.
  "   - There's probably a way to match case-sensitively but meh.
  "
  " Match lines with the same character repeating 8 or more times,
  " with optional preceding and trailing whitespace.
  " - Note that, even though this rule is first, it'll override the
  "   following rules, sorta. E.g., if we used this rule with a period
  "   to match any character:
  "     syn match rstFakeHRAll '^\n\s*\(.\)\1\{8,}\s*\n$'
  "   then typing 8 repeating asterisks as one line would match the
  "   rstFakeHRStars rule, but typing 9 or more repeating asterisk
  "   would match rstFakeHRAll instead. Not sure why. To avoid this,
  "   exclude the special characters from the 'all' match.

  " CXREF: See also the builtin runtime/syntax/rst.vim rstTransition rule:
  "   syn match   rstTransition  /^[=`:.'"~^_*+#-]\{4,}\s*$/
  " which would match some of these same style of HRs if we were not to
  " define these rules.

  syn match rstFakeHRAll   '^\n\s*\([^|*$()%]\)\1\{8,}\s*\n$'
  " Match lines of repeating `|`s.
  syn match rstFakeHRPipes '^\s*|\{8,}\s*\n$'
  " Match lines of repeating `$`s.
  syn match rstFakeHRBills '^\s*\$\{8,}\s*\n$'
  " Match lines of repeating `*`s.
  syn match rstFakeHRStars '^\s*\*\{8,}\s*\n$'
  " Match lines of repeating `(`s or `)`s.
  syn match rstFakeHRParns '^\s*[()]\{8,}\s*\n$'
  " Match lines of repeating `%`s.
  syn match rstFakeHRPercs '^\s*%\{8,}\s*\n$'

  " Orange-yellow: Statement, or Keyword
  hi! def link rstFakeHRAll   Statement
  " More orangy (darker than orange-yellow)
  hi! def link rstFakeHRStars Delimiter
  " Light pinkish-orangish-reddish
  hi! def link rstFakeHRPercs String
  " Green: Type, or Question
  hi! def link rstFakeHRPipes Question
  " White on baby blue
  hi! def link rstFakeHRParns MatchParen
  " Black on baby blue
  hi def rstHorizRuleUser01 term=reverse guibg=DarkCyan guifg=Black ctermfg=1 ctermbg=6
  hi! def link rstFakeHRBills rstHorizRuleUser01
endfunction

" +----------------------------------------------------------------------+

function! s:reST_highline_Wire_Highlights()
  call s:reST_highline_Apply_Highlights()
endfunction

" +----------------------------------------------------------------------+

call s:reST_highline_Wire_Highlights()

