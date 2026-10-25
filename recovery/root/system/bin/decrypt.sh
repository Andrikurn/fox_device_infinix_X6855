#!/system/bin/sh

log() {
    /system/bin/log -t decrypt "$1"
    echo "decrypt: $1" >> /tmp/recovery.log
}

is_mounted() {
    grep -qF " $1 " /proc/mounts
}

wait_for_node() {
    node=$1
    max_tries=$2
    i=0

    while [ ! -e "$node" ] && [ $i -lt "$max_tries" ]; do
        sleep 0.5
        i=$((i + 1))
    done

    [ -e "$node" ]
}


SLOT=$(getprop ro.boot.slot_suffix)
DEV=/dev/block/mapper/vendor$SLOT
PERSIST_DEV=/dev/block/by-name/persist

VENDOR_MNT=/mnt/vendor_decrypt
PERSIST_MNT=/mnt/vendor/persist
FAILURE_RECORDS=$PERSIST_MNT/mcRegistry/failure_records.dat
FAILURE_RECORDS_COPY=/tmp/failure_records.dat

DEGRADED=0


if ! wait_for_node "$DEV" 120; then
    log "vendor$SLOT isn't mapped! decryption will not start."
    exit 1
fi


mkdir -p "$VENDOR_MNT"

if ! is_mounted "$VENDOR_MNT"; then
    if ! mount -t erofs -o ro "$DEV" "$VENDOR_MNT"; then
        log "cannot mount vendor$SLOT as read-only!"
        exit 1
    fi
fi


for dir in bin lib64 app firmware; do
    [ -d "$VENDOR_MNT/$dir" ] || continue

    mkdir -p "/vendor/$dir"

    if ! is_mounted "/vendor/$dir"; then
        if ! mount -o bind,ro "$VENDOR_MNT/$dir" "/vendor/$dir"; then
            log "bind mount of /vendor/$dir failed!"
            DEGRADED=1
        fi
    fi
done


mkdir -p "$PERSIST_MNT"
mkdir -p /data/vendor/mcRegistry

if ! is_mounted "$PERSIST_MNT"; then
    if ! wait_for_node "$PERSIST_DEV" 20; then
        log "persist node never appeared! (TEE may still work)."
        DEGRADED=1
    elif ! mount -t ext4 -o ro,noload "$PERSIST_DEV" "$PERSIST_MNT"; then
        log "persist isn't mounted! (TEE may still work)."
        DEGRADED=1
    fi
fi


if [ -f "$FAILURE_RECORDS" ] && ! is_mounted "$FAILURE_RECORDS"; then
    if ! { cp -p "$FAILURE_RECORDS" "$FAILURE_RECORDS_COPY" \
        && mount --bind "$FAILURE_RECORDS_COPY" "$FAILURE_RECORDS"; }; then
        log "failure_records.dat copy failed, PIN unlock may fail!"
        DEGRADED=1
    fi
fi


if [ "$DEGRADED" -eq 0 ]; then
    log "vendor$SLOT successfully mounted as read-only, starting TEE services!"
else
    log "vendor$SLOT mounted with warnings, starting TEE services anyway."
fi

setprop decrypt.ready 1
