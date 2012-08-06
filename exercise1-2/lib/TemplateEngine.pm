package TemplateEngine;

use strict;
use warnings;
use utf8;
use IO::File;

use 5.010;

use Data::Dumper;

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
    my $file = IO::File->new($self->{file}, 'r') or die 'Could not open ' . $self->{file} . ' ' . $!;
    my $output;

    # デリファレンスしてエスケープ
    while (my ($key, $value) = each %$values) {
        $values->{$key} = &_htmlspecialchars($value);
    }
    
    while (my $_ = $file->getline) {
        s/{%\s*([^%\s}]+)\s*%}/$values->{$1}/g;

        if (/{%\s*(?<action>\w+)\((?<arguments>[^%-]+)\)\s*-%}/) {
            my $arguments = eval($+{arguments});

            die '引数にリファレンスを渡してください' unless (ref $arguments);

            my ($pre, $suf);
            my $context = shift @$arguments;
            given ( $+{action} ) {
                when ('link') {
                    my $url = shift @$arguments;
                    $pre = $` . '<a href="' . $url . '"' ;
                    $suf = '</a>' . $' ;
                    $output .= $pre . &_extract_ref(shift @$arguments) . '>' . $context . $suf;
                }
                when ('img') {
                    $pre = $` . '<img src="' . $context . '"' ;
                    $suf = ' />' . $' ;
                    $output .= $pre . &_extract_ref(shift @$arguments) . $suf;
                }
                default { die 'undefined ' . $+{action}; }
            }
        } else {
            $output .= $_;
        }
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

# リファレンスを引数に渡すとHTMLとして展開する
sub _extract_ref {
    my $arg = shift;
    my $output;
    while (my ($key, $value) = each %$arg) {
        $output .= ' ' . &_htmlspecialchars($key) . '="' . &_htmlspecialchars($value) . '"';
    }
    $output // '';
}

1; # おまじない
