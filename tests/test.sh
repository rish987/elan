set -e

ERROR_PREFIX="ERROR: failed to infer correct lean version"

check_lean_version () {
  version=$(lean --version)
  if [[ ! $version =~ "version $1" ]]; then 
    echo $ERROR_PREFIX $2
    echo "got lean --version output:" $version
    echo "but expected version:" $1
    exit 1
  fi
}

cd ./tests/fixtures/example-lean3-project
leanpkg configure
leanpkg build
check_lean_version "3.31.0" "at Lean 3 project"

cd ../../../tests/fixtures/example-lean4-project
leanpkg build
lean --version
check_lean_version "4.0.0" "at Lean 4 project"

cd ../../../
elan default leanprover/lean4:nightly-2021-07-11
check_lean_version "4.0.0" "outside of Lean project with default toolchain Lean 4"

elan default leanprover-community/lean:3.30.0
check_lean_version "3.30.0" "outside of Lean project with default toolchain Lean 3"

cd $HOME/.elan/toolchains/leanprover--lean4---nightly-2021-07-11/
check_lean_version "4.0.0" "inside Lean 4 toolchain directory"

cd $HOME/.elan/toolchains/leanprover--lean4---nightly-2021-07-11/lib/lean/Init/Data
check_lean_version "4.0.0" "inside nested Lean 4 toolchain directory"

cd $HOME/.elan/toolchains/leanprover-community--lean---3.31.0/
check_lean_version "3.31.0" "inside Lean 3 toolchain directory"
