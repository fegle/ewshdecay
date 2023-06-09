OBJS = src/hdecay.o src/haber.o src/feynhiggs.o src/hsqsq.o src/susylha.o src/hgaga.o src/dmb.o \
       src/elw.o src/hgg.o src/h2hh.o src/decayCxSM.o src/CxSMFunctions.o src/ChangeScheme.o

#Set this LOOPTOOLS Flag to a path to a local LoopTools installation
#LOOPTOOLS=/path/to/LOOPTOOLS/
LOOPTOOLS=/users/tp/egle/Desktop/programs/LoopTools-2.15/x86_64-Linux/

FC=gfortran
FFLAGS = -ffixed-line-length-none


.f.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.f -o $*.o
	
.F.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.F -o $*.o

ewshdecay: $(OBJS)
	$(FC) $(FFLAGS) $(OBJS) $(LIBS) -L$(LOOPTOOLS)/lib64 -looptools -o ewshdecay

clean:
	rm -f $(OBJS)
