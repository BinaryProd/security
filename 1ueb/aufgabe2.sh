file="/etc/services"
copy="services"

for item in sha256 sha1 sha384 md5
do
    $item $file
done

cp $file $copy
echo "add a line in the" >> $copy

echo ""
printf "Copying /etc/services inside the current directory and adding a line inside\n"
echo ""

for item in sha256 sha1 sha384 md5
do
    $item $copy
done

echo ""
printf "Und jetzt mit Openssl\n"
echo ""
sleep 2

for item in sha256 sha1 sha384 md5
do
    openssl dgst -$item $file
done

echo ""

for item in sha256 sha1 sha384 md5
do
    openssl dgst -$item $copy
done

echo ""
printf "Und jetzt noch mit SHA512, whirlpool und RIPEMD160\n"
echo ""
sleep 2

for item in sha512 whirlpool ripemd160
do
    openssl dgst -$item $file
done

echo ""

for item in sha512 whirlpool ripemd160
do
    openssl dgst -$item $copy
done
