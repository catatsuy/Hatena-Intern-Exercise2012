package TemplateEngine;

use strict;
use warnings;
use utf8;
use IO::File;

binmode STDOUT, ':utf8'; # STDOUTをUTF-8ストリーム

# コンストラクタ
sub new {
    my ($class, %values) = @_;  # クラス名と引数

    # データを用意する
    my $data_structure = {
        file => $values{file},
    };
    # 手続き(= パッケージ)とデータを結びつける
    my $self = bless $data_structure, $class;
}

sub render {
    my ($self, $values) = @_;   # 引数をリファレンスとして受け取る
    my $file = IO::File->new($self->{file}, 'r');
    my $output;

    # デリファレンスしてエスケープ
    while (my ($key, $value) = each %$values) {
        $values->{$key} = &_htmlspecialchars($value);
    }
    
    while (my $_ = $file->getline) {
        s/{%\s*([^%\s}]+)\s*%}/$values->{$1}/g;
        $output .= $_;
    }
    $file->close;
    $output;
}

# htmlエスケープ
sub _htmlspecialchars {
    my ($_) = @_;
    s/\&/\&amp\;/g;
    s/\"/\&quot\;/g;
    s/\'/&#039;/g;
    s/\</\&lt\;/g;
    s/\>/\&gt\;/g;
    $_;
}

1; # おまじない
