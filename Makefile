MODULES=gui state main author player background bomb
OBJECTS=$(MODULES:=.cmo)
MLS=$(MODULES:=.ml)
MLIS=$(MODULES:=.mli)
TEST=test.byte
MAIN=main.byte
OCAMLBUILD=ocamlbuild -use-ocamlfind

default: build
	OCAMLRUNPARAM=b utop

build:
	$(OCAMLBUILD) $(OBJECTS)

test:
	$(OCAMLBUILD) -tag 'debug' $(TEST) && ./$(TEST) -runner sequential

play:
	$(OCAMLBUILD) -tag 'debug' $(MAIN) && OCAMLRUNPARAM=b ./$(MAIN)

check:
	@bash check.sh
	
finalcheck:
	@bash check.sh final

zip:
	zip MS1.zip *.ml* *.json *.md *.png *.sh _tags .merlin .ocamlformat .ocamlinit Makefile	
	
docs: build
	mkdir -p _docs
	ocamlfind ocamldoc -I _build -package yojson,ANSITerminal \
		-html -stars -d _docs $(MLIS)

clean:
	ocamlbuild -clean

