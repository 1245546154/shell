#!/bin/bash

#��28/Jan/2015ȫ��ķ�����־�ŵ�a.txt�ı�
cat access.log |sed -rn '/28\/Jan\/2015/p' > a.txt 


#ͳ��a.txt�����ж��ٸ�ip����
cat a.txt |awk '{print $1}'|sort |uniq > ipnum.txt


#ͨ��shellͳ��ÿ��ip���ʴ���
for i in `cat ipnum.txt`
do 
iptj=`cat  access.log |grep $i | grep -v 400 |wc -l`
echo "ip��ַ"$i"��2015-01-28��ȫ��(24Сʱ)�ۼƳɹ�����"$iptj"�Σ�ƽ��ÿ�����������Ϊ��"$(($iptj/1440)) >> result.txt
done