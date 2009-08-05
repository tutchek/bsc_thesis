<?php

$file = $_SERVER['argv'][1];

$data = file_get_contents(dirname(__FILE__).'/'.$file);
$data = Explode("\n", $data);

$n = 0;
$assignment = Array();

if (preg_match(';order[^0-9]+([0-9]+);', $data[0], $M))
{
    $n = (int) $M[1];
}

for ($i = 1; $i <= $n; $i++)
{
    
    $line = preg_replace(";[^0-9-];", " ", $data[$i]);
    $line = preg_replace("; +;", " ", $line);
    $line = Trim($line);
    $line = Explode(" ", $line);

    for ($j = 0; $j < $n; $j++)
    {
        $assignment[$i-1][$j] = $line[$j];
    }
}

?>
MINION 3

**VARIABLES**
<?php
for ($i = 0; $i < $n; $i++)
{
?>
DISCRETE s<?php echo $i?>[<?php echo $n ?>] {0..<?php echo ($n-1) ?>}
<?php
}
?>


**SEARCH**

PRINT[
<?php
for ($i = 0; $i < $n; $i++)
{ echo ($i > 0 ? "," : "")."[s{$i}]"; }
?>
]

VARORDER [
s0 <?php
for ($i = 1; $i < $n; $i++) {
echo ", s{$i}";
}
?>]


**CONSTRAINTS**

<?php
for ($i = 0; $i < $n; $i++) {
?>
alldiff([<?php
for ($j = 0; $j < $n; $j++)
{
    echo ($j > 0 ? ',' : '')." s{$i}[$j]";
}
?>])
<?php
}
?>

<?php
for ($i = 0; $i < $n; $i++) {
?>
alldiff([<?php
for ($j = 0; $j < $n; $j++)
{
    echo ($j > 0 ? ',' : '')." s{$j}[$i]";
}
?>])
<?php
}
?>

<?php
for ($i = 0; $i < $n; $i++) {
    for ($j = 0; $j < $n; $j++)
    {
        if ($assignment[$i][$j] != -1)
        {
            echo "eq(s{$i}[{$j}], {$assignment[$i][$j]})\n";
        }
    }
}
?>

**EOF**
