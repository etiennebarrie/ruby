vim9script

set path+=include,$PWD
var ale_c_include_dirs = ['include', 'prism', 'target/debug', 'target/debug/.ext/include']
ale_c_include_dirs += glob('target/debug/.ext/include/*', false, true)->filter((_, dir) => isdirectory(dir) && filereadable(dir .. '/ruby/config.h'))
b:ale_c_cc_options = ale_c_include_dirs->mapnew((_, dir) => '-I' .. dir)->add('-DRUBY_DEBUG=1')->join(' ')

g:test#custom_runners = get(g:, 'test#custom_runners', {})
g:test#custom_runners.Ruby = ['CRuby']
g:test#enabled_runners = ['ruby#cruby']
