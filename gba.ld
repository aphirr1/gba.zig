/* written with https://lokathor.github.io/gba-from-scratch/ex1.html */

ENTRY(_start)

MEMORY {
  /* External Work RAM */
  ewram (w!x) : ORIGIN = 0x2000000, LENGTH = 256K
  /* Internal Work RAM */
  iwram (w!x) : ORIGIN = 0x3000000, LENGTH = 32K
  /* Read Only Memory (rom/GamePak) */
  rom (w!x) : ORIGIN = 0x8000000, LENGTH = 32M
}

/* Puts Everything in the rom, explicity the ENTRY point */
SECTIONS {
  .text : {
    *(.text._start);
    *(.text .text.*);
  } >rom
}
