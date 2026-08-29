`ifndef PREDICTOR_CFG_VH
`define PREDICTOR_CFG_VH

// Branch predictor selection enumeration
localparam integer PRED_STATIC_NOT_TAKEN = 0;
localparam integer PRED_STATIC_TAKEN     = 1;
localparam integer PRED_1BIT            = 2;
localparam integer PRED_2BIT            = 3;
localparam integer PRED_GSHARE          = 4;
localparam integer PRED_TOURNAMENT      = 5;

// Default predictor type (can be overridden via +define+PREDICTOR_TYPE=<value>)
`ifndef PREDICTOR_TYPE
`define PREDICTOR_TYPE PRED_STATIC_NOT_TAKEN
`endif

`endif // PREDICTOR_CFG_VH
