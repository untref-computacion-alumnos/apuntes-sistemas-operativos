# Apuntes de Análisis Matemático I

> Esto no es un apunte oficial de la carrera o la universidad.

## Prerrequisitos

- [Visual Studio Code](https://code.visualstudio.com/)
- [nvm](https://github.com/nvm-sh/nvm)
- [Node.js](https://nodejs.org/)
- [Makefile](https://www.gnu.org/software/make/)

## Instalación

Clonar el repositorio e instalar dependencias:

```sh
# Clonar mediante SSH
git clone git@github.com:untref-computacion-alumnos/repositorio.git

# Ingresar al directorio
cd repositorio

# Instalar Node.js 24
nvm install 24

# Usar la versión instalada
nvm use 24

# Instalar dependencias
npm install

# Iniciar makefile para editar `myst.yml` y este `README.md`
make init
```

## Desarrollo local

Para iniciar el servidor local:

```sh
make dev
```

Para ver comandos de ayuda:

```sh
make help
```
