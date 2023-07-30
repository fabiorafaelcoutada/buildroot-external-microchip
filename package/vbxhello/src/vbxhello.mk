################################################################################
#
# vbxhello package
#
################################################################################

VBXHELLO_VERSION = 1.0
VBXHELLO_SITE = package/vbxhello/src
VBXHELLO_SITE_METHOD = local# Other methods like git,wget,scp,file etc. are also available.

define VBXHELLO_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define VBXHELLO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/embeddedinn  $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))