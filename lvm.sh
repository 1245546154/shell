#!/bin/bash
[ -f /etc/init.d/functions ] && . /etc/init.d/functions 
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
PINK_COLOR='\E[1;35m'
RES='\E[0m'

function menu(){
    echo -e "${RED_COLOR}Welcome to Logical Volume Management System!${RES}"
    echo -e "--------------------------------------------"
    echo -e "1.${BLUE_COLOR}Create Physics Volume${RES}"
    echo -e "2.${BLUE_COLOR}Create Volume Group${RES}"
    echo -e "3.${BLUE_COLOR}Create Logical Volume${RES}"
    echo -e "4.${BLUE_COLOR}Delete Physics Volume${RES}"
    echo -e "5.${BLUE_COLOR}Delete Volume Group${RES}"
    echo -e "6.${BLUE_COLOR}Delete Logical Volume${RES}"
    echo -e "7.${BLUE_COLOR}Extend Volume Group${RES}"
    echo -e "8.${BLUE_COLOR}Extend Logical Volume${RES}"
    echo -e "9.${BLUE_COLOR}Create a Snapshot${RES}\n"
#    echo -e ""

}

function select_function(){
    read -p "Please select the function you want:" fun_option
    case ${fun_option} in 
        1)
            create_pv
            ;;
        2)
            create_vg
            ;;
        3)
            create_lv
            ;;
        4)
            delete_pv
            ;;
        5)
            delete_vg
            ;;
        6)
            delete_lv
            ;;
        7)
            extend_vg
            ;;
        8)
            extend_lv
            ;;
        9)
            snap_shot
            ;;
        *)
            action "Invalid Parameter!"
            exit 23
            ;;
    esac
}

function create_pv(){
    read -p "Please enter a physics device(ex:/dev/sdb1):" dev_name
    if [ -z ${dev_name} ];then
        action "No Device Being Entered!" /bin/false 
        exit 1
    fi
    /sbin/pvs ${dev_name} &> /dev/null 
    if [ $? -eq 0 ];then
        action "The Device Already Existed!" /bin/false 
    else
        /sbin/pvcreate ${dev_name} &> /dev/null 
        [ $? -eq 0 ] && action "${dev_name} Created Successfully!" /bin/true || {
        action "Other Errors!" /bin/false ;
        exit 5
        }
        exit 0
    fi
}

function create_vg(){
    read -p "Please enter a volume group name(ex:vg01):" vg_name 
    read -p "Please enter a physics volume or device name(ex:/dev/sdb1):" pv_name 
    if [ -z ${vg_name} ];then 
        action "No Volume Group Being Entered!" /bin/false 
    fi
    /sbin/vgs ${vg_name} &> /dev/null 
    if [ $? -eq 0 ];then
        action "The Volume Group Already Existed!" /bin/false 
        exit 3
    else
        flag=`/sbin/pvs ${pv_name} -o vg_name|sed -n "2p" |awk '{print $1}'`
        if [ "$flag" = "" ];then
            /sbin/vgcreate ${vg_name} ${pv_name} &> /dev/null 
            [ $? -eq 0 ] && action "${vg_name} Created Successfully!" /bin/true ||{
            action "Other Errors!" /bin/false ;
            exit 6
            } 
        else
            action "pv ${pv_name} is already in \"${flag}\" volume group!" /bin/false 
            exit 4
        fi
    fi
}

function create_lv(){
    read -p "Please enter a logical volume name(ex:lv01):" lv_name
    read -p "Please enter the Size of the lv to be created(ex:2G or 2000M):" lv_cap
    read -p "Please enter the volume group that created the logical volume(ex:vg01):" which_vg
    if [ -z ${lv_name} -o -z ${lv_cap} -o -z ${which_vg} ];then
        action "No LV name or LV capacity or VG name Being Entered!" /bin/false
        exit 7
    else
        /sbin/vgs ${which_vg} &> /dev/null 
        if [ $? -eq 0 ];then
            /sbin/lvcreate -n ${lv_name} -L ${lv_cap} ${which_vg} &> /dev/null 
            [ $? -eq 0 ] && action "${lv_name} Created Successfully!" /bin/true ||{
            action "Other Errors!" /bin/false
            exit 8
            }
        fi
    fi
}

function delete_pv(){
    read -p "Please enter the PV name you want to delete(ex:/dev/sdb1):" del_pv_name
    flag2=`/sbin/pvs ${del_pv_name} -o vg_name|sed -n "2p" |awk '{print $1}'`
    if [ "$flag2" = "" ];then
        /sbin/pvremove ${del_pv_name} &> /dev/null 
        [ $? -eq 0 ] && action "${del_pv_name} Deleted Successfully!" /bin/true || {
        action "Other Errors!" /bin/false ;
        exit 9
        }
    else
        action "PV ${del_pv_name} belongs to other VG!" /bin/false 
        exit 10
    fi
}

function delete_vg(){
    read -p "Please enter the VG name you want to delete(ex:vg01):" del_vg_name
    if [ -z ${del_vg_name} ];then
        action "No VG Name Being Entered!" /bin/false 
        exit 11
    fi
    read -p "This volume group may contain logical volumes. Continue to delete?(Y/N):" verify
    case $verify in 
        y|Y|yes|YES|Yes)
            /sbin/vgremove ${del_vg_name} --force &> /dev/null 
            [ $? -eq 0 ] && action "VG ${del_vg_name} Deleted Successfully!" /bin/true || {
            action "Other Errors!" /bin/false 
            exit 12
            }
            ;;
        n|N|no|NO|No)
            action "Operation Cancellation & Exit the Program" /bin/true 
            exit 13
            ;;
        *)
            action "Invalid Parameter!" /bin/false 
            exit 14
            ;;
    esac
}

function delete_lv(){
    read -p "Please enter the LV name you want to delete(ex:/dev/vg01/lv01):" del_lv_name
    if [ -z $del_lv_name ];then
        action "No Delete LV Being Entered!" /bin/false
    else
        if [ -L ${del_lv_name} ];then
            /sbin/lvremove ${del_lv_name} --force &> /dev/null 
            [ $? -eq 0 ] && action "LV ${del_lv_name} Delete Successfully!" /bin/true || {
            action "Other Errors!" /bin/false 
            exit 15
            }
        else
            action "${del_lv_name} is Not Existed!" /bin/false 
            exit 16
        fi
    fi
}

function extend_vg(){
    read -p "Please enter the VG name you want to extend(ex:vg01):" ext_vg_name 
    read -p "Please enter the PV name you  want to add(ex:/dev/sdb2):" add_pv_name
    if [ -z ${ext_vg_name} -o -z ${add_pv_name} ];then
        action "No VG Name or PV Name Being Entered!" /bin/false 
        exit 17
    fi
    /sbin/vgextend ${ext_vg_name} ${add_pv_name} &> /dev/null 
    [ $? -eq 0 ] && action "${ext_vg_name} Extended Successfully!" /bin/true || {
    action "Other Errors!";
    exit 18
    }
}

function extend_lv(){
    read -p "Please enter the LV name you want to extend(ex:/dev/vg01/lv01):" ext_lv_name 
    read -p "Please enter the Size you want to extend(ex:8G):" ext_to_size
    if [ -z ${ext_to_size} -o -z ${ext_lv_name} ];then
        action "No LV Name or Size Being Entered!" /bin/false 
        exit 19
    fi
    /sbin/lvextend -L ${ext_to_size} ${ext_lv_name} &> /dev/null 
    [ $? -eq 0 ] && action "${ext_lv_name} Extended Successfully!" /bin/true || {
    action "Other Errors!" /bin/false ;
    exit 20
    }
}

function snap_shot(){
    read -p "Please enter the LV name you want to create a snapshot(ex:/dev/vg0/lv02):" bak_lv_name
    read -p "Please enter the Snapshot name(ex:lv02_snap):" snap_name
    read -p "Please enter Size of the Snapshot(ex:1G):" snap_size
    if [ -z ${bak_lv_name} -o -z ${snap_name} ];then
        action "No Back LV Name or Snapshot Name Being Entered!" /bin/false 
        exit 21
    fi
    /sbin/lvcreate -L ${snap_size} -n ${snap_name} -s ${bak_lv_name} &> /dev/null 
    [ $? -eq 0 ] && action "${snap_name} created Successfully!" /bin/true || {
    action "Other Errors!" /bin/false ;
    exit 22
    }
}

function main(){
    menu
    select_function
}

main
