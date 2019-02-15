if [ 1 -eq 0 ]; then
	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/sequentialSimpleAdd.v" >> system.prj
	echo "verilog work app/sequentialSimpleAddApp.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/sequentialSimpleAdd.v" >> collateral/system.prj
	echo "verilog work app/sequentialSimpleAddApp.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/sequentialSimpleAdd/
	cp OUT_* results/sequentialSimpleAdd/
	cp system_map.mrp results/sequentialSimpleAdd/

	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/partialParallelSimpleAdd.v" >> system.prj
	echo "verilog work app/partialParallelSimpleAddApp.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/partialParallelSimpleAdd.v" >> collateral/system.prj
	echo "verilog work app/partialParallelSimpleAddApp.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/partialParallelSimpleAdd/
	cp OUT_* results/partialParallelSimpleAdd/
	cp system_map.mrp results/partialParallelSimpleAdd/

	mkdir -p results/partialParallel/
	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/parallelSimpleAdd.v" >> system.prj
	echo "verilog work app/parallelSimpleAddApp.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/parallelSimpleAdd.v" >> collateral/system.prj
	echo "verilog work app/parallelSimpleAddApp.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/parallelSimpleAdd/
	cp OUT_* results/parallelSimpleAdd/
	cp system_map.mrp results/parallelSimpleAdd/

	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/sequentialConvolution.v" >> system.prj
	echo "verilog work app/sequentialConvolutionApp.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/sequentialConvolution.v" >> collateral/system.prj
	echo "verilog work app/sequentialConvolutionApp.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/sequentialConvolution/
	cp OUT_* results/sequentialConvolution/
	cp system_map.mrp results/sequentialConvolution/

	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/partialParallel2Convolution.v" >> system.prj
	echo "verilog work app/partialParallel2ConvolutionApp.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/partialParallel2Convolution.v" >> collateral/system.prj
	echo "verilog work app/partialParallel2ConvolutionApp.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/partialParallel2Convolution/
	cp OUT_* results/partialParallel2Convolution/
	cp system_map.mrp results/partialParallel2Convolution/

	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/partialParallel4Convolution.v" >> system.prj
	echo "verilog work app/partialParallel4ConvolutionApp.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/partialParallel4Convolution.v" >> collateral/system.prj
	echo "verilog work app/partialParallel4ConvolutionApp.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/partialParallel4Convolution/
	cp OUT_* results/partialParallel4Convolution/
	cp system_map.mrp results/partialParallel4Convolution/

	echo "verilog work vsrc/*.v" > system.prj
	echo "verilog work app/partialParallel8Convolution.v" >> system.prj
	echo "verilog work app/partialParallel8ConvolutionApp.v" >> system.prj
	echo "verilog work vsrc/*.v" > collateral/system.prj
	echo "verilog work app/partialParallel8Convolution.v" >> collateral/system.prj
	echo "verilog work app/partialParallel8ConvolutionApp.v" >> collateral/system.prj
	make clean
	make
	mkdir -p results/partialParallel8Convolution/
	cp OUT_* results/partialParallel8Convolution/
	cp system_map.mrp results/partialParallel8Convolution/
fi

echo "verilog work vsrc/*.v" > system.prj
echo "verilog work app/downsampleStencilChain1Per64.v" >> system.prj
echo "verilog work app/downsampleStencilChain1Per64App.v" >> system.prj
echo "verilog work vsrc/*.v" > collateral/system.prj
echo "verilog work app/downsampleStencilChain1Per64.v" >> collateral/system.prj
echo "verilog work app/downsampleStencilChain1Per64App.v" >> collateral/system.prj
make clean
make
mkdir -p results/downsampleStencilChain1Per64/
cp OUT_* results/downsampleStencilChain1Per64/
cp system_map.mrp results/downsampleStencilChain1Per64/

echo "verilog work vsrc/*.v" > system.prj
echo "verilog work app/downsampleStencilChain1Per32.v" >> system.prj
echo "verilog work app/downsampleStencilChain1Per32App.v" >> system.prj
echo "verilog work vsrc/*.v" > collateral/system.prj
echo "verilog work app/downsampleStencilChain1Per32.v" >> collateral/system.prj
echo "verilog work app/downsampleStencilChain1Per32App.v" >> collateral/system.prj
make clean
make
mkdir -p results/downsampleStencilChain1Per32/
cp OUT_* results/downsampleStencilChain1Per32/
cp system_map.mrp results/downsampleStencilChain1Per32/
