library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

package vga_fsm_pkg is
	component vga_fsm is
		generic (
			vga_res:	vga_timing := vga_res_default
		);
		port (
			vga_clock:		in	std_logic;
			reset:			in	std_logic;

			point:			out	coordinate;
			point_valid:	out	boolean;

			h_sync:			out	std_logic;
			v_sync:			out std_logic
		);
	end component vga_fsm;
end package vga_fsm_pkg;

library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

entity vga_fsm is
	generic (
		vga_res:	vga_timing := vga_res_default
	);
	port (
		vga_clock:		in	std_logic;
		reset:			in	std_logic;

		point:			out	coordinate;
		point_valid:	out	boolean;

		h_sync:			out	std_logic;
		v_sync:			out std_logic
	);
end entity vga_fsm;

architecture fsm of vga_fsm is
	-- any internal signals you may need
		
	signal coord: coordinate := make_coordinate(0, 0);
begin
	-- implement methodology to drive outputs here
	-- use vga_data functions and types to make your life easier
	
	output_function: process(vga_clock, reset) is
	begin
		if reset = '0' then
			coord <= make_coordinate(0, 0);
		elsif rising_edge(vga_clock) then
			coord <= next_coordinate(coord, vga_res);
		end if;
	end process output_function;
	
	h_sync <= do_horizontal_sync(coord, vga_res);
	v_sync <= do_vertical_sync(coord, vga_res);
	point_valid <= point_visible(coord, vga_res);
	point <= coord;

end architecture fsm;
