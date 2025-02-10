# cmake_minimum_required(VERSION 3.16)

# project(LearningEnglishApk VERSION 0.1 LANGUAGES CXX)

# set(CMAKE_CXX_STANDARD_REQUIRED ON)

# find_package(Qt6 REQUIRED COMPONENTS Quick)

# qt_standard_project_setup(REQUIRES 6.5)

# qt_add_executable(LearningEnglishApk
#     main.cpp
# )

# qt_add_qml_module(LearningEnglishApk
#     URI LearningEnglishApk
#     VERSION 1.0
#     QML_FILES
#         Main.qml
#         SOURCES include/MainWindow.h
#         SOURCES src/MainWindow.cpp
# )

# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# # If you are developing for iOS or macOS you should consider setting an
# # explicit, fixed bundle identifier manually though.
# set_target_properties(LearningEnglishApk PROPERTIES
# #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.LearningEnglishApk
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )

# target_link_libraries(LearningEnglishApk
#     PRIVATE Qt6::Quick
# )

# include(GNUInstallDirs)
# install(TARGETS LearningEnglishApk
#     BUNDLE DESTINATION .
#     LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#     RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
# )

cmake_minimum_required(VERSION 3.16)

project(LearningEnglishApk VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Android architecture settings
if(ANDROID)
    set(ANDROID_ABIS "arm64-v8a")
    set(CMAKE_ANDROID_ARCH_ABI "arm64-v8a")
    set(CMAKE_ANDROID_STL_TYPE "c++_shared")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick Core Gui Qml)

# Add resources
qt_add_resources(RESOURCES resources.qrc)

# Set up the main executable
qt_add_executable(LearningEnglishApk
    main.cpp
    src/MainWindow.cpp
    include/MainWindow.h
    ${RESOURCES}
)

# Add QML module
qt_add_qml_module(LearningEnglishApk
    URI LearningEnglishApk
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/DifficultyWindow.qml
)

# Include directories
target_include_directories(LearningEnglishApk PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Link required Qt libraries
target_link_libraries(LearningEnglishApk
    PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
)

# Android specific settings
if(ANDROID)
    set_target_properties(LearningEnglishApk PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    )

    # Copy assets to android build
    add_custom_command(TARGET LearningEnglishApk POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_SOURCE_DIR}/android/assets
        ${CMAKE_BINARY_DIR}/android-build/assets
    )
endif()

# Installation
include(GNUInstallDirs)
install(TARGETS LearningEnglishApk
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
