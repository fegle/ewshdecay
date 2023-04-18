OBJS = src/hdecay.o src/haber.o src/feynhiggs.o src/hsqsq.o src/susylha.o src/hgaga.o src/dmb.o \
       src/elw.o src/hgg.o src/h2hh.o src/decayCxSM.o src/CxSMFunctions.o src/ChangeScheme.o

#Set this LOOPTOOLS Flag to a path to a local LoopTools installation
LOOPTOOLS=/path/to/LOOPTOOLS/

FC=gfortran
FFLAGS = -ffixed-line-length-none


.f.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.f -o $*.o
	
.F.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.F -o $*.o

cxsmhdecay: $(OBJS)
	$(FC) $(FFLAGS) $(OBJS) $(LIBS) -L$(LOOPTOOLS)/lib64 -looptools -o cxsmhdecay

clean:
	rm -f $(OBJS)
