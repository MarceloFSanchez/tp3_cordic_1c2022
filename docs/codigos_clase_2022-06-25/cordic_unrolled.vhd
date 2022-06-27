library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity cordic_unrolled is
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
end cordic_unrolled;

architecture behavioral of cordic_unrolled is

    constant CLOG2N : natural := natural(ceil(log2(real(N))));

    signal count : unsigned(CLOG2N-1 downto 0);



    CORDIC_UNROLLED: for N in range generate
        CORDIC_BASE: work.cordic_base(behavioral)
        generic(
            N <= N, 
            CLOG2N <= CLOG2N
        );
        port(
            num_iter <= count;
            rot0_vec1: in std_logic;
            x_i : in std_logic_vector(N-1 downto 0);
            y_i : in std_logic_vector(N-1 downto 0);
            z_i : in std_logic_vector(N-1 downto 0);
            atan_2mi in std_logic_vector(N-2 downto 0);
            x_ip1 : out std_logic_vector(N-1 downto 0);
            y_ip1 : out std_logic_vector(N-1 downto 0);
            z_ip1 : out std_logic_vector(N-1 downto 0)      
        );
    end generate CORDIC_UNROLLED;

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









end behavioral