# ==================================================
# Makefile profesional para proyectos MyST + UNTREF
# Uso:
#   make init
#   make dev
#   make build
#   make clean
#   make reset
# ==================================================

SHELL := /bin/bash

MYST_FILE := myst.yml
NODE_VERSION := 24

.PHONY: help init dev build clean reset install

help:
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  make init    -> Configura myst.yml interactivo"
	@echo "  make install -> Instala dependencias Node"
	@echo "  make dev     -> Inicia servidor local"
	@echo "  make build   -> Genera sitio estático"
	@echo "  make clean   -> Limpia archivos generados"
	@echo "  make reset   -> Limpia node_modules + build"
	@echo ""

# ------------------------------------------
# Inicialización interactiva del proyecto
# ------------------------------------------
init:
	@echo ""
	@echo "Se piden ciertos datos para configurar un poco más el archivo myst.yml"
	@echo ""
	@read -p "Nombre de la materia: " materia; \
	read -p "Nombre del autor: " autor; \
	read -p "Usuario de GitHub: " github_user; \
	read -p "Repositorio GitHub (ej: untref-computacion-alumnos/apuntes-analisis-matematico-i): " repo_url; \
	echo ""; \
	keyword=$$(printf "%s" "$$materia" | tr '[:upper:]' '[:lower:]'); \
	sed -i "s|title: Apuntes de X Materia|title: Apuntes de $$materia|g" myst.yml; \
	sed -i "s|description: Apuntes de X Materia de la carrera Ingeniería en Computación (UNTREF)|description: Apuntes de $$materia de la carrera Ingeniería en Computación (UNTREF)|g" myst.yml; \
	sed -i "s|    - x materia|    - $$keyword|g" myst.yml; \
	sed -i "s|    - name: Autor|    - name: $$autor|g" myst.yml; \
	sed -i "s|      # github: user|      github: $$github_user|g" myst.yml; \
	sed -i "s|  # github: untref-computacion-alumnos/repositorio-apunte|  github: $$repo_url|g" myst.yml; \
	sed -i "/^site:/,/^  options:/ s|title: Apuntes de X Materia|title: Apuntes de $$materia|" myst.yml; \
	sed -i "s|    logo_text: Apuntes|    logo_text: $$materia|g" myst.yml; \
	sed -i "s|# Quickstart Apuntes de X Materia|# Apuntes de $$materia|g" README.md; \
	echo "Configuración completada."; \
	echo "Repositorio configurado: $$repo_url"

# ------------------------------------------
# Instalar dependencias
# ------------------------------------------
install:
	@echo "Usando Node $(NODE_VERSION)..."
	@nvm install $(NODE_VERSION) || true
	@nvm use $(NODE_VERSION) || true
	@npm install

# ------------------------------------------
# Desarrollo local
# ------------------------------------------
dev:
	@npm run start

# ------------------------------------------
# Build producción
# ------------------------------------------
build:
	@npm run build

# ------------------------------------------
# Limpiar build
# ------------------------------------------
clean:
	@rm -rf _build
	@rm -rf dist
	@echo "Archivos generados eliminados."

# ------------------------------------------
# Reset total
# ------------------------------------------
reset: clean
	@rm -rf node_modules
	@rm -f package-lock.json
	@echo "Proyecto reseteado."
