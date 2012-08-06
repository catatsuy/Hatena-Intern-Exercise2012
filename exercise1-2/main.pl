use strict;
use warnings;
use utf8;
use FindBin::libs;

use TemplateEngine;

my $template = TemplateEngine->new( file => 'templates/test_link.html' );

print $template->render({
  title   => 'タイトル',
  content => 'これはコンテンツです',
});
