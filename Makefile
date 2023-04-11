OBJS = src/hdecay.o src/haber.o src/feynhiggs.o src/hsqsq.o src/susylha.o src/hgaga.o src/dmb.o \
       src/elw.o src/hgg.o src/h2hh.o src/decayCxSM.o src/CxSMFunctions.o src/ChangeScheme.o

#OBJS = hdecay.o haber.o hsqsq.o

FFLAGS = -ffixed-line-length-none

LOOPTOOLS=/users/tp/egle/Desktop/programs/LoopTools-2.15/x86_64-Linux

#FFLAGS = -std=gnu

#FFLAGS = -ffpe-trap=invalid,overflow,zero

FC=gfortran

#FFLAGS = -fno-emulate-complex -fno-automatic -ffixed-line-length-none -ffast-math -march=pentiumpro -Wall -fno-silent

#FC=g77

#FFLAGS = -fno-emulate-complex -fno-automatic -ffixed-line-length-none -ffast-math -march=pentiumpro -malign-double -Wall -fno-silent

#FFLAGS = -Wall -fno-silent

#FC=f77

#FFLAGS= -pc 64 -g77libs

#FC=pgf77

.f.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.f -o $*.o
	
.F.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.F -o $*.o

cxsmhdecay: $(OBJS)
	$(FC) $(FFLAGS) $(OBJS) $(LIBS) -L$(LOOPTOOLS)/lib64 -looptools -o cxsmhdecay

clean:
	rm -f $(OBJS)
