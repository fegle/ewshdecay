cmake_minimum_required(VERSION 3.1)
project(EWSHDECAY VERSION 1.0.0 LANGUAGES C CXX Fortran)


if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
	set(CMAKE_BUILD_TYPE "RELEASE" CACHE STRING "Choose the type of build.")
	if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
		set(CMAKE_BUILD_TYPE "DEBUG")
	endif()
endif()

#include(CTest)

# -------------------------------- LoopTools --------------------------------
#Shamelessly copied from Lisa Biermann
set(LT_URL "https://feynarts.de/looptools/LoopTools-2.15.tar.gz")
set(LT_DOWNLOAD_TARGET "${CMAKE_BINARY_DIR}/LoopTools-2.15.tar.gz")
set(LT_EXTRACT_TARGET "${CMAKE_BINARY_DIR}/LoopTools-2.15")
file(DOWNLOAD ${LT_URL} ${LT_DOWNLOAD_TARGET})

execute_process(
    COMMAND "${CMAKE_COMMAND}" "-E" "tar" "xz" "${LT_DOWNLOAD_TARGET}"
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    RESULT_VARIABLE LT_EXTRACT_RETURN_VALUE
    )

if (NOT LT_EXTRACT_RETURN_VALUE EQUAL 0)
    message(FATAL_ERROR "Error: ${LT_EXTRACT_RETURN_VALUE}")
endif()

# create clooptools.h
execute_process(
  COMMAND "${CMAKE_COMMAND}" "-E" "cat" "${LT_EXTRACT_TARGET}/src/include/ftypes.h" "${LT_EXTRACT_TARGET}/src/include/clooptools.h.in"
  OUTPUT_FILE "${LT_EXTRACT_TARGET}/src/include/clooptools.h"
)

# fix cache.c
file(WRITE "${LT_EXTRACT_TARGET}/src/util/cache.fixed.c" "#undef NDEBUG\n" "#include \"cache.c\"")

# create LoopTools library, compile sources
set(looptools_path "${CMAKE_BINARY_DIR}/LoopTools-2.15/src")
add_library(LoopTools STATIC)
target_include_directories(LoopTools PUBLIC ${looptools_path}/include)
target_sources(LoopTools PRIVATE
    ${looptools_path}/A/Aget.F
    ${looptools_path}/A/ffca0.F
    ${looptools_path}/A/ffxa0.F
    ${looptools_path}/B/Bcoeff.F
    ${looptools_path}/B/BcoeffAD.F
    ${looptools_path}/B/BcoeffC.F
    ${looptools_path}/B/BcoeffFF.F
    ${looptools_path}/B/Bget.F
    ${looptools_path}/B/ffcb0.F
    ${looptools_path}/B/ffcb1.F
    ${looptools_path}/B/ffcb2p.F
    ${looptools_path}/B/ffcdb0.F
    ${looptools_path}/B/ffcel2.F
    ${looptools_path}/B/ffdel2.F
    ${looptools_path}/B/ffxb0.F
    ${looptools_path}/B/ffxb1.F
    ${looptools_path}/B/ffxb2p.F
    ${looptools_path}/B/ffxdb0.F
    ${looptools_path}/B/ffxdb1.F
    ${looptools_path}/C/C0func.F
    ${looptools_path}/C/C0funcC.F
    ${looptools_path}/C/Cget.F
    ${looptools_path}/C/ffcc0.F
    ${looptools_path}/C/ffcc0p.F
    ${looptools_path}/C/ffcel3.F
    ${looptools_path}/C/ffdel3.F
    ${looptools_path}/C/ffdxc0.F
    ${looptools_path}/C/ffxc0.F
    ${looptools_path}/C/ffxc0i.F
    ${looptools_path}/C/ffxc0p.F
    ${looptools_path}/C/ffxc0p0.F
    ${looptools_path}/D/D0func.F
    ${looptools_path}/D/D0funcC.F
    ${looptools_path}/D/D0z.F
    ${looptools_path}/D/Dget.F
    ${looptools_path}/D/ffRn.F
    ${looptools_path}/D/ffS2.F
    ${looptools_path}/D/ffS3n.F
    ${looptools_path}/D/ffT13.F
    ${looptools_path}/D/ffTn.F
    ${looptools_path}/D/ffd0c.F
    ${looptools_path}/D/ffdcc0.F
    ${looptools_path}/D/ffdel4.F
    ${looptools_path}/D/ffxd0.F
    ${looptools_path}/D/ffxd0h.F
    ${looptools_path}/D/ffxd0i.F
    ${looptools_path}/D/ffxd0m0.F
    ${looptools_path}/D/ffxd0p.F
    ${looptools_path}/D/ffxd0tra.F
    ${looptools_path}/D/ffxdbd.F
    ${looptools_path}/E/E0func.F
    ${looptools_path}/E/Ecoeffa.F
    ${looptools_path}/E/Ecoeffb.F
    ${looptools_path}/E/Eget.F
    ${looptools_path}/E/ffdel5.F
    ${looptools_path}/E/ffxe0.F
    ${looptools_path}/util/Dump.F
    ${looptools_path}/util/Li2.F
    ${looptools_path}/util/Li2omx.F
    ${looptools_path}/util/auxCD.F
    ${looptools_path}/util/cache.fixed.c
    ${looptools_path}/util/ff2dl2.F
    ${looptools_path}/util/ffabcd.F
    ${looptools_path}/util/ffbndc.F
    ${looptools_path}/util/ffcli2.F
    ${looptools_path}/util/ffcrr.F
    ${looptools_path}/util/ffcxr.F
    ${looptools_path}/util/ffcxs3.F
    ${looptools_path}/util/ffcxs4.F
    ${looptools_path}/util/ffcxyz.F
    ${looptools_path}/util/ffdcxs.F
    ${looptools_path}/util/ffinit.F
    ${looptools_path}/util/fftran.F
    ${looptools_path}/util/ffxli2.F
    ${looptools_path}/util/ffxxyz.F
    ${looptools_path}/util/ini.F
    ${looptools_path}/util/solve.F
)

target_compile_options(LoopTools PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:-ffixed-line-length-none -fno-range-check -DQUAD=0 -DU77EXT=0>)
target_compile_options(LoopTools PRIVATE $<$<COMPILE_LANGUAGE:C>:-DQUAD=0>)

# -------------------------- executable --------------------------


add_executable( ewshdecay
	src/ChangeScheme.F src/CxSMFunctions.F
	src/decayCxSM.F src/dmb.f src/elw.f src/feynhiggs.f
	src/h2hh.f src/haber.f src/hdecay.f src/hsqsq.f src/susylha.f src/hgaga.f src/hgg.f )

file(COPY ${CMAKE_SOURCE_DIR}/hdecay.in DESTINATION ${CMAKE_BINARY_DIR})

#target_include_directories(ewshdecay PUBLIC ${looptools_path}/include)
target_compile_options(ewshdecay PRIVATE -ffixed-line-length-none)

if(${CMAKE_Fortran_COMPILER_VERSION} GREATER_EQUAL 8)
	target_compile_options(ewshdecay PRIVATE -ffixed-line-length-none -std=legacy)
endif()

target_link_libraries(ewshdecay LoopTools)

include(CTest)

# test script requires python>3.5
find_package(PythonInterp 3.5)
if(PYTHONINTERP_FOUND)
    add_test(NAME real_broken_phase COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tests/testCxSM.py ${CMAKE_BINARY_DIR}/ewshdecay 1 )
    add_test(NAME real_DM_phase COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tests/testCxSM.py ${CMAKE_BINARY_DIR}/ewshdecay 2 )
    add_test(NAME complex_broken_phase COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tests/testCxSM.py ${CMAKE_BINARY_DIR}/ewshdecay 3 )
    add_test(NAME complex_DM_phase COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tests/testCxSM.py ${CMAKE_BINARY_DIR}/ewshdecay 4 )
	add_test(NAME complex_DM_phase_NLO COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tests/testCxSM.py ${CMAKE_BINARY_DIR}/ewshdecay 5 )
endif()

# cpack configuration
#set(CPACK_SOURCE_PACKAGE_FILE_NAME "EWSHDECAY")
#list(APPEND CPACK_SOURCE_IGNORE_FILES "\.git" )
#list(APPEND CPACK_SOURCE_IGNORE_FILES ".gitignore" )
#list(APPEND CPACK_SOURCE_IGNORE_FILES ".gitlab-ci.yml" )
#list(APPEND CPACK_SOURCE_IGNORE_FILES "/build/")
#list(APPEND CPACK_SOURCE_IGNORE_FILES "/__pycache__/")
#list(APPEND CPACK_SOURCE_IGNORE_FILES "/*.o/")
#list(APPEND CPACK_SOURCE_IGNODE_FILES "/n2hdecay/")
#include(CPack)

# -------------------------- export as cmake package --------------------------
#if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  #include(CMakePackageConfigHelpers)
  #write_basic_package_version_file(
    #EWSHDECAYConfigVersion.cmake
    #VERSION ${PACKAGE_VERSION}
    #COMPATIBILITY AnyNewerVersion)

  #set(EWSHDECAY LoopTools)

  #export(
    #TARGETS ${ExportList}
    #NAMESPACE EWSHDECAY::
    #FILE EWSHDECAYTargets.cmake
    #)

  #configure_file(tools/cmake/EWSHDECAYConfig.cmake.in EWSHDECAYConfig.cmake @ONLY)

  #export(PACKAGE EWSHDECAY)
#endif()

# ------------------------ Doxygen --------------------------------------------

find_package(Doxygen)
if(DOXYGEN_FOUND AND CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)

  set(DOXYGEN_USE_MATHJAX YES)
  set(DOXYGEN_STRIP_FROM_INC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/include")
  set(DOXYGEN_PROJECT_BRIEF "EWSHDECAY -- code to calculate Higgs Decays in the RxSM and CxSM including ELW corrections")
  set(DOXYGEN_CALL_GRAPH YES)
  set(DOXYGEN_EXTRACT_ALL YES)
  set(DOXYGEN_EXTRACT_PRIVATE YES)
  set(DOXYGEN_EXTRACT_PRIV_VIRTUAL YES)
  set(DOXYGEN_EXTRACT_PACKAGE YES)
  set(DOXYGEN_EXTRACT_LOCAL_CLASSES YES)
  set(DOXYGEN_EXTRACT_LOCAL_METHODS YES)
  set(DOXYGEN_SHOW_INCLUDE_FILES YES)
  set(DOXYGEN_SHOW_FILES YES)
  set(DOXYGEN_SHOW_NAMESPACES YES)
  set(DOXYGEN_GENERATE_TREEVIEW YES)
  set(DOXYGEN_DISTRIBUTE_GROUP_DOC YES)
  set(DOXYGEN_WARN_IF_UNDOCUMENTED YES)
  set(DOXYGEN_WARN_IF_DOC_ERROR YES)
  set(DOXYGEN_GENERATE_HTML YES)
  set(DOXYGEN_USE_MDFILE_AS_MAINPAGE README.md)

  doxygen_add_docs(doc
                     "${CMAKE_CURRENT_SOURCE_DIR}/include/"
                     "${CMAKE_CURRENT_SOURCE_DIR}/src/"
                     "${CMAKE_CURRENT_SOURCE_DIR}/README.md")

else ()
  message("Doxygen needs to be installed to generate the documentation.")
endif()

