//----------------------------------------------------------------------------
//  A-Z80 CPU Copyright (C) 2014,2016  Goran Devic, www.baltazarstudios.com
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//----------------------------------------------------------------------------
//============================================================================
// A-Z80 Interface Declaration
//============================================================================
`timescale 1us/ 100 ns

module z80_interface(
    input wire RESET_n,  // : in  std_logic;
    input wire CLK_n,    // : in  std_logic;
    input wire CLKEN,    // : in  std_logic;
    input wire WAIT_n,   // : in  std_logic;
    input wire INT_n,    // : in  std_logic;
    input wire NMI_n,    // : in  std_logic;
    input wire BUSRQ_n,  // : in  std_logic;
    output wire M1_n,    // : out std_logic;
    output wire MREQ_n,  // : out std_logic;
    output wire IORQ_n,  // : out std_logic;
    output wire RD_n,    // : out std_logic;
    output wire WR_n,    // : out std_logic;
    output wire RFSH_n,  // : out std_logic;
    output wire HALT_n,  // : out std_logic;
    output wire BUSAK_n, // : out std_logic;
    output wire [15:0] A,// : out std_logic_vector(15 downto 0);
    input wire [7:0] DI, // : in  std_logic_vector(7 downto 0);
    output wire [7:0] DO // : out std_logic_vector(7 downto 0)
);

wire CLK;
assign CLK = ~CLKEN;

assign DO[7:0] = D[7:0];

wire [7:0] D;
wire in_en;
assign in_en = (RD_n == 1'b0) || ((M1_n == 1'b0) && (IORQ_n == 1'b0));
assign D = in_en ? DI : 8'bz;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Instantiate A-Z80 CPU module
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
z80_top_direct_n z80_(
    .nM1(M1_n),
    .nMREQ(MREQ_n),
    .nIORQ(IORQ_n),
    .nRD(RD_n),
    .nWR(WR_n),
    .nRFSH(RFSH_n),
    .nHALT(HALT_n),
    .nBUSACK(BUSAK_n),

    .nWAIT(1),
    .nINT(INT_n),
    .nNMI(1),
    .nRESET(RESET_n),
    .nBUSRQ(1),
    .CLK(CLK),

    .A(A),
    .D(D)
    );

endmodule
