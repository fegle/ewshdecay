# EWsHDECAY

EWsHDECAY is an extension of the code [sHDECAY][] (see *[JHEP06(2016)034]*) which itself is based on [HDECAY][] (see *[hep-ph/9704448]* and
*[1801.09506]*) version 6.50. For this version of EWsHDECAY, the newest version of HDECAY (version 6.61) was used as a basis, the extension sHDECAY was then implemented into this new version and then the EWsHDECAY expansion was added. Similar to sHDecay, EWsHDECAY computes the Higgs boson decay widths and branching ratios in the RxSM and CxSM including the state-of-the-art QCD corrections and off-shell decays for massive gauge boson and top-pair final states. The new feature of EWsHDECAY is the possibility to additionally calculate for the complex Dark Matter phase of the CxSM the electroweak corrections to the Higgs decays into non-loop induced and on-shell final states.

### The CxSM

The CxSM extends the Standard Model (SM) Higgs sector by a complex singlet field and by adding two separate Z_2 symmetries on the Higgs potential. Depending on whether the Z_2 symmetries are broken we can have a DM particle or not in the spectrum. We consider the complex singlet dark matter phase and compute the next-to-leading order (NLO) electroweak (EW) corrections for all visible Higgs decays into final states that are on-shell and not loop-induced. The user can choose between two different renormalization schemes for the mixing angle alpha of the two visible Higgs bosons and between four different renormalization schemes for the renormalization of the vacuum expectation value vS of the singlet field. We also provide the option to compute next-to-next-to-leading order correction (NNLO) to the heavy visible Higgs boson h2 decay into a lighter h1 Higgs pair for the parameter configuration with vanishing leading-order (LO) width.

Caveats:

- The NLO EW corrections are only computed for Higgs decays that are on-shell and not loop-induced. Otherwise the LO widths are given out.

- In case the on-shell renormalization for vS is kinematically not allowed, a warning is printed and the LO widths are given out.

- In case the NLO EW corrections are negative and beyond -100% the LO decay widths are given out and a warning is printed.

- The NNLO corrections to h2->h1h1 are exact only for parameter configurations where the LO width vanishes. Otherwise they are only approximate to an extent which cannot be estimated without the full NNLO calculations.

- Be careful when interpreting and comparing the results of different renormalization scheme choices. A proper comparison requires the consistent conversion of the input parameters. This feature can be provided on demand.

A detailed description of the model is given in the manual. When the
code is downloaded an up-to-date pdf version is included in the doc
folder.

### Changes
All changes in the code that affect the results are documented in the CHANGELOG.


### Contributors and Citation Guide
The code was written by Felix Egle, Margarete Mühlleitner, João Viana and Rui Santos. If you use EWsHDECAY please cite *[]*..


### Compilation
In order to compile the code you can use the given Makefile. A fortran compiler is needed for the compilation. Furthermore, the code uses the program package [LoopTools][] for the calculation of the one-loop integrals. Thus, if the given Makefile is used, the variable *LOOPTOOLS* has to be set to a local installation of LoopTools.
Alternatively, the code can be compiled using 'cmake'. LoopTools will then be downloaded and installed automatically. This can be achieved e.g. by the following commands:

    mkdir build && cd build
    cmake ..
    make

### User Instructions
After compiling, an executable called ewshdecay is generated. The input parameters are then specified in a separate input file, a test input file is given as *hdecay_test.in*, the input should always be given in this format.

The standard input is expected to be './hdecay.in'. Otherwise, the input file can be specified with the flag "-i" as a command line input. Also the output directory can be specified with the "-o" flag, so e.g.

    ./ewshdecay -i myinput.in -o finaloutput/

calls the program with the input parameters given in *myinput.in* and writes everything into the directory *finaloutput/*. The generated output files are called br.phxy. The phase name 'ph' is rb, rd, cb, cd for the real broken, the real dark matter, the complex broken and the complex dark matter phase, respectively. (Only for the latter the electroweak corrections are calculated for the parameter a1=0.) The index x refers to the Higgs boson Hx for which the results are given out. The index y refers to the decays which are given out: y=1 fermionic final states, y=2 gauge boson final states + total width, y=3 scalar boson final states.

To change the model and the model parameters, change the values in the section *real or complex singlet Model*.

To change the settings for the elw corrections ,i.e. the scheme choice for renormalization and the detecor resolution (needed for IR renormalization), change the values in the section *EW Corrections*. Please keep in mind that the EW corrections can only be applied for the CxSM in the complex dark matter phase (icxSM=4) with the parameter a1=0.

Additionally, the NLO^2 term can be included for the h2->h1h1 decay, since the trilinear h2h1h1 coupling vanishes for vs/v=tan(alpha). In a small interval around this point the NLO^2 contribution can then be turned on, the interval size is defined through the variable *deltaNNLO*.


Please feel free to play around with the code and report any bugs or unusual behaviour.


<!-- Below are the links referenced in the text (copied von NHDecay). -->

<!--LoopTools reference  -->
[LoopTools]: https://feynarts.de/looptools/

<!-- sHDECAY references -->
[sHDECAY]: https://www.itp.kit.edu/~maggie/sHDECAY/
[JHEP06(2016)034]: https://doi.org/10.1007/JHEP06(2016)034
<!-- HDECAY references -->
[HDECAY]:  http://tiger.web.psi.ch/proglist.html
[hep-ph/9704448]: https://www.sciencedirect.com/science/article/pii/S0010465597001239?via%3Dihub
[1801.09506]: https://www.sciencedirect.com/science/article/abs/pii/S0010465518304260?via%3Dihub
