ARCHS = arm64 arm64e
TWEAK_NAME = UnicodeFaces

UnicodeFaces_CFlags = -fobjc-arc -include src/macros.h
UnicodeFaces_FILES = src/Core/UFKeyboard.m src/Core/Keyboard.xm src/Preferences/UFSettings.m
UnicodeFaces_LIBRARIES += tapsharp

# SUBPROJECTS += src/Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
# include $(THEOS_MAKE_PATH)/aggregate.mk

after-uninstall::
	install.exec "killall -9 SpringBoard"

after-install::
	install.exec "killall -9 SpringBoard"
