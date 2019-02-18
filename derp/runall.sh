mkdir -p results
rm results/resources_temp.txt
rm results/timing_temp.txt
rm results/overall_results_temp.csv
rm results/resources.txt
rm results/timing.txt
rm results/overall_results.csv

echo "Circuit | Module                                 | Partition | Slices*       | Slice Reg     | LUTs          | LUTRAM        | BRAM/FIFO | DSP48E1 | BUFG  | BUFIO | BUFR  | MMCME2_AD | Full Hierarchical Name                                                                                                                                                                       |" > results/resources_temp.txt

echo "Circuit |        Clock Net    |   Resource   |Locked|Fanout|Net Skew(ns)|Max Delay(ns)|" > results/timing_temp.txt

for circuitName in sequentialSimpleAdd partialParallelSimpleAdd parallelSimpleAdd sequentialConvolution partialParallel2Convolution partialParallel4Convolution partialParallel8Convolution downsampleStencilChain1Per64 downsampleStencilChain1Per32 convolution_32x32Im_2x2Win_1px_in_per_clk convolution_32x32Im_2x2Win_2px_in_per_clk convolution_32x32Im_2x2Win_4px_in_per_clk convolution_32x32Im_2x2Win_8px_in_per_clk downsample_256x256_to_32x32_1px_in_per_clk downsample_256x256_to_32x32_2px_in_per_clk downsample_256x256_to_32x32_4px_in_per_clk downsample_256x256_to_32x32_8px_in_per_clk downsample_256x256_to_32x32_16px_in_per_clk downsample_256x256_to_32x32_32px_in_per_clk downsample_256x256_to_32x32_64px_in_per_clk; do
	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/${circuitName}.v" >> system.prj
	echo "verilog work app/${circuitName}App.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/${circuitName}.v" >> collateral/system.prj
	echo "verilog work app/${circuitName}App.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/${circuitName}/
	cp OUT_* results/${circuitName}/
	cp system_map.mrp results/${circuitName}/

	echo "Processing ${circuitName}"
	printf "${circuitName}" >> results/resources_temp.txt
	grep ++adderCirc results/${circuitName}/system_map.mrp >> results/resources_temp.txt
	printf "${circuitName}" >> results/timing_temp.txt
	grep "FCLK0 |" results/${circuitName}/OUT_par.txt >> results/timing_temp.txt
done
tr -d [:blank:] < results/resources_temp.txt > results/resources.txt
tr -d [:blank:] < results/timing_temp.txt > results/timing.txt
sed -i -s 's/|/,/g' results/resources.txt
sed -i -s 's/|/,/g' results/timing.txt
paste results/resources.txt results/timing.txt > results/overall_results_temp.csv
tr -d [:blank:] < results/overall_results_temp.csv > results/overall_results.csv
sed -ri -s 's/[0-9]+\/([0-9]+)/\1/g' results/overall_results.csv
rm results/resources_temp.txt
rm results/timing_temp.txt
rm results/overall_results_temp.csv

