#!/bin/bash

touch ./testing.csv
echo "Student_id,Score" > output.csv

max_score=100
max_student_id=5
first_id=1805121

if [[ $# -ge 2  ]];then
     max_score=$1
     max_student_id=$2 
elif [[  $# -ge 1  ]]; then
     max_score=$1 
fi

cd Submissions
for (( i=first_id; i<first_id+max_student_id ;i++ ))
do
    if [[ -d $i && -f $i/"$i.sh" ]]; then
        number=max_score
        cd $i
        touch tmp.txt

        bash "$i.sh" > tmp.txt
        touch tmp2.txt
        diff  -w ../../AcceptedOutput.txt tmp.txt > tmp2.txt
        (( cnt=$(grep -c '<\|>' tmp2.txt) ))
        (( number=number-(cnt*5) ))

        if [[ $number -le  0  ]]; then 
            (( number=0 ))
        fi
        rm tmp.txt
        rm tmp2.txt
        cd ..

        copy=0
        for j in `ls`
        do
        if [[ $i -ne $j && (( $j<first_id+max_student_id ))  &&  -f $j/"$j.sh" ]]; then
            touch tmp3.txt
            diff -w -b $i/"$i.sh" $j/"$j.sh" > tmp3.txt
            (( cnt=$(grep -c '<\|>' tmp3.txt) ))
            if [[ $cnt -eq 0 ]]; then
                (( copy=1 ))
            fi
            rm tmp3.txt
        fi
        done
    if [[ $copy -eq 1 ]]; then
        (( number=-number ))
    fi

    echo "$i,$number" >> ../output.csv
    
    else
        echo "$i,0" >> ../output.csv
    fi       
done

