file(REMOVE_RECURSE
  "libtfhe-spqlios-fma.a"
  "libtfhe-spqlios-fma.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang ASM CXX)
  include(CMakeFiles/tfhe-spqlios-fma.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
