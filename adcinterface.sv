/*
Garnett Goodacre
A01076151 - Set T
January 31, 2023
Revision 0
Lab 3 - ELEX 7660
*/

module adcinterface(
    input logic clk, reset_n,
    input logic [2:0] chan,
    input logic ADC_SDO,

    output logic signed [11:0] result,
    output logic ADC_CONVST, ADC_SCK, ADC_SDI);

    logic [3:0] convst_count;
    logic [5:0] sdi;
    logic [11:0] sdo;
    logic start_sck;

    assign ADC_SCK = (start_sck) ? clk : 1'b0;  //Syncs ADC_SCK to the clock whenever start_sck turns on
    assign ADC_SDI = sdi[5];    // Sets ADC_SDI to the MSB of sdi which shifts through all the bits
    assign ADC_CONVST = &convst_count;  //Turns on ADC_CONVST for one clock cycle
    assign start_sck = (|convst_count[3:1])&(|(~convst_count[3:1]));    //Runs sck only between 13 and 3 for convst_count

    always_ff @(negedge clk or negedge reset_n)
        if(~reset_n)
            convst_count <= 4'd15;
        else
            convst_count <= convst_count - 1;  //Constantly loops convst_count

    always_ff @(posedge ADC_CONVST or negedge ADC_SCK)
        if(ADC_CONVST)
            sdi <= {1'b1,chan[0],chan[2:1],1'b1,1'b0}; //Creates the 6bit word to send through SDI
        else
            sdi <= sdi<<1; //Shifts through the created word to send each bit
    
    always_ff @(posedge ADC_SCK)
        sdo <= sdo<<1|ADC_SDO; //Shifts in SDO
    
    always_ff @(negedge start_sck or negedge reset_n)
        if(~reset_n)
            result <= '0;
        else
            result <= sdo; //Sets result to SDO once it has been completely captured

endmodule

/* Truth Tables

convst_count    |ADC_CONVST |start_sdi
3   2   1   0   |   0       |   0
_____________________________________
0   0   0   0       0           0
0   0   0   1       0           0
0   0   1   0       0           1
0   0   1   1       0           1
0   1   0   0       0           1
0   1   0   1       0           1
0   1   1   0       0           1
0   1   1   1       0           1
1   0   0   0       0           1
1   0   0   1       0           1
1   0   1   0       0           1
1   0   1   1       0           1
1   1   0   0       0           1
1   1   0   1       0           1
1   1   1   0       0           0
1   1   1   1       1           0

chan        |sdi[4:2]
2   1   0   |   4   3   2
__________________________
0   0   0       0   0   0
0   0   1       1   0   0
0   1   0       0   0   1
0   1   1       1   0   1
1   0   0       0   1   0
1   0   1       1   1   0
1   1   0       0   1   1
1   1   1       1   1   1

*/