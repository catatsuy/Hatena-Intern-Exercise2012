use strict;
use warnings;
use utf8;

use Test::More;
use FindBin::libs;

binmode STDOUT, ':utf8'; # STDOUTをUTF-8ストリーム
binmode STDIN, ':utf8'; # STDINをUTF-8ストリーム

use_ok 'TemplateEngine';

my $template = TemplateEngine->new( file => '../templates/test.html' );
isa_ok $template, 'TemplateEngine';

my $expected = <<'HTML';
<html>
  <head>
    <title>タイトル</title>
  </head>
  <body>
    <p>これはコンテンツです。&amp;&lt;&gt;&quot;</p>
  </body>
</html>

HTML

chomp $expected;

cmp_ok $template->render({
    title   => 'タイトル',
    content => 'これはコンテンツです。&<>"',
}), 'eq', $expected;

my $template2 = TemplateEngine->new( file => '../templates/test_link.html' );

my $expected2 = <<'HTML';
<html>
  <head>
    <title>タイトル</title>
  </head>
  <body>
    <p>これはコンテンツです</p>
    <p><a href="http://example.com">えくざんぷる</a></p>
    <p><a href="http://example.com" target="_blank">えくざんぷる</a></p>
    <p><img src="http://www.catatsuy.org/img/catatsuy50.png" alt="catatsuy" /></p>
  </body>
</html>

HTML

chomp $expected2;

cmp_ok $template2->render({
    title   => 'タイトル',
    content => 'これはコンテンツです',
}), 'eq', $expected2;


done_testing();
