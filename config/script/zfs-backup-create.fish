zpool create -f -o ashift=12 \
    -O encryption=on -O keyformat=passphrase -O xattr=sa -O acltype=posixacl \
    -m legacy backup mirror \
    ata-Lexar_480GB_SSD_K46106J005198 ata-Lexar_480GB_SSD_K46106J005201
