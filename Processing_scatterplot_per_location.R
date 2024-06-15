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

# Baca data raster
#grvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_GRVI_PalmOil_10m_median.tif")
#ndvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_NDVI_PalmOil.tif")
#grvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_GRVI_PalmOil_10m_median.tif")
#ndvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_NDVI_PalmOil.tif")
#grvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_GRVI_Tea_10m_median.tif")
#ndvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_NDVI_Tea.tif")
grvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_GRVI_Tea_10m_median.tif")
ndvi_raster <- raster("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_NDVI_Tea.tif")

# Baca data vektor
#points <- st_read("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_Centroid_PalmOil.shp")
#points <- st_read("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_Centroid_PalmOil.shp")
#points <- st_read("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_Centroid_Tea.shp")
points <- st_read("C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_Centroid_Tea.shp")

# Konversi data vektor ke SpatialPointsDataFrame
points_sp <- as(points, "Spatial")

# Ekstrak nilai raster pada titik-titik vektor
grvi_values <- extract(grvi_raster, points_sp)
ndvi_values <- extract(ndvi_raster, points_sp)

# Buat dataframe dari nilai-nilai yang diekstraksi
data <- data.frame(
  GRVI = grvi_values,
  NDVI = ndvi_values
)

# Hilangkan nilai nol dari dataframe
data <- data[data$GRVI != 0 & data$NDVI != 0, ]

# Buat grafik menggunakan ggplot2
ggplot(data, aes(x = GRVI, y = NDVI)) +
  geom_point(color = "black", alpha = 0.6) +  # Titik hitam dengan transparansi
  labs(#title = "Scatter Plot of GRVI vs NDVI",
       x = "GRVI",
       y = "NDVI") +
  theme_minimal() +
  theme(
    #plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Judul tengah dengan ukuran lebih besar dan tebal
    axis.title = element_text(size = 17, face = "bold"),  # Ukuran judul sumbu lebih besar dan tebal
    axis.text = element_text(size = 16),  # Ukuran teks sumbu lebih besar
    axis.line = element_line(color = "black", size = 1)  # Garis sumbu lebih tebal
  )