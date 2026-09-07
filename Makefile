ARCHS = arm64
TARGET = iphone:clang:16.5:16.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ResolutionX
ResolutionX_FILES = Tweak.xm
ResolutionX_CFLAGS = -fobjc-arc
ResolutionX_FRAMEWORKS = UIKit CoreGraphics
ResolutionX_PRIVATE_FRAMEWORKS = SpringBoard

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += ResolutionXPrefs

include $(THEOS_MAKE_PATH)/aggregate.mk
