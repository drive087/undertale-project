//--------------------------------------------------
// Top Module : Digilent Basys 3               
// BeeInvaders Tutorial 4 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

module Top(
    input wire CLK,         // Onboard clock 100MHz : INPUT Pin W5
    input wire RESET,       // Reset button / Centre Button : INPUT Pin U18
    input wire RsRx,
    input wire PS2Data,
    input wire PS2Clk,
    output wire HSYNC,      // VGA horizontal sync : OUTPUT Pin P19
    output wire VSYNC,      // VGA vertical sync : OUTPUT Pin R19
    output wire RsTx,
    output reg [3:0] RED,   // 4-bit VGA Red : OUTPUT Pin G19, Pin H19, Pin J19, Pin N19
    output reg [3:0] GREEN, // 4-bit VGA Green : OUTPUT Pin J17, Pin H17, Pin G17, Pin D17
    output reg [3:0] BLUE,  // 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18/ 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18
    input btnR,             // Right button : INPUT Pin T17
    input btnL,              // Left button : INPUT Pin W19
    input btnU,
    input btnD
    );
    
    wire rst = RESET;       // Setup Reset button
    wire [2:0] state;
    
    
    // instantiate vga640x480 code
    wire [9:0] x;           // pixel x position: 10-bit value: 0-1023 : only need 800
    wire [9:0] y;           // pixel y position: 10-bit value: 0-1023 : only need 525
    wire active;            // high during active pixel drawing
    wire PixCLK;            // 25MHz pixel clock
    wire [1:0] state_game;
    wire attack;
    wire [6:0] pangya_damage;
    reg collision_onceB1 = 0;
    reg collision_onceB2 = 0;
    reg collision_onceGB = 0;
    reg collision_onceBig = 0;
    reg isCollisionGB = 0;
    reg isCollisionB1 = 0;
    reg isCollisionB2 = 0;
    reg isCollisionBig = 0;
    wire character_alive;
    wire monster_alive;
    wire status;

    
    vga640x480 display (.i_clk(CLK),.i_rst(rst),.o_hsync(HSYNC), 
                        .o_vsync(VSYNC),.o_x(x),.o_y(y),.o_active(active),
                        .pix_clk(PixCLK));
                        
    timer_state timer (.i_clk(PixCLK),.attack(attack),.character_alive(character_alive),.monster_alive(monster_alive),.state(state),.o_state_game(state_game));
                        
    uart_echo uart(.Pclk(PixCLK),.RESET(rst),.RX(RsRx),.TX(RsTx),.state(state));
    
    //mouse
    wire data_ready;
    wire error_no_ack;
    wire left_clicked;
    wire right_clicked;
     
    ps2_mouse_interface  

   #(.WATCHDOG_TIMER_VALUE_PP(26000),
   .WATCHDOG_TIMER_BITS_PP(15),
   .DEBOUNCE_TIMER_VALUE_PP(246),
   .DEBOUNCE_TIMER_BITS_PP(8)) 

  m1(
  .clk(clk),
  .reset(reset),
  .ps2_clk(PS2Clk),
  .ps2_data(PS2Data),
  .data_ready(data_ready),
  .read(1'b1),  // force a read
  .left_button(left_clicked),
  .right_button(right_clicked)  // rx_read_o
  );
    // instantiate BeeSprite code
    wire BeeSpriteOn;       // 1=on, 0=off
    wire BorderSpriteOn;
    wire [7:0] dout;        // pixel value from Bee.mem
    wire [7:0] heart_dataout;
    wire [7:0] introout;
    
//    intro intro(.xx(x),.yy(y),.aactive(active),.introOn(introOn),.introout(introout),.Pclk(PixCLK));
    introSprite introSprite(.xx(x),.yy(y),.aactive(active),
                           .TSpriteOn(TSpriteOn),.T_dataout(T_dataout),.CNameSpriteOn(CNameSpriteOn),
                           .CN_dataout(CN_dataout),.JNameSpriteOn(JNameSpriteOn),.JN_dataout(JN_dataout),
                           .TNameSpriteOn(TNameSpriteOn),.TN_dataout(TN_dataout),.FNameSpriteOn(FNameSpriteOn),
                           .FN_dataout(FN_dataout),.PNameSpriteOn(PNameSpriteOn),.PN_dataout(PN_dataout),
                           .PressSpriteOn(PressSpriteOn),.Press_dataout(Press_dataout),.Pclk(PixCLK));

    playground playground (.xx(x),.yy(y),.aactive(active),
                          .PlayGroundOn(PlayGroundOn),.Pclk(PixCLK));
    
                          
    HeartSprite HeartSprite (.xx(x),.yy(y),.aactive(active),
                          .HSpriteOn(HSpriteOn),.heart_dataout(heart_dataout),.Pclk(PixCLK),.state(state));
                          
    character character (.xx(x),.yy(y),.aactive(active),
                          .characterOn(characterOn),.character_dataout(dout),.Pclk(PixCLK));
                          
    
    BorderSprite BorderDisplay (.xx(x),.yy(y),.aactive(active),
                          .BorderSpriteOn(BorderSpriteOn),.Pclk(PixCLK));
                          
    GreenBulletSprite GreenBulletDisplay (.xx(x),.yy(y),.aactive(active),
                          .GreenBulletSpriteOn(GreenBulletSpriteOn),.isCollisionGB(isCollisionGB),.Pclk(PixCLK));
                                                
    BulletSprite BulletDisplay (.xx(x),.yy(y),.aactive(active),
                          .BulletSpriteOn(BulletSpriteOn),.isCollisionB1(isCollisionB1),.Pclk(PixCLK));
    BulletSprite2 BulletDisplay2 (.xx(x),.yy(y),.aactive(active),
                          .BulletSpriteOn2(BulletSpriteOn2),.isCollisionB2(isCollisionB2),.Pclk(PixCLK));
                          
    ObstacleSprite ObstacleSprite (.xx(x),.yy(y),.aactive(active),
                          .ObstacleSpriteOn(ObstacleSpriteOn),.isCollisionBig(isCollisionBig),.Pclk(PixCLK));
                          
    pangya_tab pangya_tab (.xx(x),.yy(y),.aactive(active),
                          .pangyatabOn(pangyatabOn), .pangyatab_color(pangyatab_color),.Pclk(PixCLK));
                          
    pangya_tab2 pangya_tab2 (.xx(x),.yy(y),.aactive(active),
                          .pangyatabOn2(pangyatabOn2),.Pclk(PixCLK),.attack(attack),.pangya_damage(pangya_damage),.state(state),.left_clicked(left_clicked),.state_game(state_game));
                          
    hp_bar hp_bar(.xx(x),.yy(y),.aactive(active),
                          .hp_barOn(hp_barOn),.character_alive(character_alive),.isCollisionB1(isCollisionB1),.isCollisionB2(isCollisionB2),.isCollisionGB(isCollisionGB),.isCollisionBig(isCollisionBig),.state_game(state_game),.Pclk(PixCLK));
                          
    hp_monster_bar hp_monster_bar(.xx(x),.yy(y),.aactive(active),.pangya_damage(pangya_damage),.monster_alive(monster_alive),
                          .hp_monster_barOn(hp_monster_barOn),.attack(attack),.Pclk(PixCLK));
                          
    // instantiate AlienSprites code
    wire Alien1SpriteOn;    // 1=on, 0=off
    wire Alien2SpriteOn;    // 1=on, 0=off
    wire Alien3SpriteOn;    // 1=on, 0=off
    wire [7:0] A1dout;      // pixel value from Alien1.mem
    wire [7:0] A2dout;      // pixel value from Alien2.mem
    wire [7:0] A3dout;      // pixel value from Alien3.mem
    wire [11:0] pangyatab_color;
    AlienSprites ADisplay (.xx(x),.yy(y),.aactive(active),
                          .A1SpriteOn(Alien1SpriteOn),.A2SpriteOn(Alien2SpriteOn),
                          .A3SpriteOn(Alien3SpriteOn),.A1dataout(A1dout),
                          .A2dataout(A2dout),.A3dataout(A3dout),.Pclk(PixCLK));

    // instantiate HiveSprites code
    wire Hive1SpriteOn;     // 1=on, 0=off
    wire Hive2SpriteOn;     // 1=on, 0=off
    wire Hive3SpriteOn;     // 1=on, 0=off
    wire Hive4SpriteOn;     // 1=on, 0=off
    wire [7:0] H1dout;      // pixel value from Hive1
    wire [7:0] H2dout;      // pixel value from Hive2
    wire [7:0] H3dout;      // pixel value from Hive3
    wire [7:0] H4dout;      // pixel value from Hive4
    HiveSprites HDisplay (.xx(x),.yy(y),.aactive(active),
                          .H1SpriteOn(Hive1SpriteOn),.H2SpriteOn(Hive2SpriteOn),
                          .H3SpriteOn(Hive3SpriteOn),.H4SpriteOn(Hive4SpriteOn),
                          .H1dataout(H1dout),.H2dataout(H2dout),
                          .H3dataout(H3dout),.H4dataout(H4dout),
                          .Pclk(PixCLK));
  
    // load colour palette
    reg [7:0] palette [0:191];  // 8 bit values from the 192 hex entries in the colour palette
//    reg [10:0] palette_foam2 [0:1223];
    reg [12:0] palette_drive [0:576];
    reg [12:0] palette_foam [0:576];
    reg [12:0] palette_jane [0:576];
    reg [12:0] palette_porsche [0:576];
    reg [12:0] palette_tien [0:576];
    reg [12:0] palette_undertale [0:576];    
    reg [12:0] palette_press [0:576];
    reg [12:0] palette_heart [0:224];



    reg [7:0] COL = 0;          // background colour palette value
    initial begin
        $readmemh("pal24bit.mem", palette); // load 192 hex values into "palette"
        $readmemh("drive356x12_pal24bit.mem", palette_drive); // load 192 hex values into "palette"
        $readmemh("foam356x12_pal24bit.mem", palette_foam); // load 192 hex values into "palette"
        $readmemh("porsche356x12_pal24bit.mem", palette_porsche); // load 192 hex values into "palette"
        $readmemh("tien356x12_pal24bit.mem", palette_tien); // load 192 hex values into "palette"
        $readmemh("jane356x12_pal24bit.mem", palette_jane); // load 192 hex values into "palette"
        $readmemh("undertale408x53_pal24bit.mem", palette_undertale); // load 192 hex values into "palette"
        $readmemh("press168x12_pal24bit.mem", palette_press); // load 192 hex values into "palette"
        $readmemh("heart15_pal24bit.mem", palette_heart); // load 192 hex values into "palette"


//        $readmemh("introPage640x480_pal24bit.mem", intro_palette); // load 192 hex values into "palette"
    end

    // draw on the active area of the screen
    always @ (posedge PixCLK)
    begin
//    if (state_game==2)
//        begin
//        if(active)
//        begin
//            if(introOn == 1)
//            begin
//            RED <= (intro_palette[(introout*3)])>>4;        
//            GREEN <= (intro_palette[(introout*3)+1])>>4;     
//            BLUE <= (intro_palette[(introout*3)+2])>>4;
//            end  
//        end
//    end    
//    else
    if(state_game==2)
    begin
        if(active)
        begin
            if (TSpriteOn==1)
                    begin
                        RED <= (palette_undertale[(T_dataout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette_undertale[(T_dataout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_undertale[(T_dataout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
            else
            if (CNameSpriteOn==1)
                    begin
                        RED <= (palette_tien[(CN_dataout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette_tien[(CN_dataout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_tien[(CN_dataout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
            else
            if (JNameSpriteOn==1)
                    begin
                        RED <= (palette_jane[(JN_dataout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette_jane[(JN_dataout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_jane[(JN_dataout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
            else
            if (TNameSpriteOn==1)
                    begin
                        RED <= (palette_drive[(TN_dataout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette_drive[(TN_dataout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_drive[(TN_dataout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
            else
            if (FNameSpriteOn==1)
                    begin
                        RED <= (palette_foam[(FN_dataout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette_foam[(FN_dataout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_foam[(FN_dataout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
            else
            if (PNameSpriteOn==1)
            
                    begin
                        RED <= (palette_porsche[(PN_dataout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette_porsche[(PN_dataout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_porsche[(PN_dataout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
            else
            if (PressSpriteOn==1)
                    begin
                        RED <= (palette_press[(Press_dataout*3)])>>4;          // RED bits(7:4) from colour palette
                        GREEN <= (palette_press[(Press_dataout*3)+1])>>4;      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_press[(Press_dataout*3)+2])>>4;       // BLUE bits(7:4) from colour palette
                    end
            
        end
        else
                begin
                    RED <= 0;   // set RED, GREEN & BLUE
                    GREEN <= 0; // to "0" when x,y outside of
                    BLUE <= 0;  // the active display area
                end
        
        
    end
    else
    if (state_game==3)
        begin
        if(active)
        begin
            if (characterOn==1)
                    begin
                        RED <= (palette[(dout*3)]>>4);          // RED bits(7:4) from colour palette
                        GREEN <= (palette[(dout*3)+1]>>4);      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(dout*3)+2]>>4);       // BLUE bits(7:4) from colour palette
                    end   
            else
                  begin
                      RED <= (palette[(COL*3)])>>4;           // RED bits(7:4) from colour palette
                      GREEN <= (palette[(COL*3)+1])>>4;       // GREEN bits(7:4) from colour palette
                      BLUE <= (palette[(COL*3)+2])>>4;        // BLUE bits(7:4) from colour palette
                 end              

        end
    end    
    else
    if(state_game==0)
        begin
        if (active)
            begin
                if (characterOn==1)
                    begin
                        RED <= (palette[(dout*3)]>>4);          // RED bits(7:4) from colour palette
                        GREEN <= (palette[(dout*3)+1]>>4);      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(dout*3)+2]>>4);       // BLUE bits(7:4) from colour palette
                    end
                else
                if (HSpriteOn==1)
                    begin
                        RED <= (palette_heart[(heart_dataout*3)]>>4);         // RED bits(7:4) from colour palette
                        GREEN <= (palette_heart[(heart_dataout*3)+1]>>4);      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette_heart[(heart_dataout*3)+2]>>4);     // BLUE bits(7:4) from colour palette
                    end
                else
                if (BorderSpriteOn==1) 
                    begin              
                      RED<=4'b1111;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b1111;
                    end 
                else
                if (GreenBulletSpriteOn==1) 
                    begin              
                      RED<=4'b0000;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b0000;
                    end   
                else
                if (BulletSpriteOn==1) 
                    begin              
                      RED<=4'b1111;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b1111;
                    end 
                else
                if (BulletSpriteOn2==1) 
                    begin              
                      RED<=4'b1111;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b1111;
                    end
                else
                if (ObstacleSpriteOn==1) 
                    begin              
                      RED<=4'b1111;  
                      GREEN <=4'b1111;
                      BLUE <= 4'b1111;
                    end
                else
                if (hp_barOn==1)
                    begin
                        RED <= 4'b0000;          // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111;      // GREEN bits(7:4) from colour palette
                        BLUE <= 4'b0000;       // BLUE bits(7:4) from colour palette
                    end 
                else
                if (hp_monster_barOn==1)
                    begin
                        RED <= 4'b1101;          // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111;      // GREEN bits(7:4) from colour palette
                        BLUE <= 4'b0000;       // BLUE bits(7:4) from colour palette
                    end    
                                           
                else
                  begin
                      RED <= (palette[(COL*3)])>>4;           // RED bits(7:4) from colour palette
                      GREEN <= (palette[(COL*3)+1])>>4;       // GREEN bits(7:4) from colour palette
                      BLUE <= (palette[(COL*3)+2])>>4;        // BLUE bits(7:4) from colour palette
                 end
            end
        else
                begin
                    RED <= 0;   // set RED, GREEN & BLUE
                    GREEN <= 0; // to "0" when x,y outside of
                    BLUE <= 0;  // the active display area
                end
         end
         else
         if(state_game==1)
         begin
         if (active)
            begin
                if (characterOn==1)
                    begin
                        RED <= (palette[(dout*3)]>>4);          // RED bits(7:4) from colour palette
                        GREEN <= (palette[(dout*3)+1]>>4);      // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(dout*3)+2]>>4);       // BLUE bits(7:4) from colour palette
                    end
                else
                if (pangyatabOn2==1)
                    begin
                        RED <= 4'b1111;          // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111;      // GREEN bits(7:4) from colour palette
                        BLUE <= 4'b1111;       // BLUE bits(7:4) from colour palette
                    end 
                else
                if (pangyatabOn==1)
                    begin
                        RED <= pangyatab_color [11:8];          // RED bits(7:4) from colour palette
                        GREEN <= pangyatab_color [7:4];      // GREEN bits(7:4) from colour palette
                        BLUE <= pangyatab_color [3:0];       // BLUE bits(7:4) from colour palette
                    end 
                else
                if (hp_barOn==1)
                    begin
                        RED <= 4'b0000;          // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111;      // GREEN bits(7:4) from colour palette
                        BLUE <= 4'b0000;       // BLUE bits(7:4) from colour palette
                    end 
                else
                if (hp_monster_barOn==1)
                    begin
                        RED <= 4'b1101;          // RED bits(7:4) from colour palette
                        GREEN <= 4'b1111;      // GREEN bits(7:4) from colour palette
                        BLUE <= 4'b0000;       // BLUE bits(7:4) from colour palette
                    end   
                else
                  begin
                      RED <= (palette[(COL*3)])>>4;           // RED bits(7:4) from colour palette
                      GREEN <= (palette[(COL*3)+1])>>4;       // GREEN bits(7:4) from colour palette
                      BLUE <= (palette[(COL*3)+2])>>4;        // BLUE bits(7:4) from colour palette
                 end                       
            end
        else
                begin
                    RED <= 0;   // set RED, GREEN & BLUE
                    GREEN <= 0; // to "0" when x,y outside of
                    BLUE <= 0;  // the active display area
                end
         end       
    end
    always @ (posedge PixCLK)
    begin
    if(state_game==0)
    begin
        if(HSpriteOn == 1 && BulletSpriteOn==1 && collision_onceB1==0)
                begin
                    isCollisionB1 = 1;
                    collision_onceB1 = 1;
                end
                
        if(HSpriteOn == 1 && BulletSpriteOn2==1 && collision_onceB2==0)
                begin
                    isCollisionB2 = 1;
                    collision_onceB2 = 1;
                end
        if(HSpriteOn == 1 && GreenBulletSpriteOn==1 && collision_onceGB==0)
                begin
                    isCollisionGB = 1;
                    collision_onceGB = 1;
                end
        if(HSpriteOn == 1 && ObstacleSpriteOn==1 && collision_onceBig==0)
                begin
                    isCollisionBig = 1;
                    collision_onceBig = 1;
                end
  
    end
    else
    begin
        isCollisionB1 = 0;
        collision_onceB1 = 0;
        isCollisionB2 = 0;
        collision_onceB2 = 0;
        isCollisionBig = 0;
        collision_onceBig = 0;
    end
    end
    
    
endmodule