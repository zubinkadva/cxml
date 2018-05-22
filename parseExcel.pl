#!/usr/bin/perl  

##########################################################################
#requires CPAN modules Spreadsheet::ParseExcel Spreadsheet::XLSX 
#requires CPAN modules Spreadsheet::Read Archive::Zip
#optional CPAN module Data::Printer
#first row in input excel file consists of row headings
#need to create xml folder - all xml files are stored in this directory
#define column rows for all parameters below
#call this file as 'perl parseExcel.pl excelfilename.xlsx'
#output is in xml.zip; all xml files are deleted
##########################################################################

use Spreadsheet::Read;
#use Data::Printer;
use Archive::Zip qw(:ERROR_CODES :CONSTANTS);

my $book = ReadData ($ARGV[0]);

#define columns here
$fileName_col = 'B';
$filePath_col = 'N';
$fileBarcode_col = 'B'; #same as filename col
$circleName_col = 'C';
$barcodeFrom_col = 'I';
$barcodeTo_col = 'I';
$month_col = 'O';
$year_col = 'P';

my $sheet = $book->[1];  #first datasheet
my $col = $book->[1]{maxcol};
my $row = $book->[1]{maxrow};

@file_name = (); #empty array

$j = 2; #start from second row after headings
$start_row = 2;
$end_row = 0;

$first_line = "<xml encoding=\"ISO-8859-1\" version=\"1.0\">\n";
$invoice_start = "\t<Invoice>\n";
$invoice_end = "\t</Invoice>\n";
$file_metadata_start = "\t\t<file_metadata>\n";
$file_metadata_end = "\t\t</file_metadata>\n";
$datefrom = "\t\t\t<DateFrom/>\n";
$dateto = "\t\t\t<DateTo/>\n";
$chequenoFrom = "\t\t\t<ChequenoFrom/>\n";
$chequenoTo = "\t\t\t<ChequenoTo/>\n";


while ($j <= $row) #loop through all rows
{
   $c = $fileBarcode_col.$j;
   $element = $book->[1]{$c};

   if (!(grep {$_ eq $element} @file_name))
   {   
      if ($j == 2) #first row (after headings) 
      {
         push(@file_name, $element);
      }
      else
      {
         $end_row = $j - 1; #the previous row ends the sequence
         $fileName = $book->[1]{$fileName_col.$end_row};
         $file_path = $book->[1]{$filePath_col.$start_row};
         $file_barcode = $book->[1]{$fileBarcode_col.$start_row};
         $circle_name = $book->[1]{$circleName_col.$start_row};
         $barcode_from = $book->[1]{$barcodeFrom_col.$start_row};
         $barcode_to = $book->[1]{$barcodeTo_col.$end_row};
         $month = $book->[1]{$month_col.$start_row};
         $year = $book->[1]{$year_col.$start_row};
         @test = ();
         push(@test, $fileName, $file_path, $file_barcode, $circle_name, $barcode_from, $barcode_to, $month, $year);
         #p @test;

         my $file = 'xml/'.$fileName.'.xml';
         open(my $fh, '>', $file) or die "Could not open file '$file' $!";
         print $fh $first_line;
         print $fh $invoice_start;
         $line = "\t\t<file_name>".$fileName."</file_name>\n";
         print $fh $line;
         $line = "\t\t<file_path>".$file_path."</file_path>\n";
         print $fh $line;
         print $fh $file_metadata_start;
         $line = "\t\t\t<FileBarCode>".$file_barcode."</FileBarCode>\n";
         print $fh $line;
         $line = "\t\t\t<CircleName>".$circle_name."</CircleName>\n";
         print $fh $line;
         $line = "\t\t\t<BarcodeFrom>".$barcode_from."</BarcodeFrom>\n";
         print $fh $line;
         $line = "\t\t\t<BarcodeTo>".$barcode_to."</BarcodeTo>\n";
         print $fh $line;
         $line = "\t\t\t<Month>".$month."</Month>\n";
         print $fh $line;
         $line = "\t\t\t<Year>".$year."</Year>\n";
         print $fh $line;
         print $fh $datefrom;
         print $fh $dateto;
         print $fh $chequenoFrom;
         print $fh $chequenoTo;
         print $fh $file_metadata_end;
         print $fh $invoice_end;
         print $fh "</xml>\n";
         
         close $fh;
       
         push(@file_name, $element);
         $start_row = $j;
         
         #push(@start_rows, $start_row);
         #push(@end_rows, $end_row);
         #p @start_rows;
         #p @end_rows;
      }
   }
#   p @file_name;
   $j++;
}
$end_row = $j - 1;
$fileName = $book->[1]{'B'.$end_row};
$file_path = $book->[1]{'N'.$start_row};
$file_barcode = $book->[1]{'B'.$start_row};
$circle_name = $book->[1]{'C'.$start_row};
$barcode_from = $book->[1]{'I'.$start_row};
$barcode_to = $book->[1]{'I'.$end_row};
$month = $book->[1]{'O'.$start_row};
$year = $book->[1]{'P'.$start_row};
@test = ();
push(@test, $fileName, $file_path, $file_barcode, $circle_name, $barcode_from, $barcode_to, $month, $year);
#p @test;

my $file = 'xml/'.$fileName.'.xml';
open(my $fh, '>', $file) or die "Could not open file '$file' $!";
print $fh $first_line;
print $fh $invoice_start;
$line = "\t\t<file_name>".$fileName."</file_name>\n";
print $fh $line;
$line = "\t\t<file_path>".$file_path."</file_path>\n";
print $fh $line;
print $fh $file_metadata_start;
$line = "\t\t\t<FileBarCode>".$file_barcode."</FileBarCode>\n";
print $fh $line;
$line = "\t\t\t<CircleName>".$circle_name."</CircleName>\n";
print $fh $line;
$line = "\t\t\t<BarcodeFrom>".$barcode_from."</BarcodeFrom>\n";
print $fh $line;
$line = "\t\t\t<BarcodeTo>".$barcode_to."</BarcodeTo>\n";
print $fh $line;
$line = "\t\t\t<Month>".$month."</Month>\n";
print $fh $line;
$line = "\t\t\t<Year>".$year."</Year>\n";
print $fh $line;
print $fh $datefrom;
print $fh $dateto;
print $fh $chequenoFrom;
print $fh $chequenoTo;
print $fh $file_metadata_end;
print $fh $invoice_end;
print $fh "</xml>\n";
close $fh;


my $zip = Archive::Zip->new();

#add a directory
#my $dir_member = $zip->addDirectory('xml/');
my $dir = './xml';
foreach my $fp (glob("$dir/*.xml"))
{
   $zip->addFile($fp);
}

#save the zip file
unless ($zip->writeToFileNamed('xml.zip') == AZ_OK)
{
   die 'zip write error';
}

#delete all xml files in the xml directory
unlink glob "xml/*.*";

