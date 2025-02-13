PLATFORM_FLAVOR ?= mx6ulevk

# Get SoC associated with the PLATFORM_FLAVOR
mx6ul-flavorlist = \
	mx6ulevk \
	mx6ul9x9evk \
	mx6ulccimx6ulsbcpro \

mx6ull-flavorlist = \
	mx6ullevk \

mx6q-flavorlist = \
	mx6qsabrelite \
	mx6qsabreauto \
	mx6qsabresd \
	mx6qhmbedge \

mx6qp-flavorlist = \
	mx6qpsabreauto \
	mx6qpsabresd \

mx6sl-flavorlist = \
	mx6slevk

mx6sll-flavorlist = \
	mx6sllevk

mx6sx-flavorlist = \
	mx6sxsabreauto \
	mx6sxsabresd \
	mx6sxudooneofull \

mx6d-flavorlist = \
	mx6dhmbedge \

mx6dl-flavorlist = \
	mx6dlsabreauto \
	mx6dlsabresd \
	mx6dlhmbedge \

mx6s-flavorlist = \
	mx6shmbedge \
	mx6solosabresd \
	mx6solosabreauto \

mx7d-flavorlist = \
	mx7dsabresd \
	mx7dpico_mbl \
	mx7dclsom \

mx7s-flavorlist = \
	mx7swarp7 \
	mx7swarp7_mbl \

mx7ulp-flavorlist = \
	mx7ulpevk

imx8mq-flavorlist = \
	imx8mqevk

imx8mm-flavorlist = \
	imx8mmevk

ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6ul-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6UL,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
include core/arch/arm/cpu/cortex-a7.mk
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6ull-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6ULL,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
$(call force,CFG_IMX_CAAM,n)
include core/arch/arm/cpu/cortex-a7.mk
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6q-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6Q,y)
$(call force,CFG_TEE_CORE_NB_CORE,4)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6qp-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6QP,y)
$(call force,CFG_TEE_CORE_NB_CORE,4)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6d-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6D,y)
$(call force,CFG_TEE_CORE_NB_CORE,2)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6dl-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6DL,y)
$(call force,CFG_TEE_CORE_NB_CORE,2)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6s-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6S,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6sl-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6SL,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
$(call force,CFG_IMX_CAAM,n)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6sll-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6SLL,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
$(call force,CFG_IMX_CAAM,n)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx6sx-flavorlist)))
$(call force,CFG_MX6,y)
$(call force,CFG_MX6SX,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx7s-flavorlist)))
$(call force,CFG_MX7,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
include core/arch/arm/cpu/cortex-a7.mk
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx7d-flavorlist)))
$(call force,CFG_MX7,y)
$(call force,CFG_TEE_CORE_NB_CORE,2)
include core/arch/arm/cpu/cortex-a7.mk
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(mx7ulp-flavorlist)))
$(call force,CFG_MX7ULP,y)
$(call force,CFG_TEE_CORE_NB_CORE,1)
$(call force,CFG_TZC380,n)
$(call force,CFG_CSU,n)
include core/arch/arm/cpu/cortex-a7.mk
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(imx8mq-flavorlist)))
$(call force,CFG_IMX8MQ,y)
$(call force,CFG_ARM64_core,y)
CFG_IMX_UART ?= y
CFG_DRAM_BASE ?= 0x40000000
CFG_TEE_CORE_NB_CORE ?= 4
else ifneq (,$(filter $(PLATFORM_FLAVOR),$(imx8mm-flavorlist)))
$(call force,CFG_IMX8MM,y)
$(call force,CFG_ARM64_core,y)
CFG_IMX_UART ?= y
CFG_DRAM_BASE ?= 0x40000000
CFG_TEE_CORE_NB_CORE ?= 4
else
$(error Unsupported PLATFORM_FLAVOR "$(PLATFORM_FLAVOR)")
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7dsabresd))
CFG_DDR_SIZE ?= 0x40000000
CFG_NS_ENTRY_ADDR ?= 0x80800000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7dclsom))
CFG_DDR_SIZE ?= 0x40000000
CFG_UART_BASE ?= UART1_BASE
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7dpico_mbl))
CFG_DDR_SIZE ?= 0x20000000
CFG_NS_ENTRY_ADDR ?= 0x87800000
CFG_DT_ADDR ?= 0x83100000
CFG_UART_BASE ?= UART5_BASE
CFG_BOOT_SECONDARY_REQUEST ?= n
CFG_EXTERNAL_DTB_OVERLAY ?= y
CFG_IMX_WDOG_EXT_RESET ?= y
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7swarp7))
CFG_DDR_SIZE ?= 0x20000000
CFG_NS_ENTRY_ADDR ?= 0x80800000
CFG_BOOT_SECONDARY_REQUEST ?= n
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7swarp7_mbl))
CFG_DDR_SIZE ?= 0x20000000
CFG_NS_ENTRY_ADDR ?= 0x87800000
CFG_DT_ADDR ?= 0x83100000
CFG_BOOT_SECONDARY_REQUEST ?= n
CFG_EXTERNAL_DTB_OVERLAY = y
CFG_IMX_WDOG_EXT_RESET = y
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx7ulpevk))
CFG_DDR_SIZE ?= 0x40000000
CFG_NS_ENTRY_ADDR ?= 0x60800000
CFG_UART_BASE ?= UART4_BASE
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6qpsabresd mx6qsabresd mx6dlsabresd \
	mx6dlsabrelite mx6dhmbedge mx6dlhmbedge mx6solosabresd))
CFG_DDR_SIZE ?= 0x40000000
CFG_NS_ENTRY_ADDR ?= 0x12000000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6qpsabreauto mx6qsabreauto \
	mx6dlsabreauto mx6solosabreauto))
CFG_DDR_SIZE ?= 0x80000000
CFG_NS_ENTRY_ADDR ?= 0x12000000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6qhmbedge))
CFG_DDR_SIZE ?= 0x80000000
CFG_UART_BASE ?= UART1_BASE
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6shmbedge))
CFG_DDR_SIZE ?= 0x40000000
CFG_NS_ENTRY_ADDR ?= 0x12000000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6qsabrelite mx6dlsabrelite))
CFG_DDR_SIZE ?= 0x40000000
CFG_NS_ENTRY_ADDR ?= 0x12000000
CFG_UART_BASE ?= UART2_BASE
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6slevk))
CFG_NS_ENTRY_ADDR ?= 0x80800000
CFG_DDR_SIZE ?= 0x40000000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6sllevk))
CFG_NS_ENTRY_ADDR ?= 0x80800000
CFG_DDR_SIZE ?= 0x80000000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6sxsabreauto))
CFG_DDR_SIZE ?= 0x80000000
CFG_NS_ENTRY_ADDR ?= 0x80800000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6sxsabresd))
CFG_DDR_SIZE ?= 0x40000000
CFG_NS_ENTRY_ADDR ?= 0x80800000
endif

ifeq ($(PLATFORM_FLAVOR), mx6sxudooneofull)
CFG_DDR_SIZE ?= 0x40000000
CFG_UART_BASE ?= UART1_BASE
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6ulevk mx6ullevk))
CFG_DDR_SIZE ?= 0x20000000
CFG_NS_ENTRY_ADDR ?= 0x80800000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6ulccimx6ulsbcpro))
CFG_DDR_SIZE ?= 0x10000000
CFG_NS_ENTRY_ADDR ?= 0x80800000
CFG_UART_BASE ?= UART5_BASE
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),mx6ul9x9evk))
CFG_DDR_SIZE ?= 0x10000000
CFG_NS_ENTRY_ADDR ?= 0x80800000
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),imx8mqevk))
CFG_DDR_SIZE ?= 0xc0000000
CFG_UART_BASE ?= UART1_BASE
endif

ifneq (,$(filter $(PLATFORM_FLAVOR),imx8mmevk))
CFG_DDR_SIZE ?= 0x80000000
CFG_UART_BASE ?= UART2_BASE
endif

# i.MX6 Solo/SL/SoloX/DualLite/Dual/Quad specific config
ifeq ($(filter y, $(CFG_MX6QP) $(CFG_MX6Q) $(CFG_MX6D) $(CFG_MX6DL) $(CFG_MX6S) \
	$(CFG_MX6SL) $(CFG_MX6SLL) $(CFG_MX6SX)), y)
include core/arch/arm/cpu/cortex-a9.mk

$(call force,CFG_PL310,y)

CFG_PL310_LOCKED ?= y
CFG_ENABLE_SCTLR_RR ?= y
CFG_SCU ?= y
endif

ifeq ($(filter y, $(CFG_MX6QP) $(CFG_MX6Q) $(CFG_MX6D) $(CFG_MX6DL) $(CFG_MX6S)), y)
CFG_DRAM_BASE ?= 0x10000000
endif

ifneq (,$(filter y, $(CFG_MX6UL) $(CFG_MX6ULL) $(CFG_MX6SL) $(CFG_MX6SLL) \
	$(CFG_MX6SX)))
CFG_DRAM_BASE ?= 0x80000000
endif

ifeq ($(filter y, $(CFG_MX7)), y)
CFG_INIT_CNTVOFF ?= y
CFG_DRAM_BASE ?= 0x80000000
endif

ifeq ($(filter y, $(CFG_MX7ULP)), y)
CFG_INIT_CNTVOFF ?= y
CFG_DRAM_BASE ?= 0x80000000
$(call force,CFG_IMX_LPUART,y)
$(call force,CFG_BOOT_SECONDARY_REQUEST,n)
endif

ifneq (,$(filter y, $(CFG_MX6) $(CFG_MX7) $(CFG_MX7ULP)))
$(call force,CFG_GENERIC_BOOT,y)
$(call force,CFG_GIC,y)
$(call force,CFG_PM_STUBS,y)
$(call force,CFG_WITH_SOFTWARE_PRNG,y)

CFG_BOOT_SYNC_CPU ?= n
CFG_BOOT_SECONDARY_REQUEST ?= y
CFG_DT ?= y
CFG_PAGEABLE_ADDR ?= 0
CFG_PSCI_ARM32 ?= y
CFG_SECURE_TIME_SOURCE_REE ?= y
CFG_UART_BASE ?= UART1_BASE
CFG_IMX_CAAM ?= y
endif

ifneq (,$(filter y, $(CFG_MX6) $(CFG_MX7)))
$(call force,CFG_IMX_UART,y)
CFG_CSU ?= y
endif

ifeq ($(filter y, $(CFG_PSCI_ARM32)), y)
CFG_HWSUPP_MEM_PERM_WXN = n
CFG_IMX_WDOG ?= y
endif

ifeq ($(CFG_ARM64_core),y)
# arm-v8 platforms
include core/arch/arm/cpu/cortex-armv8-0.mk
$(call force,CFG_ARM_GICV3,y)
$(call force,CFG_GENERIC_BOOT,y)
$(call force,CFG_GIC,y)
$(call force,CFG_WITH_LPAE,y)
$(call force,CFG_WITH_ARM_TRUSTED_FW,y)
$(call force,CFG_SECURE_TIME_SOURCE_CNTPCT,y)

CFG_CRYPTO_WITH_CE ?= y
CFG_PM_STUBS ?= y

supported-ta-targets = ta_arm64
endif

CFG_TZDRAM_START ?= ($(CFG_DRAM_BASE) - 0x02000000 + $(CFG_DDR_SIZE))
CFG_TZDRAM_SIZE ?= 0x01e00000
CFG_SHMEM_START ?= ($(CFG_TZDRAM_START) + $(CFG_TZDRAM_SIZE))
CFG_SHMEM_SIZE ?= 0x00200000

CFG_CRYPTO_SIZE_OPTIMIZATION ?= n
CFG_WITH_STACK_CANARIES ?= y
CFG_MMAP_REGIONS ?= 24
