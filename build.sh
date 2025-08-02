#!/bin/bash -x
cd lede
echo "update feeds"
./scripts/feeds update -a || { echo "update feeds failed"; exit 1; }
echo "install feeds"
./scripts/feeds install -a || { echo "install feeds failed"; exit 1; }
#./scripts/feeds update qmodem
./scripts/feeds install -a -f -p qmodem || { echo "install qmodem feeds failed"; exit 1; }
cat ../m28c.config > .config
echo "make defconfig"
make defconfig || { echo "defconfig failed"; exit 1; }
echo "diff initial config and new config:"
diff ../m28c.config .config
echo "make download"
make download -j8 || { echo "download failed"; exit 1; }
echo "patch Makefile"
sed -i 's#$(CP) $(STAGING_DIR_HOST)/include/e2fsprogs/uuid/uuid.h $(STAGING_DIR_HOST)/include/uuid/uuid.h##g' feeds/packages/utils/hwinfo/Makefile
echo "make lede"
if [ "$ACTIONS_RUNNER_DEBUG" = "true" ] || [ "$ACTIONS_STEP_DEBUG" = "true" ]; then
    echo "ACTIONS_RUNNER_DEBUG or ACTIONS_STEP_DEBUG is set, using V=s -j1"
    make V=s -j1 || { echo "make failed"; exit 1; }
else
    make -j$(nproc) || { echo "make failed"; exit 1; }
fi
