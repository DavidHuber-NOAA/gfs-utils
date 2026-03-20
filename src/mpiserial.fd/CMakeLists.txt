list(APPEND c_src
mpiserial.c
)

if(CMAKE_C_COMPILER_ID MATCHES "^(Intel)$")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fp-model precise")
endif()

set(exe_name mpiserial)
add_executable(${exe_name} ${c_src})

install(TARGETS ${exe_name} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
