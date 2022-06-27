library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity cordic_iter is
    generic(
        N : natural := 16; -- cantidad de iteraciones que va a hacer el algoritmo
    );
    port(
        clk: in std_logic;
        rst: in std_logic;
        req: in std_logic;
        ack: out std_logic;
        rot0_vec1: in std_logic;
        x_0 : in std_logic_vector(N-1 downto 0);
        y_0 : in std_logic_vector(N-1 downto 0);
        z_0 : in std_logic_vector(N-1 downto 0);
        x_nm1 : out std_logic_vector(N-1 downto 0);
        y_nm1 : out std_logic_vector(N-1 downto 0);
        z_nm1 : out std_logic_vector(N-1 downto 0)       
    );
end cordic_iter;

architecture behavioral of cordic_iter is

    constant CLOG2N : natural := natural(ceil(log2(real(N))));

    signal count : unsigned(CLOG2N-1 downto 0);
    signal x_i,y_i,z_i : std_logic_vector(N-1 downto 0);
    signal x_ip1,y_ip1,z_ip1 : std_logic_vector(N-1 downto 0);
    signal atan_2mi:  std_logic_vector(N-3 downto 0);


    ROM: work.atan_rom(behavioral)
        generic map(
            ADD_W  <= CLOG2N,
            DATA_W <= N-2
        )
        port map(
            addr_i <= count,
            data_o <= atan_2mi
        );


    CORDIC_BASE: work.cordic_base(behavioral)
    generic map(
        N <= N, 
        CLOG2N <= CLOG2N
    )
    port map(
        num_iter <= count;
        rot0_vec1 <= rot0_vec1;
        x_i <= x_i;
        y_i <= y_i;
        z_i <= z_i;
        atan_2mi <= atan_2mi;
        x_ip1 <= x_ip1;
        y_ip1 <= y_ip1;
        z_ip1 <= z_ip1      
    );

    process(clk,rst)
    begin
        if rst = '1' then
            count <= (others => '0');
        elsif clk'event and clk = '1' then
            if req = '1' then 
                count <= (others => '0');
            elsif count /= N-1 then
                count <= count + 1;
            end if;
        end if;
    end process;

    ack <= '1' when  count = N-1 else
           '0';

    process(clk,rst)
    begin
        if rst = '1' then
            x_i <= (others => '0');
            y_i <= (others => '0');
            z_i <= (others => '0');
        elsif clk'event and clk = '1' then
            if req = '1' then 
                x_i <= x_0;
                y_i <= y_0;
                z_i <= z_0; 
            else 
                x_i <= x_ip1;
                y_i <= y_ip1;
                z_i <= z_ip1;     
            end if;
        end if;
    end process;







end behavioral