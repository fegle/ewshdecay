# CxSMHDECAY

CxSMHDECAY is an extension of the code [sHDECAY][] (see *[JHEP06(2016)034]*) which itself is based on [HDECAY][] (see *[hep-ph/9704448]* and
*[1801.09506]*) version 6.50. For this version of CxSMHDECAY, the newest version of HDECAY (version 6.61) was used as a basis, the extension sHDECAY was then implemented into this new version and then the CXSMHDECAY expansion was added. CxSMHDECAY is able to calculate the Higgs boson decay widths and branching ratios in the CxSM and it includes the electroweak corrections for the dark phase of the CxSM.

### Contributors and Citation Guide
The code was written by Felix Egle and Margarete Mühlleitner, in collaboration with João Viana and Rui Santos. If you use CxSMHDECAY please cite *[]*..

### Compilation
In order to compile the code you can use the given Makefile. A fortran compiler is needed for the compilation. Furthermore, the code uses the program package [LoopTools][] for the calculation of the one-loop integrals. Thus, if the given Makefile is used, the variable *LOOPTOOLS* has to be set to a local installation of LoopTools.
Alternatively, the code can be compiled using 'cmake'. LoopTools will then be downloaded and installed automatically. This can be achieved e.g. by the following commands:

    mkdir build && cd build
    cmake ..
    make

### User Instructions
After compiling, an executable called cxsmhdecay is generated. The input parameters are then specified in a separate input file, a test input file is given as *hdecay_test.in*, the input should always be given in this format.

The standard input is expected to be './hdecay.in'. Otherwise, the input file can be specified as the first argument, e.g.

    ./cxsmhdecay myinput.in

calls the program with the input parameters given in *myinput.in*.

To change the model and the model parameters, change the values in the section *real or complex singlet Model*.

To change the settings for the elw corrections ,i.e. the scheme choice for renormalization and the detecor resolution (needed for IR renormalization), change the values in the section *EW Corrections*. Please keep in mind that the EW corrections can only be applied for the CxSM with the parameter a1=0.

Additionally, the NLO^2 term can be included for the h2->h1h1 decay, since the trilinear h2h1h1 coupling vanishes for vs/v=tan(alpha). Close to that point the NLO^2 contribution can then be turned on, the interval is defined through the variable *deltaNNLO*.


Please feel free to play around with the code and report any bugs or unusual behaviour.

Best Regards,

Felix


<!-- Below are the links referenced in the text (copied von NHDecay). -->

<!--LoopTools reference  -->
[LoopTools]: https://feynarts.de/looptools/

<!-- sHDECAY references -->
[sHDECAY]: https://www.itp.kit.edu/~maggie/sHDECAY/
[JHEP06(2016)034]: https://doi.org/10.1007/JHEP06(2016)034
<!-- HDECAY references -->
[HDECAY]:  http://tiger.web.psi.ch/proglist.html
[hep-ph/9704448]: http://inspirehep.net/record/442662
[1801.09506]: http://inspirehep.net/record/1650944
