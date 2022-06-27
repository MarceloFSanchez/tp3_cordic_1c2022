library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_base is
    generic(
        N : natural := 16; -- cantidad de iteraciones que va a hacer el algoritmo
        CLOG2N : natural := 4; -- tamaño del punto fijo
    );
    port(
        num_iter : in unsigned(CLOG2N-1 downto 0);
        rot0_vec1: in std_logic;
        x_i : in std_logic_vector(N-1 downto 0);
        y_i : in std_logic_vector(N-1 downto 0);
        z_i : in std_logic_vector(N-1 downto 0);
        atan_2mi in std_logic_vector(N-3 downto 0);
        x_ip1 : out std_logic_vector(N-1 downto 0);
        y_ip1 : out std_logic_vector(N-1 downto 0);
        z_ip1 : out std_logic_vector(N-1 downto 0)      
    );
end cordic_base;

architecture behavioral of cordic_base is
    signal x_aux,y_aux,z_aux : std_logic_vector(N-1 downto 0);
    signal x_shifted,y_shifted, : std_logic_vector(N-1 downto 0);
    signal x_i,y_i,z_i : std_logic_vector(N-1 downto 0);
    signal di: std_logic;
    signal not_di: std_logic;
    signal sx_atan_2mi: std_logic_vector(N-1 downto 0);


begin

    -- preguntas
    -- esta bien esto del work.adder?
    -- como creo la tabla de rom?
    -- esta bien usar count fuera del process?


    --xi = xaux- (yaux*di)<<i
    x_shifted <= x_aux sra to_integer(count);
    y_shifted <= y_aux sra to_integer(count);

    di <= z_i(N-1) when rot0_vec1 = '0' else
          not y_i(N-1);
    not_di <= not di;

    sumador_x: work.adder(behavioral)
    generic map(WORD_SIZE => N)
    port map(
        x => x_aux,
        y => y_shifted,
        z => x_i,
        add0_sub1 => not_di, 
    );

    sumador_y: work.adder(behavioral)
    generic map(WORD_SIZE => N)
    port map(
        x => y_aux,
        y => x_shifted,
        z => y_i,
        add0_sub1 => d_i,
    );

    sx_atan_2mi <= "00" && atan_2mi;
    
    sumador_z: work.adder(behavioral)
    generic map(WORD_SIZE => N)
    port map(
        x => sx_atan_2mi,
        y => z_aux,
        z => z_i,
        add0_sub1 => not_di,
    );

end behavioral; 