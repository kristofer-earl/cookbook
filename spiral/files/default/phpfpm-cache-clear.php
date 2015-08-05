<?php
if ( opcache_reset() )
  echo "OK\n";
else
  echo "FAILED\n";
