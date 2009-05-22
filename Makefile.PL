use inc::Module::Install;
name 'WWW-Veoh-Download';
all_from 'lib/WWW/Veoh/Download.pm';

requires 'Any::Moose';
requires 'HTTP::Request';
requires 'LWP::UserAgent';

tests 't/*.t';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
