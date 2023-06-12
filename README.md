# EWsHDECAY

EWsHDECAY is an extension of the code [sHDECAY][] (see *[JHEP06(2016)034]*) which itself is based on [HDECAY][] (see *[Comput.Phys.Commun. 108 (1998) 56]* and
*[Comput.Phys.Commun. 238 (2019) 214]*) version 6.50. For this version of EWsHDECAY, the newest version of HDECAY (version 6.61) was used as a basis, the extension sHDECAY was then implemented into this new version and then the EWsHDECAY expansion was added. Similar to the code sHDECAY, EWsHDECAY computes the Higgs boson decay widths and branching ratios in the RxSM and CxSM including the state-of-the-art QCD corrections and off-shell decays for massive gauge boson and top-pair final states. The new feature of EWsHDECAY is the possibility to additionally calculate for the complex Dark Matter phase of the CxSM the electroweak corrections to the Higgs decays into non-loop induced and on-shell final states.

### Contributors and Citation Guide
The code was written by Felix Egle, Margarete Mühlleitner, Rui Santos and João Viana. If you use EWsHDECAY please cite "Felix Egle, Margarete Mühlleitner, Rui Santos, Joao Viana, *[arXiv:2306.04127]* [hep-ph]."

### The CxSM

The CxSM extends the Standard Model (SM) Higgs sector by a complex singlet field and by adding two separate Z_2 symmetries on the Higgs potential. Depending on whether the Z_2 symmetries are broken we can have a DM particle or not in the spectrum. We consider the complex singlet dark matter phase and compute the next-to-leading order (NLO) electroweak (EW) corrections for all visible Higgs decays into final states that are on-shell and not loop-induced. The user can choose between two different renormalization schemes for the mixing angle alpha of the two visible Higgs bosons and between four different renormalization schemes for the renormalization of the vacuum expectation value vS of the singlet field. We also provide the option to compute the next-to-next-to-leading order correction (NNLO) to the heavy visible Higgs boson h2 decay into a lighter h1 Higgs pair for the parameter configuration with vanishing leading-order (LO) width.

Caveats:

- The NLO EW corrections are only computed for Higgs decays that are on-shell and not loop-induced. Otherwise the LO widths are given out.

- In case the on-shell renormalization for vS is kinematically not allowed, a warning is printed and the LO widths are given out.

- In case the NLO EW corrections are negative and beyond -100% the LO decay widths are given out and a warning is printed.

- The NNLO corrections to h2->h1h1 are exact only for parameter configurations where the LO width vanishes. Otherwise they are only approximate to an extent which cannot be estimated without the full NNLO calculation.

- Be careful when interpreting and comparing the results of different renormalization scheme choices. A proper comparison requires the consistent conversion of the input parameters. This feature can be chosen in the input file.

A detailed description of the model is given in *[]*. When the
code is downloaded an up-to-date pdf version is included in the doc
folder.

### Changes
All changes in the code that affect the results are documented in the CHANGELOG.


### Contributors and Citation Guide
The code was written by Felix Egle, Margarete Mühlleitner, João Viana and Rui Santos. If you use EWsHDECAY please cite *[]*..


### Compilation
In order to compile the code you can use the given Makefile. A Fortran compiler is needed for the compilation. Furthermore, the code uses the program package [LoopTools][] for the calculation of the one-loop integrals. Thus, if the given Makefile is used, the variable *LOOPTOOLS* has to be set to a local installation of LoopTools.
Alternatively, the code can be compiled using 'cmake'. LoopTools will then be downloaded and installed automatically. This can be achieved e.g. by the following commands:

    mkdir build && cd build
    cmake ..
    make
    make test

### Tests
With the last command above (make test) a series of tests are passed through to check if the program was properly installed. It uses the input files in tests/phase"i".in, where "i"=1..7. The different indizes have the following meaning:

- i=1 Test input file for the real broken phase

- i=2 Test input file for the real dark matter phase

- i=3 Test input file for the complex broken phase

- i=4 Test input file for the complex dark matter phase at LO

- i=5 Test input file for the complex dark matter phase at NLO

- i=6 Test input file for the complex dark matter phase at NLO including the approximate NNLO corrections to the h2->h1h1 decay

- i=7 Test input file for the complex dark matter phase at NLO including the parameter conversion between two schemes.

The output is automatically compared to already prepared output files in the /tests/out"i" directories.


### User Instructions
After compiling, an executable called ewshdecay is generated. The input parameters are then specified in a separate input file, a test input file is given as *hdecay.in*, the input should always be given in this format.

The standard input is expected to be named 'hdecay.in' and in the same directory as the executable. Otherwise, the input file can be specified with the flag "-i" as a command line input. Also the output directory can be specified with the "-o" flag, so e.g.

    ./ewshdecay -i myinput.in -o finaloutput/

calls the program with the input parameters given in *myinput.in* and writes everything into the directory *finaloutput/*. The generated output files are called br.phxy. The phase name 'ph' is rb, rd, cb, cd for the real broken, the real dark matter, the complex broken and the complex dark matter phase, respectively. (Only for the latter the electroweak corrections are calculated provided the parameter a1 is set to 0.) The index x refers to the Higgs boson Hx for which the results are given out. The index y refers to the decays which are given out: y=1 fermionic final states, y=2 gauge boson final states + total width, y=3 scalar boson final states.

To change the model and the model parameters, change the values in the input file in the section *real or complex singlet model*.

To change the settings for the electroweak corrections, i.e. the scheme choice for the renormalization and the detector resolution (needed for the regularization of the IR divergences), change the values in the section *EW Corrections*. Please keep in mind that the EW corrections can only be applied for the CxSM in the complex dark matter phase (icxSM=4) with the parameter a1=0.

Additionally, by setting *NNLOapp=1*, the NLO^2 term can be included for the h2->h1h1 decay, since the trilinear h2h1h1 coupling vanishes for vs/v=tan(alpha). In a small interval around this point the NLO^2 contribution can then be turned on, the interval size is defined through the variable *deltaNNLO*.

For a meaningful comparison of the renormalization scheme dependence of the results, the input parameters have to be converted consistently. The parameter conversion can be turned on by setting Paramcon=1 in the input file. The user also has the option then to define the schemes between which the parameters are to be converted. For details, see Ref.

Please feel free to play around with the code and report any bugs or unusual behaviour.


<!--LoopTools reference  -->
[LoopTools]: https://feynarts.de/looptools/

<!-- sHDECAY references -->
[sHDECAY]: https://www.itp.kit.edu/~maggie/sHDECAY/
[JHEP06(2016)034]: https://doi.org/10.1007/JHEP06(2016)034
<!-- HDECAY references -->
[HDECAY]:  http://tiger.web.psi.ch/proglist.html
[Comput.Phys.Commun. 108 (1998) 56]: https://doi.org/10.1016/S0010-4655(97)00123-9
[Comput.Phys.Commun. 238 (2019) 214]: https://doi.org/10.1016/j.cpc.2018.12.010
[arXiv:2306.04127]: https://arxiv.org/abs/2306.04127
