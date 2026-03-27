@echo on

set CARGO_EXTRA_ARGS=
if %target_platform% neq %build_platform% (
  if %target_platform%==win-arm64 (
    set CARGO_EXTRA_ARGS=--target aarch64-pc-windows-msvc
  ) else if %target_platform%==win-64 (
    set CARGO_EXTRA_ARGS=--target x86_64-pc-windows-msvc
  )
)
if %target_platform%==win-arm64 (
  set "CC=clang-cl.exe"
  set "CXX=clang-cl.exe"
)

set CARGO_PROFILE_RELEASE_STRIP=symbols

cd crates\uv

cargo install ^
    --no-track ^
    --locked ^
    --path . ^
    --profile release ^
    --root "%LIBRARY_PREFIX%" ^
    %CARGO_EXTRA_ARGS% ^
    || exit 1


cargo-bundle-licenses ^
    --format yaml ^
    --output "%SRC_DIR%\THIRDPARTY.yml" ^
    || exit 3
