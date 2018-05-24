# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo;
2. Implementar un algoritmo de anti-aliasing para sus aristas; y,
3. Hacer shading sobre su superficie.

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases).

## Integrantes

Máximo 3.

Complete la tabla:

| Integrante           | github nick |
|----------------------|-------------|
| Sergio Andres Cabezas|seacabezasma |
| Luis Zamora		   |zam403		 |

## Discusión

Describa los resultados obtenidos. Qué técnicas de anti-aliasing y shading se exploraron? Adjunte las referencias. Discuta las dificultades encontradas.

El proceso de rasterización parece bastante fiel, en medida de que se asigna un color particular a cada vertice y dependiendo de los pesos por pixel, cada punto 
una combinación adecuada de los colores de los vértices. Para el caso del anti-aliasing, dado que se conocen plenamente los pixeles que corresponden a la frontera
del triangulo a rasterizar, solo es cuestión de asignar un margen de pixeles próximos a los bordes del triangulo, de manera que para generar el efecto de difuminado 
del color sobre los bordes y así reducir el efecto bordes de sierra, se mezclan progresivamente el color del pixel con el color de fondo. En este caso, la 
implementación asume que el fondo siempre es negro, por lo que se toma este como color de referencia siempre, si bien el algoritmo sobre el cual se centra la implementación (CMAA de Intel)
sugiere recorrer los pixeles que representen cambios bruscos de color y asumir que estos son los pixeles de frontera, para así determinar que píxeles se toman como bordes y de paso,
qué píxeles corresponden al fondo. 

El reto mayor consistió en lograr un margen aceptable de tolerancia para la escogencia de los pixeles de los bordes del triangulo, sobre los cuales implementar el anti-alias.

Referencias:

[Conservative Morphological Anti-Aliasing](https://software.intel.com/en-us/articles/conservative-morphological-anti-aliasing-cmaa-update)
[The Barycentric Conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)

## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes (de las que se tomará una al azar).
* Plazo: 1/4/18 a las 24h.
