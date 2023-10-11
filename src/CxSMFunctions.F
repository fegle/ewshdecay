      SUBROUTINE CxSMEWCorrections(iwhichvs,iwhichpd,iwhichalpha,DE,
     .DLIR,iwarn)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      integer vsscheme,pdprocess,alphascheme,ielwcxsm,stdscheme
      integer NNLOapprox
      integer stdvsscheme,stdpdprocess,stdalphascheme,ChangeScheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision myGF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR,deltaNNLO
      double precision DWh1AA,DWh2AA,DWh1tautau,DWh2tautau,DWh1bb,
     .DWh2bb,DWh2ZZ,DWh2WW,DWh2tt,DWh2h1h1
c MMM changed 8/12/15
      DIMENSION RESCAL(3)
c end MMM changed 8/12/2015
c      logical :: ChangeScheme
      double precision tempexpr
      COMMON/MODCXSM/ISINGLET,ICXSM,rescal,am1cx,am2cx,am3cx
      common/SINGLETPARS/DALPHACX1,DVSCX
      COMMON/PARAM_HDEC/GF,ALPH,AMTAU,AMMUON,AMZ,AMW
      COMMON/MASSES_HDEC/AMS,AMC,AMB,AMT
      COMMON/DELEWCXSM/dh1ll,dh1bb,dh1cc,dh1aa,dh2ll,dh2bb,dh2cc,dh2tt,
     .     dh2aa,dh2zz,dh2ww,dh2h1h1,ielwcxsm
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,myGF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR
      Common/NNLO/deltaNNLO,NNLOapprox
      Common/ParamConversion/ChangeScheme,stdvsscheme,stdpdprocess,stdalphascheme
#include "looptools.h"      
      call ltini
      mW=AMW
      mZ=AMZ
      mt=AMT
      mb=AMB
      mc=AMC
      mtau=AMTAU
      mh1=am1cx
      mh2=am2cx
      mX=am3cx
      myGF=GF
      Talpha=DTan(DALPHACX1)
      vS=DVSCX
      DeltaE=DE
      LambdaIR=DLIR
      vsscheme=iwhichvs
      pdprocess=iwhichpd
      alphascheme=iwhichalpha

      
c       write(*,*)"mW: ", mW
c       write(*,*)"mZ: ", mZ
c       write(*,*)"mt: ", mt
c       write(*,*)"mb: ", mb
c       write(*,*)"mtau: ", mtau
c       write(*,*)"mh1: ", mh1
c       write(*,*)"mh2: ", mh2
c       write(*,*)"mX: ", mX
c       write(*,*)"alpha: ", DALPHACX1
c       write(*,*)"vsscheme: ", vsscheme
c       write(*,*)"pdprocess: ", pdprocess
c       write(*,*)"vsscheme: ", vsscheme
c       write(*,*)"alphascheme: ", alphascheme
c       write(*,*)"LambdaIR: ", LambdaIR
c       write(*,*)"DeltaE: ", DeltaE

c------Change Scheme
c      ChangeScheme=.TRUE.
      if(ChangeScheme.eq.1)then
      write(*,*)"#####"
      write(*,*)"Parameter conversion is activated."
      write(*,*)"Parameters will be converted if chosen scheme is not the input scheme."
      write(*,*)"#####"
      call ChangeRenScheme()
      Talpha=DTan(DALPHACX1)
      vS=DVSCX
      endif
c------end change

c-----include NLO^2 if abs(vs/v/Talpha -1)<=deltaNNLO
      if(NNLOapprox.eq.1)then
      write(*,*)"#####"
      write(*,*)"NLO^2 is activated for the decay h2->h1h1."
      write(*,*)"#####"
c      tempexpr=DAbs(vS*DSQRT(DSQRT(2.D0)*GF)/Talpha -1)
      tempexpr=DAbs(Talpha/(vS*DSQRT(DSQRT(2.D0)*GF)) -1)
c      write(*,*)"tempexpr: ", tempexpr
c      write(*,*)"v: ", 1/DSQRT(DSQRT(2.D0)*GF)
      if(tempexpr.le.deltaNNLO)then
      NNLOapprox=1
      else
      write(*,*)"#####"
      write(*,*)"|tan(alpha)*(v/vs) -1|<=deltaNNLO is not fulfillled for the given parameters!"
      write(*,*)"NNLOapprox is set to 0, the NLO^2 contribution is deactivated."
      write(*,*)"#####"
      NNLOapprox=0
      endif
      endif
c-----end


      dh1ll=0
      dh1bb=0
      dh1aa=0
      dh2ll=0
      dh2bb=0
      dh2tt=0
      dh2aa=0
      dh2zz=0
      dh2ww=0
      dh2h1h1=0
      if(ielwcxsm.eq.1)then
      if(vsscheme.eq.1.and.pdprocess.eq.1.and.mh1/2.D0.le.mX)then
      write(*,*)"#####"
      write(*,*) "h1 cannot decay into DM DM, kinematically not possible! Cannot use process dependent Scheme! EW corrections are set to zero."
      write(*,*)"#####"
      elseif(vsscheme.eq.1.and.pdprocess.eq.2.and.mh2/2.D0.le.mX)then
      write(*,*)"#####"
      write(*,*) "h2 cannot decay into DM DM, kinematically not possible! Cannot use process dependent Scheme! EW corrections are set to zero."
      write(*,*)"#####"
      else
      
      write(*,*)"#####"
      write(*,*) "If decay is kinematically not allowed, EW correction will be set to zero."
      write(*,*)"#####"
      if(mh1/2.D0.gt.mtau) then
      dh1ll=DWh1tautau(2)/DWh1tautau(1) -1
      
      if(dh1ll.le.-1)then
      dh1ll=0
      iwarn=1
      endif
      
      endif
      
      if(mh1/2.D0.gt.mb) then
      dh1bb=DWh1bb(2)/DWh1bb(1) -1
      if(dh1bb.le.-1)then
      dh1bb=0
      iwarn=1
      endif
      
      endif
      
      if(mh1/2.D0.gt.mc) then
      dh1cc=DWh1cc(2)/DWh1cc(1) -1
      if(dh1cc.le.-1)then
      dh1cc=0
      iwarn=1
      endif

      endif

      if(mh1/2.D0.gt.mX) then
      dh1aa=DWh1AA(2)/DWh1AA(1) -1
      if(dh1aa.le.-1)then
      dh1aa=0
      iwarn=1
      endif
      
      endif
      
      if(mh2/2.D0.gt.mtau) then
      dh2ll=DWh2tautau(2)/DWh2tautau(1) -1
      
      if(dh2ll.le.-1)then
      dh2ll=0
      iwarn=1
      endif
      
      endif
      
      if(mh2/2.D0.gt.mb) then
      dh2bb=DWh2bb(2)/DWh2bb(1) -1
      
      if(dh2bb.le.-1)then
      dh2bb=0
      iwarn=1
      endif
      
      endif

      if(mh2/2.D0.gt.mc) then
      dh2cc=DWh2cc(2)/DWh2cc(1) -1
      if(dh2cc.le.-1)then
      dh2cc=0
      iwarn=1
      endif

      endif
      
      if(mh2/2.D0.gt.mt) then
      dh2tt=DWh2tt(2)/DWh2tt(1) -1
      
      if(dh2tt.le.-1)then
      dh2tt=0
      iwarn=1
      endif
      
      endif
      
      if(mh2/2.D0.gt.mX) then
      dh2aa=DWh2AA(2)/DWh2AA(1) -1
      if(dh2aa.le.-1)then
      dh2aa=0
      iwarn=1
      endif
      
      endif
      
      if(mh2/2.D0.gt.mZ) then
      dh2zz=DWh2ZZ(2)/DWh2ZZ(1) -1
      
      if(dh2zz.le.-1)then
      dh2zz=0
      iwarn=1
      endif
      
      endif
      
      if(mh2/2.D0.gt.mW) then
      dh2ww=DWh2WW(2)/DWh2WW(1) -1
      
      if(dh2ww.le.-1)then
      dh2ww=0
      iwarn=1
      endif
      
      endif
      
      if(mh2/2.D0.gt.mh1) then
      dh2h1h1=DWh2h1h1(2)/DWh2h1h1(1) -1
      
      if(dh2h1h1.le.-1)then
      dh2h1h1=0
      iwarn=1
      endif
      
      endif
      
      endif
c       write(*,*)"TEST OUTPUT: "
c       write(*,*)"dh1ll : ", dh1ll
c       write(*,*)"dh1bb : ", dh1bb
c       write(*,*)"dh1aa : ", dh1aa
c       write(*,*)"dh2ll : ", dh2ll
c       write(*,*)"dh2bb : ", dh2bb
c       write(*,*)"dh2tt : ", dh2tt
c       write(*,*)"dh2aa : ", dh2aa
c       write(*,*)"dh2zz : ", dh2zz
c       write(*,*)"dh2ww : ", dh2ww
c       write(*,*)"dh2h1h1 : ", dh2h1h1
      
      if(dh1ll.gt.1.or.dh1bb.gt.1.or.dh1aa.gt.1.or.dh2ll.gt.1.or.
     .dh2bb.gt.1.or.dh2tt.gt.1.or.dh2aa.gt.1.or.dh2zz.gt.1.or.
     .dh2ww.gt.1.or.dh2h1h1.gt.1)then
      write(*,*)"#####"
      write(*,*)"Attention! 1 one of the ELW correction is bigger than 100%!"
      write(*,*)"#####"
      endif
      endif
      
      call ltexi
      RETURN
      END

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine ChangeRenScheme()
      implicit none
      double precision ddalphapstar,ddalphaOS,ddvSh1AApdOS,
     .ddvSh2AApdOS,ddvSh1AApdpstar,ddvSh2AApdpstar,
     .ddvSh1AAZEMOS,ddvSh2AAZEMOS,ddvSh1AAZEMpstar,
     .ddvSh2AAZEMpstar
      integer vsscheme,pdprocess,alphascheme
      integer stdvsscheme,stdpdprocess,stdalphascheme,ChangeScheme
      double precision ddalphastd,ddvSstd
      double precision ddalphanew,ddvSnew
      double precision DALPHACX1,DVSCX
      double precision mh1,mh2,mX,vS,Talpha
      Character(len = 20) :: outputscheme,chosenscheme
      character(len=7), dimension(2) :: vsname,processname,alphaname
      CHARACTER(100) :: filenamein,dirout
      logical DEBUGOUTPUT
      COMMON/DEBUG/DEBUGOUTPUT
c-----CommandlineInput
      Common/Commandline/filenamein,dirout
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      common/SINGLETPARS/DALPHACX1,DVSCX
      Common/ParamConversion/ChangeScheme,stdvsscheme,stdpdprocess,stdalphascheme
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
c       if(DAbs(mh1-125.09).lt.0.1)then
c       stdscheme=1
c       else
c       stdscheme=2
c       endif
c        stdscheme=1
      vsname=(/"OSproc ","ZEMproc"/)
      processname=(/"1-","2-"/)
      alphaname=(/"OS","p*"/)
c      stdvsscheme=2
c      stdpdprocess=2
c     stdalphascheme=1
      outputscheme=trim(vsname(stdvsscheme)) // trim(processname(stdpdprocess)) // trim(alphaname(stdalphascheme))
      chosenscheme=trim(vsname(vsscheme)) // trim(processname(pdprocess)) // trim(alphaname(alphascheme))
      if(vsscheme.ne.stdvsscheme.OR.pdprocess.ne.stdpdprocess.OR.alphascheme.ne.stdalphascheme)then
      write(*,*)"#####"
      write(*,"(3A)")"The chosen renormalization scheme (",trim(chosenscheme),") is not the input",
     ."renormalization scheme (",trim(outputscheme),"). Thus, the input parameters have to be converted."
      write(*,*)"#####"

      if(stdvsscheme.eq.1.and.stdpdprocess.eq.1.and.mh1.lt.2*mX)then
            write(*,*)"#####"
            write(*,*)"Cannot use the Standard input scheme!"
            write(*,*)"The decay h1->AA ist not allowed, use another standard scheme."
            write(*,*)"#####"
      elseif(stdvsscheme.eq.1.and.stdpdprocess.eq.2.and.mh2.lt.2*mX)then
            write(*,*)"#####"
            write(*,*)"Cannot use the Standard input scheme!"
            write(*,*)"The decay h2->AA ist not allowed, use another standard scheme."
            write(*,*)"#####"
      elseif(vsscheme.eq.1.and.pdprocess.eq.1.and.mh1.lt.2*mX)then
            write(*,*)"#####"
            write(*,*)"Cannot use the new input scheme!"
            write(*,*)"The decay h1->AA ist not allowed, use another scheme to convert to."
            write(*,*)"#####"
      elseif(vsscheme.eq.1.and.pdprocess.eq.2.and.mh2.lt.2*mX)then
            write(*,*)"#####"
            write(*,*)"Cannot use the new input scheme!"
            write(*,*)"The decay h2->AA ist not allowed, use another scheme to convert to."
            write(*,*)"#####"
      else

      if(stdvsscheme.eq.1)then
        if(stdpdprocess.eq.1)then
            if(stdalphascheme.eq.1)then
                ddalphastd=ddalphaOS()
                ddvSstd=ddvSh1AApdOS()
            elseif(stdalphascheme.eq.2)then
                ddalphastd=ddalphapstar()
                ddvSstd=ddvSh1AApdpstar()
            endif
        elseif(stdpdprocess.eq.2)then
            if(stdalphascheme.eq.1)then
                ddalphastd=ddalphaOS()
                ddvSstd=ddvSh2AApdOS()
            elseif(stdalphascheme.eq.2)then
                ddalphastd=ddalphapstar()
                ddvSstd=ddvSh2AApdpstar()
            endif
        endif
      elseif(stdvsscheme.eq.2)then
        if(stdpdprocess.eq.1)then
            if(stdalphascheme.eq.1)then
                ddalphastd=ddalphaOS()
                ddvSstd=ddvSh1AAZEMOS()
            elseif(stdalphascheme.eq.2)then
                ddalphastd=ddalphapstar()
                ddvSstd=ddvSh1AAZEMpstar()
            endif
        elseif(stdpdprocess.eq.2)then
            if(stdalphascheme.eq.1)then
                ddalphastd=ddalphaOS()
                ddvSstd=ddvSh2AAZEMOS()
            elseif(stdalphascheme.eq.2)then
                ddalphastd=ddalphapstar()
                ddvSstd=ddvSh2AAZEMpstar()
            endif
        endif
      endif


      if(vsscheme.eq.1)then
        if(pdprocess.eq.1)then
            if(alphascheme.eq.1)then
                ddalphanew=ddalphaOS()
                ddvSnew=ddvSh1AApdOS()
            elseif(alphascheme.eq.2)then
                ddalphanew=ddalphapstar()
                ddvSnew=ddvSh1AApdpstar()
            endif
        elseif(pdprocess.eq.2)then
            if(alphascheme.eq.1)then
                ddalphanew=ddalphaOS()
                ddvSnew=ddvSh2AApdOS()
            elseif(alphascheme.eq.2)then
                ddalphanew=ddalphapstar()
                ddvSnew=ddvSh2AApdpstar()
            endif
        endif
      elseif(vsscheme.eq.2)then
        if(pdprocess.eq.1)then
            if(alphascheme.eq.1)then
                ddalphanew=ddalphaOS()
                ddvSnew=ddvSh1AAZEMOS()
            elseif(alphascheme.eq.2)then
                ddalphanew=ddalphapstar()
                ddvSnew=ddvSh1AAZEMpstar()
            endif
        elseif(pdprocess.eq.2)then
            if(alphascheme.eq.1)then
                ddalphanew=ddalphaOS()
                ddvSnew=ddvSh2AAZEMOS()
            elseif(alphascheme.eq.2)then
                ddalphanew=ddalphapstar()
                ddvSnew=ddvSh2AAZEMpstar()
            endif
        endif
      endif

      DALPHACX1= DALPHACX1 +ddalphastd - ddalphanew
      DVSCX= DVSCX +ddvSstd - ddvSnew
      write(*,*)"#####"
      write(*,*)"New converted input values (see also Paramconversion.txt):"
      write(*,*)"alpha: ", DALPHACX1
      write(*,*)"vS: ", DVSCX
      write(*,*)"#####"

      endif
      endif
      if(DEBUGOUTPUT)then
      OPEN(11,FILE=trim(dirout) // 'TestChangeScheme.txt')
      write(11,*)"ddalphaOS     ddalphapstar     ddvSh1AApdOS     ddvSh1AApdpstar     ",
     ."ddvSh2AApdOS     ddvSh2AApdpstar     ddvSh1AAZEMOS     ddvSh1AAZEMpstar     ",
     ."ddvSh2AAZEMOS     ddvSh2AAZEMpstar"
      write(11,*)ddalphaOS(),ddalphapstar(),ddvSh1AApdOS(),ddvSh1AApdpstar(),
     .ddvSh2AApdOS(),ddvSh2AApdpstar(),ddvSh1AAZEMOS(),ddvSh1AAZEMpstar(),
     .ddvSh2AAZEMOS(),ddvSh2AAZEMpstar()
      close(11)
      endif
      OPEN(11,FILE=trim(dirout) // 'Paramconversion.txt')
      write(11,*)"alpha     vs"
      write(11,*)DALPHACX1,DVSCX
      close(11)
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh1AA(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh1AApd1OS,DWNLOh1AApd1pstar,DWNLOh1AApd2OS,
     .DWNLOh1AApd2pstar,DWNLOh1AAZEM1OS,DWNLOh1AAZEM1pstar,
     .DWNLOh1AAZEM2OS,DWNLOh1AAZEM2pstar,DWLOh1AA
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations
      If(order.eq.1)then
        DWh1AA=DWLOh1AA()
      elseif(order.eq.2)then
        If(vsscheme.eq.1)then
            if(pdprocess.eq.1)then
                if(alphascheme.eq.1)then
                    DWh1AA=DWNLOh1AApd1OS()
                elseif(alphascheme.eq.2)then
                    DWh1AA=DWNLOh1AApd1pstar()
                endif
            elseif(pdprocess.eq.2)then
                if(alphascheme.eq.1)then
                    DWh1AA=DWNLOh1AApd2OS()
                elseif(alphascheme.eq.2)then
                    DWh1AA=DWNLOh1AApd2pstar()
                endif
            endif
        elseif(vsscheme.eq.2)then
            if(pdprocess.eq.1)then
                if(alphascheme.eq.1)then
                    DWh1AA=DWNLOh1AAZEM1OS()
                elseif(alphascheme.eq.2)then
                    DWh1AA=DWNLOh1AAZEM1pstar()
                endif
            elseif(pdprocess.eq.2)then
                if(alphascheme.eq.1)then
                    DWh1AA=DWNLOh1AAZEM2OS()
                elseif(alphascheme.eq.2)then
                    DWh1AA=DWNLOh1AAZEM2pstar()
                endif
            endif
        endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2AA(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh2AApd1OS,DWNLOh2AApd1pstar,DWNLOh2AApd2OS,
     .DWNLOh2AApd2pstar,DWNLOh2AAZEM1OS,DWNLOh2AAZEM1pstar,
     .DWNLOh2AAZEM2OS,DWNLOh2AAZEM2pstar,DWLOh2AA
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh2AA=DWLOh2AA()
      elseif(order.eq.2)then
        If(vsscheme.eq.1)then
            if(pdprocess.eq.1)then
                if(alphascheme.eq.1)then
                    DWh2AA=DWNLOh2AApd1OS()
                elseif(alphascheme.eq.2)then
                    DWh2AA=DWNLOh2AApd1pstar()
                endif
            elseif(pdprocess.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2AA=DWNLOh2AApd2OS()
                elseif(alphascheme.eq.2)then
                    DWh2AA=DWNLOh2AApd2pstar()
                endif
            endif
        elseif(vsscheme.eq.2)then
            if(pdprocess.eq.1)then
                if(alphascheme.eq.1)then
                    DWh2AA=DWNLOh2AAZEM1OS()
                elseif(alphascheme.eq.2)then
                    DWh2AA=DWNLOh2AAZEM1pstar()
                endif
            elseif(pdprocess.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2AA=DWNLOh2AAZEM2OS()
                elseif(alphascheme.eq.2)then
                    DWh2AA=DWNLOh2AAZEM2pstar()
                endif
            endif
        endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh1tautau(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh1tautauOS,DWNLOh1tautaupstar,DWLOh1tautau
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh1tautau=DWLOh1tautau()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh1tautau=DWNLOh1tautauOS()
                elseif(alphascheme.eq.2)then
                    DWh1tautau=DWNLOh1tautaupstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2tautau(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh2tautauOS,DWNLOh2tautaupstar,DWLOh2tautau
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh2tautau=DWLOh2tautau()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2tautau=DWNLOh2tautauOS()
                elseif(alphascheme.eq.2)then
                    DWh2tautau=DWNLOh2tautaupstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh1bb(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh1bbOS,DWNLOh1bbpstar,DWLOh1bb
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh1bb=DWLOh1bb()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh1bb=DWNLOh1bbOS()
                elseif(alphascheme.eq.2)then
                    DWh1bb=DWNLOh1bbpstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2bb(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh2bbOS,DWNLOh2bbpstar,DWLOh2bb
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh2bb=DWLOh2bb()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2bb=DWNLOh2bbOS()
                elseif(alphascheme.eq.2)then
                    DWh2bb=DWNLOh2bbpstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh1cc(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh1ccOS,DWNLOh1ccpstar,DWLOh1cc
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR
c     go trough all combinations
      If(order.eq.1)then
        DWh1cc=DWLOh1cc()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh1cc=DWNLOh1ccOS()
                elseif(alphascheme.eq.2)then
                    DWh1cc=DWNLOh1ccpstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2cc(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh2ccOS,DWNLOh2ccpstar,DWLOh2cc
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR
c     go trough all combinations
      If(order.eq.1)then
        DWh2cc=DWLOh2cc()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2cc=DWNLOh2ccOS()
                elseif(alphascheme.eq.2)then
                    DWh2cc=DWNLOh2ccpstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2ZZ(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh2ZZOS,DWNLOh2ZZpstar,DWLOh2ZZ
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh2ZZ=DWLOh2ZZ()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2ZZ=DWNLOh2ZZOS()
                elseif(alphascheme.eq.2)then
                    DWh2ZZ=DWNLOh2ZZpstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2WW(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh2WWOS,DWNLOh2WWpstar,DWLOh2WW
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh2WW=DWLOh2WW()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2WW=DWNLOh2WWOS()
                elseif(alphascheme.eq.2)then
                    DWh2WW=DWNLOh2WWpstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2tt(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR
      double precision DWNLOh2ttOS,DWNLOh2ttpstar,DWLOh2tt
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR      
c     go trough all combinations      
      If(order.eq.1)then
        DWh2tt=DWLOh2tt()
      elseif(order.eq.2)then
                if(alphascheme.eq.1)then
                    DWh2tt=DWNLOh2ttOS()
                elseif(alphascheme.eq.2)then
                    DWh2tt=DWNLOh2ttpstar()
                endif
      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function DWh2h1h1(order)
      implicit none
      integer order,vsscheme,pdprocess,alphascheme
      integer NNLOapprox
      double precision mW,mZ,mt,mb,mc,mtau
      double precision GF
      double precision mh1,mh2,mX,vS,Talpha
      double precision DeltaE,LambdaIR,deltaNNLO
      double precision DWNLOh2h1h1pd1OS,DWNLOh2h1h1pd1pstar,
     .DWNLOh2h1h1pd2OS,DWNLOh2h1h1pd2pstar,DWNLOh2h1h1ZEM1OS,
     .DWNLOh2h1h1ZEM1pstar,DWNLOh2h1h1ZEM2OS,DWNLOh2h1h1ZEM2pstar,
     .DWLOh2h1h1
      double precision DWNNLOapproxh2h1h1pd1OS,
     .DWNNLOapproxh2h1h1pd1pstar,DWNNLOapproxh2h1h1pd2OS,
     .DWNNLOapproxh2h1h1pd2pstar,DWNNLOapproxh2h1h1ZEM1OS,
     .DWNNLOapproxh2h1h1ZEM1pstar,DWNNLOapproxh2h1h1ZEM2OS,
     .DWNNLOapproxh2h1h1ZEM2pstar
      Common/CxSMFlags/vsscheme,pdprocess,alphascheme
      Common/SMValues/mW,mZ,mt,mb,mc,mtau,GF
      Common/CxSMValues/mh1,mh2,mX,vS,Talpha
      Common/IRValues/DeltaE,LambdaIR
      Common/NNLO/deltaNNLO,NNLOapprox
c     go trough all combinations      
      If(order.eq.1)then
        DWh2h1h1=DWLOh2h1h1()
      elseif(order.eq.2)then
        if(NNLOapprox.eq.0)then
            If(vsscheme.eq.1)then
                if(pdprocess.eq.1)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNLOh2h1h1pd1OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNLOh2h1h1pd1pstar()
                    endif
                elseif(pdprocess.eq.2)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNLOh2h1h1pd2OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNLOh2h1h1pd2pstar()
                    endif
                endif
            elseif(vsscheme.eq.2)then
                if(pdprocess.eq.1)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNLOh2h1h1ZEM1OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNLOh2h1h1ZEM1pstar()
                    endif
                elseif(pdprocess.eq.2)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNLOh2h1h1ZEM2OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNLOh2h1h1ZEM2pstar()
                    endif
                endif
            endif
        elseif(NNLOapprox.eq.1)then
            If(vsscheme.eq.1)then
                if(pdprocess.eq.1)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNNLOapproxh2h1h1pd1OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNNLOapproxh2h1h1pd1pstar()
                    endif
                elseif(pdprocess.eq.2)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNNLOapproxh2h1h1pd2OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNNLOapproxh2h1h1pd2pstar()
                    endif
                endif
            elseif(vsscheme.eq.2)then
                if(pdprocess.eq.1)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNNLOapproxh2h1h1ZEM1OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNNLOapproxh2h1h1ZEM1pstar()
                    endif
                elseif(pdprocess.eq.2)then
                    if(alphascheme.eq.1)then
                        DWh2h1h1=DWNNLOapproxh2h1h1ZEM2OS()
                    elseif(alphascheme.eq.2)then
                        DWh2h1h1=DWNNLOapproxh2h1h1ZEM2pstar()
                    endif
                endif
            endif
        endif
      endif
c      IF(DWh2h1h1.lt.0)then
c      write(*,*)"Careful, NLO contribution is negative!"
c      endif
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


