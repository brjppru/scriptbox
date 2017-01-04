#!/usr/bin/perl

my %data;

while(<STDIN>)
{
  chomp $_;

  if(length($_) > 80)
  {
    my @arr;
    @arr = split(" ", $_);
    my $key = join(" ", @arr[1..3]);
    if($data{$key})
    {
      $data{$key} = $data{$key} . ',' . $arr[0];
    }
    else
    {
      $data{$key} = $arr[0];
    }
  }
}
sub mysort
{
  $a cmp $b;
}
my $count = 0;
my @output;
foreach my $key (keys %data)
{
  my %vals = ();
  foreach my $item (split (',', $data{$key}))
  {
    $vals{$item} = 1;
  }
  $output[$count] = join(',', sort mysort keys %vals ) . " " . $key;
  $count++;
}
print join("\n", sort mysort @output) . "\n";
