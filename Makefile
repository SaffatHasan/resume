LATEX_IMAGE=blang/latex:ubuntu
PYTHON_IMAGE=python-builder
WORKDIR=/data

run: dist/resume-simple.pdf dist/resume.pdf

watch:
	while true; do make --silent; sleep 1; done

resume: dist/resume.pdf
resume-simple: dist/resume-simple.pdf
two-column: dist/two-column.pdf

dist/resume-simple.pdf: dist/resume-simple.tex dist
	docker run --rm -v "${PWD}/dist:${WORKDIR}" "${LATEX_IMAGE}" lualatex resume-simple.tex | tail -n2

dist/resume.pdf: dist/resume.tex dist/mcdowellcv.cls
	docker run --rm -v "${PWD}/dist:${WORKDIR}" "${LATEX_IMAGE}" lualatex resume.tex | tail -n2

dist/two-column.pdf: dist/two-column.tex dist/two-column.cls
	docker run --rm -v "${PWD}/dist:${WORKDIR}" "${LATEX_IMAGE}" lualatex two-column.tex | tail -n2

dist/resume-simple.tex: python-builder templates/resume-simple.tex resources/data.yml
	docker run --rm -v "${PWD}:${WORKDIR}" "${PYTHON_IMAGE}" resume-simple

dist/resume.tex: python-builder templates/resume.tex resources/data.yml
	docker run --rm -v "${PWD}:${WORKDIR}" "${PYTHON_IMAGE}" resume

dist/two-column.tex: python-builder templates/two-column.tex resources/data.yml
	docker run --rm -v "${PWD}:${WORKDIR}" "${PYTHON_IMAGE}" two-column

dist/mcdowellcv.cls: resources/mcdowellcv.cls
	mkdir -p dist
	cp resources/mcdowellcv.cls dist/mcdowellcv.cls

dist/two-column.cls: resources/two-column.cls
	mkdir -p dist
	cp resources/two-column.cls dist/two-column.cls
	cp -r resources/fonts/ dist/

python-builder: src/requirements.txt src/main.py
	docker build . -t ${PYTHON_IMAGE}

clean:
	@rm -rf dist/


