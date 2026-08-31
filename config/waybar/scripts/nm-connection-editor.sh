#! /bin/bash

case "$(pidof nmrs | wc -l)" in

0)  nmrs
    ;;
1)  killall nmrs
    ;;
*)  killall nmrs
    ;;
esac
