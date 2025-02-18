module fifo_test #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
);
    // Clock generation
    logic clk = 0;
    always #5 clk = ~clk;

    // Interface instantiation
    fifo_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) fifo_if (
        .clk(clk)
    );

    // DUT instantiation
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(fifo_if.rst_n),
        .wr_en(fifo_if.wr_en),
        .rd_en(fifo_if.rd_en),
        .data_in(fifo_if.data_in),
        .data_out(fifo_if.data_out),
        .full(fifo_if.full),
        .empty(fifo_if.empty)
    );

    initial begin
        // Test case 1: Reset test
        $display("Test Case 1: Reset Test");
        fifo_if.reset();
        assert(fifo_if.empty == 1'b1) else $error("FIFO should be empty after reset");
        
        $display("Test Case 2: Write Until Full");
        for(int i = 0; i < DEPTH; i++) begin
            fifo_if.write_fifo(i);
        end
        assert(fifo_if.full == 1'b1) else $error("FIFO should be full");

        $display("Test Case 3: Read Until Empty");
        logic [DATA_WIDTH-1:0] read_data;
        for(int i = 0; i < DEPTH; i++) begin
            fifo_if.read_fifo(read_data);
            assert(read_data == i) else $error("Read data mismatch");
        end
        assert(fifo_if.empty == 1'b1) else $error("FIFO should be empty");

        $display("Test Case 4: Simultaneous Read/Write");
        fifo_if.write_fifo(8'hAA);
        fork
            fifo_if.write_fifo(8'hBB);
            fifo_if.read_fifo(read_data);
        join
        assert(read_data == 8'hAA) else $error("Simultaneous R/W data mismatch");

        $display("All tests completed!");
        $finish;
    end

    covergroup fifo_cov @(posedge clk);
        full_cp: coverpoint fifo_if.full;
        empty_cp: coverpoint fifo_if.empty;
        wr_en_cp: coverpoint fifo_if.wr_en;
        rd_en_cp: coverpoint fifo_if.rd_en;
    endgroup

    fifo_cov cov = new();

endmodule
