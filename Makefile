flake8:
	flake8 dxread

pylint:
	pylint dxread

black:
	black --check-only dxread

format_files:
	black dxread

checks:
	flake8
	pylint
	black
