# ======================================
# buildroot/package/vectorblox/extesrnal.mk
# ======================================
VECTORBLOX_VERSION = 1.0
VECTORBLOX_SITE = $(TOPDIR)/package/vectorblox/

VECTORBLOX_SITE_METHOD = local
VECTORBLOX_TARGET_DIR = /opt/microchip/

define VECTORBLOX_BUILD_CMDS
	# Download libfixmath if not present
	if test ! -d $(@D)/libfixmath-master; then \
		wget --no-check-certificate https://codeload.github.com/PetteriAimonen/libfixmath/zip/master -O $(@D)/libfixmath-master.zip; \
		unzip $(@D)/libfixmath-master.zip -d $(@D)/; \
		rm $(@D)/libfixmath-master.zip; \
	fi;
	# Apply patches to libfixmath (if any)
	cd $(@D)/libfixmath-master/libfixmath/ && \
		$(TARGET_PATCH) "$(PATCH_OPTS)" -r -N -s - < $(@D)/libfixmath-master/libfixmath/*.patch;

	# Compile libfixmath
	cd $(@D)/libfixmath-master/libfixmath/ && \
		$(TARGET_CC) -c *.c && \
		ar qc libfixmath.a *.o;

	# D contains the source code of this package.
	# TARGET_CONFIGURE_OPTS contains several common options such as CFLAGS and LDFLAGS.
	$(MAKE) -C '$(@D)' \
		CC="$(TARGET_CC)" \
		LD="$(TARGET_LD)" \
		CFLAGS="$(TARGET_CFLAGS) -I$(@D)/libfixmath-master/libfixmath" \
		LDFLAGS="$(TARGET_LDFLAGS) -L$(@D)/libfixmath-master/libfixmath" \
		all;
endef

# Define install commands for polarstar_apps
define VECTORBLOX_INSTALL_TARGET_CMDS
	# Define the target path
	INSTALL_PATH := $(TARGET_DIR)$(POLARSTAR_APPS_TARGET_DIR)

	# Create the target path and preserve permission modes
	mkdir -p $(INSTALL_PATH);

	# Install the polarstar-apps run-model
	$(INSTALL) -D -m 0755 $(@D)/run-model $(INSTALL_PATH)run_model;
endef

$(eval $(generic-package))