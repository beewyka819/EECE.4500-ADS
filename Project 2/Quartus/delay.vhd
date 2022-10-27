library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;
use vga.vga_fsm_pkg.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

entity delay is
	generic (
		-- complex_converter: 1 clk.
		-- mandelbrot_gen: iterations + 1 clk
		clock_delay: natural := 18
	);
	port (
		system_clock: in std_logic;
		reset: in std_logic;
	
		in_vsync: in std_logic;
		in_hsync: in std_logic;
		out_vsync: out std_logic;
		out_hsync: out std_logic
	);
end entity delay;

architecture shift_reg_impl of delay is
	signal vreg: std_logic_vector(clock_delay - 1 downto 0) := (others => '0');
	signal hreg: std_logic_vector(clock_delay - 1 downto 0) := (others => '0');
begin
	shift: process(system_clock, reset)
	begin
		if reset = '0' then
			vreg <= (others => '0');
			hreg <= (others => '0');
			out_vsync <= '0';
			out_hsync <= '0';
		elsif rising_edge(system_clock) then
			out_vsync <= vreg(vreg'left);
			out_hsync <= hreg(hreg'left);
			
			vreg <= vreg(vreg'left - 1 downto 0) & in_vsync;
			hreg <= hreg(hreg'left - 1 downto 0) & in_hsync;
		end if;
	end process shift;
end architecture shift_reg_impl;
