cmake_minimum_required(VERSION 3.16)

project(LearningEnglishApk VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(ANDROID)
    set(ANDROID_ABIS "arm64-v8a")
    set(CMAKE_ANDROID_ARCH_ABI "arm64-v8a")
    set(CMAKE_ANDROID_STL_TYPE "c++_shared")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick Core Gui Qml Multimedia TextToSpeech)
find_package(Qt6 REQUIRED COMPONENTS Xml)

qt_add_resources(RESOURCES resources.qrc)


qt_add_executable(LearningEnglishApk
    main.cpp
    src/MainWindow.cpp
    include/MainWindow.h
    include/PracticeWindow.h
    src/PracticeWindow.cpp
    ${RESOURCES}
)

# qt_add_qml_module(LearningEnglishApk
#     URI LearningEnglishApk
#     VERSION 1.0
#     QML_FILES
#         qml/Main.qml
#         qml/DifficultyWindow.qml
# )

qt_add_qml_module(LearningEnglishApk
    URI LearningEnglishApk
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/DifficultyWindow.qml
        qml/PracticeWindow.qml
    RESOURCES
         android/assets/resources/dictionary_level5.xml
         android/assets/resources/dictionary_level1.xml
         android/assets/resources/dictionary_level2.xml
         android/assets/resources/dictionary_level3.xml
         android/assets/resources/dictionary_level4.xml

)


target_include_directories(LearningEnglishApk PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(LearningEnglishApk
    PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Multimedia
    Qt6::TextToSpeech
    Qt6::Xml
)

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

include(GNUInstallDirs)
install(TARGETS LearningEnglishApk
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
