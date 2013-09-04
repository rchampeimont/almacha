# public domain file

CSC=gmcs

all: AchaAutomate.dll AchaFirstProgram.exe

AchaAutomate.dll: AchaAutomate.cs
	$(CSC) AchaAutomate.cs -t:library

AchaFirstProgram.exe: *.cs
	$(CSC) *.cs -out:AchaFirstProgram.exe

clean:
	rm -rf *.dll *.exe

