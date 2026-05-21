vim9script

import autoload 'dist/vim9.vim'

set path+=include,$PWD
var ale_c_include_dirs = ['include', 'prism', 'target/debug', 'target/debug/.ext/include']
ale_c_include_dirs += glob('target/debug/.ext/include/*', false, true)->filter((_, dir) => isdirectory(dir) && filereadable(dir .. '/ruby/config.h'))
b:ale_c_cc_options = ale_c_include_dirs->mapnew((_, dir) => '-I' .. dir)->add('-DRUBY_DEBUG=1')->join(' ')

const ruby_bug_pattern = '\[Bug #\zs\d\+\ze\]'

def RubyBugAtCursor(): string
  return matchstr(getline('.'), '\%<' .. (col('.') + 1) .. 'c\[Bug #\zs\d\+\ze\]\%>' .. col('.') .. 'c')
enddef

def RubyBug(bang: bool)
  @/ = ruby_bug_pattern

  var bug = RubyBugAtCursor()
  if bug == ''
    if search(@/) == 0 || !bang
      return
    endif
    bug = RubyBugAtCursor()
  endif

  if bug != ''
    vim9.Open("https://bugs.ruby-lang.org/issues/" .. bug)
  endif
enddef

command! -bang RubyBug RubyBug(<bang>0)

g:test#custom_runners = get(g:, 'test#custom_runners', {})
g:test#custom_runners.Ruby = ['CRuby']
g:test#enabled_runners = ['ruby#cruby']
