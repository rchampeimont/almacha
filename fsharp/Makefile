FSC=fsc
CSC=gmcs
MAKEEXECUTABLE=chmod +x

all: notailrec.exe tailrec.exe uselist.exe a.exe b.exe

a.exe: a.fs
	${FSC} a.fs
	${MAKEEXECUTABLE} a.exe

b.exe: b.fs
	${FSC} b.fs
	${MAKEEXECUTABLE} b.exe

uselist.exe: uselist.fs
	${FSC} uselist.fs
	${MAKEEXECUTABLE} uselist.exe

tailrec.exe: tailrec.fs
	${FSC} tailrec.fs
	${MAKEEXECUTABLE} tailrec.exe

notailrec.exe: notailrec.cs
	${CSC} notailrec.cs

clean:
	rm *.exe
