#!/bin/bash

echo '#!/bin/bash' > remote_script.sh
echo '' >> remote_script.sh

frame_files=()
while IFS=  read -r -d $'\0'; do
    frame_files+=("$REPLY")
done < <(find . -name "frame*.txt" -print0 | sort -zV)

for frame_file in "${frame_files[@]}"; do
    frame_number="${frame_file//[^0-9]/}"
    frame_variable="frame${frame_number}"

    {
        echo "read -r -d '' $frame_variable <<'EOF'"
        cat "$frame_file"
        echo 'EOF'
        echo
    } >> remote_script.sh
done

echo 'frames=(' >> remote_script.sh
for frame_file in "${frame_files[@]}"; do
    frame_number="${frame_file//[^0-9]/}"
    echo "\"\$frame${frame_number}\"" >> remote_script.sh
done
echo ')' >> remote_script.sh

cat >> remote_script.sh <<'EOF'

while true; do
  for frame in "${frames[@]}"
  do
    clear
    echo -e "$frame"
    sleep 0.05
  done
done
EOF

chmod +x remote_script.sh
