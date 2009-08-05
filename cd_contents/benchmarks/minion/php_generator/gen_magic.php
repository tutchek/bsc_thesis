<?php

$n = 5;
if ($_SERVER['argc'] > 1)
{
  $n = (int) $_SERVER['argv'][1];
}

?>
MINION 3

**VARIABLES**
DISCRETE s[<?php echo $n ?>] {0..<?php echo $n ?>}

<?php
for ($i = 0; $i < $n*$n; $i++) {
echo "BOOL aux{$i}\n";
}
?>

**SEARCH**

PRINT[s]

VARORDER [
s <?php
for ($i = 0; $i < $n*$n; $i++) {
echo ", aux{$i}";
}
?>]


**CONSTRAINTS**

<?php
for ($i = 0; $i < $n; $i++) {
  $aux = Array();
  for ($j = 0; $j < $n; $j++)
  {
    echo "reify(eq({$i}, s[{$j}]), aux".($i * $n + $j).")\n";
    
    $aux[] = "aux".($i * $n + $j);
  }
  
  $aux_i = Implode(",", $aux);
  
  echo "sumleq([{$aux_i}], s[$i])\n";
  echo "sumgeq([{$aux_i}], s[$i])\n";
}
?>

**EOF**
