#!/usr/bin/env sh

set -e

cd certs

WEEK=604800

for key in *-key.pem ; do
    key=$(basename $key)
    cert=${key%-key.pem}.pem
    host=${cert%.pem}

    if [ "${host#"_wildcard"}" != "${host}" ]; then
        host="*${host#"_wildcard"}"
    fi  
    
    if openssl x509 -checkend $WEEK -noout -in ${cert} > /dev/null 2>&1 ; then
        until=$(date --date="$(openssl x509 -enddate -noout -in "${cert}"|cut -d= -f 2)" --iso-8601)
        echo "${host} valid until ${until}"
    else
        echo "refresh ceritificate for ${host}"
        mkcert "${host}"
    fi
done

cd - > null 2>&1
