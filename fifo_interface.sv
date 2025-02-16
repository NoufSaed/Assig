interface fifo_interface #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
) (
    input logic clk
);
    // Interface signals
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    logic full;
    logic empty;

    // Modport for DUT
    modport DUT (
        input  clk, rst_n, wr_en, rd_en, data_in,
        output data_out, full, empty
    );

    // Modport for testbench
    modport TB (
        input  clk, data_out, full, empty,
        output rst_n, wr_en, rd_en, data_in
    );

    // Tasks for testbench operations
    task reset();
        rst_n = 1'b0;
        wr_en = 1'b0;
        rd_en = 1'b0;
        data_in = '0;
        #10;
        rst_n = 1'b1;
    endtask

    task write_fifo(input logic [DATA_WIDTH-1:0] data);
        @(negedge clk);
        if (!full) begin
            wr_en = 1'b1;
            data_in = data;
            @(negedge clk);
            wr_en = 1'b0;
        end
    endtask

    task read_fifo(output logic [DATA_WIDTH-1:0] data);
        @(negedge clk);
        if (!empty) begin
            rd_en = 1'b1;
            @(negedge clk);
            data = data_out;
            rd_en = 1'b0;
        end
    endtask

endinterface
