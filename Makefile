TWEAK_NAME = UnicodeFaces

UnicodeFaces_FILES  = core/UnicodeFacesKeyboard.m
UnicodeFaces_FILES += core/Keyboard.xm
UnicodeFaces_FRAMEWORKS = UIKit CoreGraphics QuartzCore Social Accounts
UnicodeFaces_LIBRARIES = cephei
UnicodeFaces_LDFLAGS += -Wl,-segalign,4000

export ARCHS = armv7 arm64
export TARGET = iphone:clang
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 8.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
