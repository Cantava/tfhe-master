# Install script for directory: D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/tfhe")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "D:/Program_Files/JetBrains/CLion 2023.3.4/bin/mingw/bin/objdump.exe")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/tfhe" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/lagrangehalfc_arithmetic.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/lwe-functions.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/lwebootstrappingkey.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/lwekey.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/lwekeyswitch.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/lweparams.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/lwesamples.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/numeric_functions.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/polynomials.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/polynomials_arithmetic.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe_core.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe_garbage_collector.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe_gate_bootstrapping_functions.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe_gate_bootstrapping_structures.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe_generic_streams.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe_generic_templates.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tfhe_io.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tgsw.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tgsw_functions.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tlwe.h"
    "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/include/tlwe_functions.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/cmake-build-debug/libtfhe/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "D:/Documents/njit/1大三下实验报告/密码学实验/程序代码（带章节编号）/8.1/tfhe-master/src/cmake-build-debug/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
