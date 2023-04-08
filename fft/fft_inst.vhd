	component fft is
		port (
			clk_clk              : in  std_logic                     := 'X';             -- clk
			reset_reset_n        : in  std_logic                     := 'X';             -- reset_n
			sink_valid           : in  std_logic                     := 'X';             -- valid
			sink_ready           : out std_logic;                                        -- ready
			sink_error           : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- error
			sink_startofpacket   : in  std_logic                     := 'X';             -- startofpacket
			sink_endofpacket     : in  std_logic                     := 'X';             -- endofpacket
			sink_data            : in  std_logic_vector(32 downto 0) := (others => 'X'); -- data
			source_valid         : out std_logic;                                        -- valid
			source_ready         : in  std_logic                     := 'X';             -- ready
			source_error         : out std_logic_vector(1 downto 0);                     -- error
			source_startofpacket : out std_logic;                                        -- startofpacket
			source_endofpacket   : out std_logic;                                        -- endofpacket
			source_data          : out std_logic_vector(31 downto 0)                     -- data
		);
	end component fft;

	u0 : component fft
		port map (
			clk_clk              => CONNECTED_TO_clk_clk,              --    clk.clk
			reset_reset_n        => CONNECTED_TO_reset_reset_n,        --  reset.reset_n
			sink_valid           => CONNECTED_TO_sink_valid,           --   sink.valid
			sink_ready           => CONNECTED_TO_sink_ready,           --       .ready
			sink_error           => CONNECTED_TO_sink_error,           --       .error
			sink_startofpacket   => CONNECTED_TO_sink_startofpacket,   --       .startofpacket
			sink_endofpacket     => CONNECTED_TO_sink_endofpacket,     --       .endofpacket
			sink_data            => CONNECTED_TO_sink_data,            --       .data
			source_valid         => CONNECTED_TO_source_valid,         -- source.valid
			source_ready         => CONNECTED_TO_source_ready,         --       .ready
			source_error         => CONNECTED_TO_source_error,         --       .error
			source_startofpacket => CONNECTED_TO_source_startofpacket, --       .startofpacket
			source_endofpacket   => CONNECTED_TO_source_endofpacket,   --       .endofpacket
			source_data          => CONNECTED_TO_source_data           --       .data
		);

