# Modified by Christian Frisson
# to search on MacPorts before system frameworks on OSX
#
# - Try to find the LibXslt library
# Once done this will define
#
#  LIBXSLT_FOUND - system has LibXslt
#  LIBXSLT_INCLUDE_DIR - the LibXslt include directory
#  LIBXSLT_LIBRARIES - Link these to LibXslt
#  LIBXSLT_DEFINITIONS - Compiler switches required for using LibXslt
#  LIBXSLT_VERSION_STRING - version of LibXslt found (since CMake 2.8.8)
# Additionally, the following two variables are set (but not required for using xslt):
#  LIBXSLT_EXSLT_LIBRARIES - Link to these if you need to link against the exslt library
#  LIBXSLT_XSLTPROC_EXECUTABLE - Contains the full path to the xsltproc executable if found

#=============================================================================
# Copyright 2006-2009 Kitware, Inc.
# Copyright 2006 Alexander Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
FIND_PACKAGE(PkgConfig)
PKG_CHECK_MODULES(PC_LIBXSLT libxslt)
SET(LIBXSLT_DEFINITIONS ${PC_LIBXSLT_CFLAGS_OTHER})

IF(APPLE)
SET(LIBXSLT_INCLUDE_DIR)
FIND_PATH(LIBXSLT_INCLUDE_DIR NAMES libxslt/xslt.h
    HINTS
   ${PC_LIBXSLT_INCLUDEDIR}
   ${PC_LIBXSLT_INCLUDE_DIRS}
  PATHS
  /opt/local # MacPorts
  NO_SYSTEM_ENVIRONMENT_PATH
  NO_DEFAULT_PATH
  )
ENDIF()
IF(NOT LIBXSLT_INCLUDE_DIR)
FIND_PATH(LIBXSLT_INCLUDE_DIR NAMES libxslt/xslt.h
    HINTS
   ${PC_LIBXSLT_INCLUDEDIR}
   ${PC_LIBXSLT_INCLUDE_DIRS}
  )
ENDIF()

IF(APPLE)
SET(LIBXSLT_LIBRARIES)
FIND_LIBRARY(LIBXSLT_LIBRARIES NAMES xslt libxslt
    HINTS
   ${PC_LIBXSLT_LIBDIR}
   ${PC_LIBXSLT_LIBRARY_DIRS}
  PATHS
  /opt/local
  NO_SYSTEM_ENVIRONMENT_PATH
  NO_DEFAULT_PATH
  )
ENDIF()
IF(NOT LIBXSLT_LIBRARIES)
FIND_LIBRARY(LIBXSLT_LIBRARIES NAMES xslt libxslt
    HINTS
   ${PC_LIBXSLT_LIBDIR}
   ${PC_LIBXSLT_LIBRARY_DIRS}
  )
ENDIF()

FIND_LIBRARY(LIBXSLT_EXSLT_LIBRARY NAMES exslt libexslt
    HINTS
    ${PC_LIBXSLT_LIBDIR}
    ${PC_LIBXSLT_LIBRARY_DIRS}
  )

SET(LIBXSLT_EXSLT_LIBRARIES ${LIBXSLT_EXSLT_LIBRARY} )

FIND_PROGRAM(LIBXSLT_XSLTPROC_EXECUTABLE xsltproc)

IF(PC_LIBXSLT_VERSION)
    SET(LIBXSLT_VERSION_STRING ${PC_LIBXSLT_VERSION})
ELSEIF(LIBXSLT_INCLUDE_DIR AND EXISTS "${LIBXSLT_INCLUDE_DIR}/libxslt/xsltconfig.h")
    FILE(STRINGS "${LIBXSLT_INCLUDE_DIR}/libxslt/xsltconfig.h" libxslt_version_str
         REGEX "^#define[\t ]+LIBXSLT_DOTTED_VERSION[\t ]+\".*\"")

    STRING(REGEX REPLACE "^#define[\t ]+LIBXSLT_DOTTED_VERSION[\t ]+\"([^\"]*)\".*" "\\1"
           LIBXSLT_VERSION_STRING "${libxslt_version_str}")
    UNSET(libxslt_version_str)
ENDIF()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibXslt
                                  LIBXSLT_LIBRARIES LIBXSLT_INCLUDE_DIR
                                  LIBXSLT_VERSION_STRING)

MARK_AS_ADVANCED(LIBXSLT_INCLUDE_DIR
                 LIBXSLT_LIBRARIES
                 LIBXSLT_EXSLT_LIBRARY
                 LIBXSLT_XSLTPROC_EXECUTABLE)
