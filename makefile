OBJS = hdecay.o haber.o feynhiggs.o hsqsq.o susylha.o hgaga.o dmb.o \
       elw.o hgg.o h2hh.o decayCxSM.o CxSMFunctions.o

#OBJS = hdecay.o haber.o hsqsq.o

FFLAGS =

LOOPTOOLS=/users/tp/egle/Desktop/programs/LoopTools-2.15/x86_64-Linux

#FFLAGS = -std=gnu

#FFLAGS = -ffpe-trap=invalid,overflow,zero

FC=gfortran -ffixed-line-length-none

#FFLAGS = -fno-emulate-complex -fno-automatic -ffixed-line-length-none -ffast-math -march=pentiumpro -Wall -fno-silent

#FC=g77

#FFLAGS = -fno-emulate-complex -fno-automatic -ffixed-line-length-none -ffast-math -march=pentiumpro -malign-double -Wall -fno-silent

#FFLAGS = -Wall -fno-silent

#FC=f77

#FFLAGS= -pc 64 -g77libs

#FC=pgf77

.f.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.f
	
.F.o:
	$(FC) -c $(FFLAGS) -I$(LOOPTOOLS)/include $*.F

hdecay: $(OBJS)
	$(FC) $(FFLAGS) $(OBJS) $(LIBS) -L$(LOOPTOOLS)/lib64 -looptools -o run

clean:
	rm -f $(OBJS)
