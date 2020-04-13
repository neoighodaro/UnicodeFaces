BUNDLE_NAME = UnicodeFaces

UnicodeFaces_FILES = $(wildcard *.m)
UnicodeFaces_INSTALL_PATH = /Library/PreferenceBundles
UnicodeFaces_FRAMEWORKS = UIKit
UnicodeFaces_PRIVATE_FRAMEWORKS = Preferences
UnicodeFaces_LIBRARIES = cephei cepheiprefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/UnicodeFaces.plist$(ECHO_END)
