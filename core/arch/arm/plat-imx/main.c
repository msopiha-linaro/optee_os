// SPDX-License-Identifier: BSD-2-Clause
/*
 * Copyright (C) 2015 Freescale Semiconductor, Inc.
 * Copyright (c) 2016, Wind River Systems.
 * All rights reserved.
 * Copyright 2019 NXP
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <arm.h>
#include <console.h>
#include <drivers/gic.h>
#include <drivers/imx_uart.h>
#include <io.h>
#include <imx.h>
#include <kernel/generic_boot.h>
#include <kernel/misc.h>
#include <kernel/panic.h>
#include <kernel/pm_stubs.h>
#include <mm/core_mmu.h>
#include <mm/core_memprot.h>
#include <platform_config.h>
#include <stdint.h>
#include <sm/optee_smc.h>
#include <tee/entry_fast.h>
#include <tee/entry_std.h>


static void main_fiq(void);
static struct gic_data gic_data;

static const struct thread_handlers handlers = {
	.std_smc = tee_entry_std,
	.fast_smc = tee_entry_fast,
	.nintr = main_fiq,
#if defined(CFG_WITH_ARM_TRUSTED_FW)
	.cpu_on = cpu_on_handler,
	.cpu_off = pm_do_nothing,
	.cpu_suspend = pm_do_nothing,
	.cpu_resume = pm_do_nothing,
	.system_off = pm_do_nothing,
	.system_reset = pm_do_nothing,
#else
	.cpu_on = pm_panic,
	.cpu_off = pm_panic,
	.cpu_suspend = pm_panic,
	.cpu_resume = pm_panic,
	.system_off = pm_panic,
	.system_reset = pm_panic,
#endif
};

static struct imx_uart_data console_data;

#ifdef CONSOLE_UART_BASE
register_phys_mem_pgdir(MEM_AREA_IO_NSEC, CONSOLE_UART_BASE,
			CORE_MMU_PGDIR_SIZE);
#endif
#ifdef GIC_BASE
register_phys_mem_pgdir(MEM_AREA_IO_SEC, GIC_BASE, CORE_MMU_PGDIR_SIZE);
#endif
#ifdef ANATOP_BASE
register_phys_mem_pgdir(MEM_AREA_IO_SEC, ANATOP_BASE, CORE_MMU_PGDIR_SIZE);
#endif
#ifdef GICD_BASE
register_phys_mem_pgdir(MEM_AREA_IO_SEC, GICD_BASE, 0x10000);
#endif
#ifdef AIPS0_BASE
register_phys_mem_pgdir(MEM_AREA_IO_SEC, AIPS0_BASE,
			ROUNDUP(AIPS0_SIZE, CORE_MMU_PGDIR_SIZE));
#endif
#ifdef AIPS1_BASE
register_phys_mem_pgdir(MEM_AREA_IO_SEC, AIPS1_BASE,
			ROUNDUP(AIPS1_SIZE, CORE_MMU_PGDIR_SIZE));
#endif
#ifdef AIPS2_BASE
register_phys_mem_pgdir(MEM_AREA_IO_SEC, AIPS2_BASE,
			ROUNDUP(AIPS2_SIZE, CORE_MMU_PGDIR_SIZE));
#endif
#ifdef AIPS3_BASE
register_phys_mem_pgdir(MEM_AREA_IO_SEC, AIPS3_BASE,
			ROUNDUP(AIPS3_SIZE, CORE_MMU_PGDIR_SIZE));
#endif
#ifdef IRAM_BASE
register_phys_mem(MEM_AREA_TEE_COHERENT,
		  ROUNDDOWN(IRAM_BASE, CORE_MMU_PGDIR_SIZE),
		  CORE_MMU_PGDIR_SIZE);
#endif
#ifdef M4_AIPS_BASE
register_phys_mem(MEM_AREA_IO_SEC, M4_AIPS_BASE, M4_AIPS_SIZE);
#endif
#ifdef IRAM_S_BASE
register_phys_mem(MEM_AREA_TEE_COHERENT,
		  ROUNDDOWN(IRAM_S_BASE, CORE_MMU_PGDIR_SIZE),
		  CORE_MMU_PGDIR_SIZE);
#endif

#if defined(CFG_PL310)
register_phys_mem_pgdir(MEM_AREA_IO_SEC,
			ROUNDDOWN(PL310_BASE, CORE_MMU_PGDIR_SIZE),
			CORE_MMU_PGDIR_SIZE);
#endif

const struct thread_handlers *generic_boot_get_handlers(void)
{
	return &handlers;
}

static void main_fiq(void)
{
	gic_it_handle(&gic_data);
}

void console_init(void)
{
	imx_uart_init(&console_data, CONSOLE_UART_BASE);
	register_serial_console(&console_data.chip);
}

void main_init_gic(void)
{
#ifdef CFG_ARM_GICV3
	vaddr_t gicd_base;

	gicd_base = core_mmu_get_va(GICD_BASE, MEM_AREA_IO_SEC);

	if (!gicd_base)
		panic();

	/* Initialize GIC */
	gic_init(&gic_data, 0, gicd_base);
	itr_init(&gic_data.chip);
#else
	vaddr_t gicc_base;
	vaddr_t gicd_base;

	gicc_base = core_mmu_get_va(GIC_BASE + GICC_OFFSET, MEM_AREA_IO_SEC);
	gicd_base = core_mmu_get_va(GIC_BASE + GICD_OFFSET, MEM_AREA_IO_SEC);

	if (!gicc_base || !gicd_base)
		panic();

	/* Initialize GIC */
	gic_init(&gic_data, gicc_base, gicd_base);
	itr_init(&gic_data.chip);
#endif
}

#if CFG_TEE_CORE_NB_CORE > 1
void main_secondary_init_gic(void)
{
	gic_cpu_init(&gic_data);
}
#endif

#if defined(CFG_BOOT_SYNC_CPU)
static void psci_boot_allcpus(void)
{
	vaddr_t src_base = core_mmu_get_va(SRC_BASE, MEM_AREA_TEE_COHERENT);
	uint32_t pa = virt_to_phys((void *)TEE_TEXT_VA_START);

	/* set secondary entry address and release core */
	io_write32(src_base + SRC_GPR1 + 8, pa);
	io_write32(src_base + SRC_GPR1 + 16, pa);
	io_write32(src_base + SRC_GPR1 + 24, pa);

	io_write32(src_base + SRC_SCR, BM_SRC_SCR_CPU_ENABLE_ALL);
}
#endif

void plat_cpu_reset_late(void)
{
	if (!get_core_pos()) {
		/* primary core */
#if defined(CFG_BOOT_SYNC_CPU)
		psci_boot_allcpus()
#endif
		imx_configure_tzasc();
	}
}
