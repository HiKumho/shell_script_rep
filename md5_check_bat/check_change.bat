@echo off
setlocal enableDelayedExpansion

cd %~dp0

set /p file="Please enter checking file name, e.g. attachment.zip: "

set "md5_file_name=md5_!file!.txt"
for /r "%~dp0" %%a in (*) do if "%%~nxa"=="!md5_file_name!" set md5_file_path="%%~dpnxa"
if defined md5_file_path (
  echo !md5_file_path! is found.
) else (
  echo It can not check because !md5_file_path! is not found.
  echo Press Enter for exiting
  pause > nul
  exit
)

REM ��ȡУ���ļ� MD5 ֵ
set "check_file_sha="
for /f "skip=1 tokens=* delims=" %%# in ('certutil -hashfile "!file!" MD5') do (
	if not defined check_file_sha (
		for %%Z in (%%#) do set "check_file_sha=!check_file_sha!%%Z"
	)
)
echo The checking file sha: !check_file_sha!

REM ��ȡ md_!file!.txt �е� MD5 ֵ
set "valid_file_sha="
for /f "tokens=1 delims= " %%i in ('findstr "!file!" !md5_file_path!') do set "valid_file_sha=!valid_file_sha!%%i"
echo The valid file sha: !valid_file_sha!

REM У���ļ����
echo The check result:
if "!valid_file_sha!" == "" (
  echo It's Invalid. the !md5_file_name! is not found or sha of !file! is no existed!!
) else (
  if "!valid_file_sha!" == "!check_file_sha!" (
    echo It's Ok.
  ) else (
    echo It's Invalid. current file sha is not matched for valid file sha!!
  )
)

echo Press Enter for exiting
pause > nul
endlocal