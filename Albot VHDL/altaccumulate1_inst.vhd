altaccumulate1_inst : altaccumulate1 PORT MAP (
		aclr	 => aclr_sig,
		clken	 => clken_sig,
		clock	 => clock_sig,
		data	 => data_sig,
		overflow	 => overflow_sig,
		result	 => result_sig
	);
