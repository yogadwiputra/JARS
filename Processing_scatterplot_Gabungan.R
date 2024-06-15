if (!requireNamespace("raster", quietly = TRUE)) {
  install.packages("raster")
}
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
library(raster)
library(sf)
library(ggplot2)

# Fungsi untuk membaca data raster, mengekstrak nilai, dan menggabungkan data
read_and_extract <- function(grvi_path, ndvi_path, points, type) {
  grvi_raster <- raster(grvi_path)
  ndvi_raster <- raster(ndvi_path)
  points_sp <- as(points, "Spatial")
  
  grvi_values <- extract(grvi_raster, points_sp)
  ndvi_values <- extract(ndvi_raster, points_sp)
  
  data <- data.frame(
    GRVI = grvi_values,
    NDVI = ndvi_values,
    Type = type
  )
  
  data <- data[data$GRVI != 0 & data$NDVI != 0, ]
  return(data)
}

# Path ke file raster dan shapefile
paths <- list(
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_GRVI_Tea_10m_median.tif",
    ndvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_NDVI_Tea.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_Centroid_Tea.shp",
    type = "Tea A"
  ),
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_GRVI_Tea_10m_median.tif",
    ndvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_NDVI_Tea.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_Centroid_Tea.shp",
    type = "Tea B"
  ),
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_GRVI_PalmOil_10m_median.tif",
    ndvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_NDVI_PalmOil.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_Centroid_PalmOil.shp",
    type = "Palm Oil A"
  ),
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_GRVI_PalmOil_10m_median.tif",
    ndvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_NDVI_PalmOil.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_Centroid_PalmOil.shp",
    type = "Palm Oil B"
  )
)

# Baca dan gabungkan data untuk masing-masing jenis
all_data <- do.call(rbind, lapply(paths, function(x) read_and_extract(x$grvi_path, x$ndvi_path, st_read(x$points_path), x$type)))

# Buat plot menggunakan ggplot2
ggplot(all_data, aes(x = GRVI, y = NDVI, color = Type)) +
  geom_point(size = 3, alpha = 0.6) +
  labs(title = "Scatter Plot of GRVI vs NDVI",
       x = "GRVI",
       y = "NDVI",
       color = "Type") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title = element_text(size = 17, face = "bold"),
    axis.text = element_text(size = 16),
    axis.line = element_line(color = "black", size = 1),
    legend.position = "right"
  )