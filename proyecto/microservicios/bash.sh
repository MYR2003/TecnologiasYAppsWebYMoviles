#!/bin/bash
# En este archivo se añaden todos los microservicios

#node alergias.js & node consultas.js &
#node index.js

files=(*)
temp=()
for file in "${files[@]}"
do
    if [[ ! "${file}" == *".json" && "${file}" == *".js" && ! "${file}" == *"config" ]]
    then
        temp+=("${file}")
    fi
done

for element in "${temp[@]}"
do
    node "${element}" &
done

wait