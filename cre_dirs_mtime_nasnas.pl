#!/usr/bin/perl

### win version #!C:\Perl\bin

# my $work_dir = "C:/Documents and Settings/Owner/My Documents/My Pictures\\";
# win-version
# my $work_dir = "N:/Pictures\\";
# NAS-version
my $work_dir = "/Users/raymond/Pictures/";
(-d $work_dir) or die "${work_dir} is not a directory \n";

opendir(DIRHANDLE, $work_dir);
@filenames = readdir(DIRHANDLE);
closedir(DIRHANDLE);

@filenames = sort @filenames;

foreach $filename (@filenames) {
   next if ($filename !~ /(jp[eg]|mov|mp4)/i);# jpg, jpeg of mov CaseInsensitive 

   $mtime = get_mtime($work_dir . $filename);
   my ($yyyy, $mm, $dd) = sec2yyyy_mm_dd($mtime);
   # format the date-attributes to certain-dir standards:
   # will create dirname like yyyy_mm_dd
   my $new_dir = $work_dir . join("-", $yyyy, $mm, $dd);
   
   if (!-e $new_dir) { # -e: true if the file exists
      mkdir($new_dir, 0777) or die "Error creating dir: $new_dir!";
   }
   # 2010-05-13: move the files to the (new) dirs.
   rename $filename, "$new_dir/$filename";
}

### subroutines: ###
sub sec2yyyy_mm_dd {

   $seconds = shift;
   my @datum = localtime($seconds);

   my $yyyy = $datum[5] + 1900;
   my $mm   = sprintf("%.2d", ($datum[4] + 1));
   my $dd   = sprintf("%.2d", ($datum[3]));
   ($yyyy, $mm, $dd);
}

sub get_mtime {
   my $bestand =shift;
   my @st = stat($bestand) or die "Error executing stat($bestand)";
   my $mtime = $st[9]; # Modified time
   $mtime;
}
