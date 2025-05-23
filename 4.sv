 
module checkers_sim; 
  typedef enum {EMPTY, RED, BLACK} piece_t; 
  piece_t board[8][8]; 
  function void print_board(); 
    int i, j; 
    $display("\nCurrent Board State:"); 
    for (i = 0; i < 8; i++) begin 
      for (j = 0; j < 8; j++) begin 
        case (board[i][j]) 
          EMPTY: $write(" . "); 
          RED:   $write(" R "); 
          BLACK: $write(" B "); 
        endcase 
      end 
      $display(""); 
    end 
    $display(""); 
  endfunction 
  function void init_board(); 
    int i, j; 
    for (i = 0; i < 8; i++) begin 
      for (j = 0; j < 8; j++) begin 
        if ((i < 3) && ((i + j) % 2 == 1)) board[i][j] = RED; 
        else if ((i > 4) && ((i + j) % 2 == 1)) board[i][j] = BLACK; 
        else board[i][j] = EMPTY; 
      end 
    end 
  endfunction 
  function bit make_move(int src_x, int src_y, int dst_x, int dst_y); 
    if (board[src_x][src_y] == EMPTY) begin 
      $display("Error: No piece at source (%0d, %0d)", src_x, src_y); 
      return 0; 
    end 
    if (board[dst_x][dst_y] != EMPTY) begin 
      $display("Error: Destination (%0d, %0d) is not empty!", dst_x, dst_y); 
      return 0; 
    end 
    if ((dst_x < 0) || (dst_x >= 8) || (dst_y < 0) || (dst_y >= 8)) begin 
      $display("Error: Move out of bounds!");  
      return 0; 
    end 
    if (abs(dst_x - src_x) != 1 || abs(dst_y - src_y) != 1) begin 
      $display("Error: Invalid diagonal move!"); 
      return 0; 
    end 
    board[dst_x][dst_y] = board[src_x][src_y]; 
    board[src_x][src_y] = EMPTY; 
    $display("Move successful: (%0d, %0d) -> (%0d, %0d)", src_x, src_y, dst_x, dst_y); 
    return 1; 
  endfunction
  checker move_checker(int src_x, int src_y, int dst_x, int dst_y); 
    property valid_move; 
      (board[src_x][src_y] != EMPTY) && (board[dst_x][dst_y] == EMPTY) && 
      (dst_x >= 0) && (dst_x < 8) && (dst_y >= 0) && (dst_y < 8) && 
      (abs(dst_x - src_x) == 1) && (abs(dst_y - src_y) == 1); 
    endproperty 
    assert property (valid_move) else $error("Assertion Failed: Invalid move detected!"); 
  endchecker 
  initial begin 
    init_board(); 
    print_board(); 
    #5; 
    move_checker m1 = new(2,1,3,2); 
    if (make_move(2,1,3,2)) print_board();
    #5; 
    move_checker m2 = new(3,2,5,4); 
    if (make_move(3,2,5,4)) print_board(); 
    #5; 
    move_checker m3 = new(5,0,4,1); 
    if (make_move(5,0,4,1)) print_board(); 
    #5; 
    move_checker m4 = new(2,0,3,0);
 if (make_move(2,0,3,0)) print_board(); 
    #5; 
    $finish; 
  end 
endmodule
