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
read_and_extract_grvi <- function(grvi_path, points) {
  grvi_raster <- raster(grvi_path)
  points_sp <- as(points, "Spatial")
  
  grvi_values <- extract(grvi_raster, points_sp)
  
  return(grvi_values)
}

# Path ke file raster dan shapefile untuk masing-masing jenis
paths <- list(
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_NDVI_Tea.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_Centroid_Tea.shp",
    type = "Tea A"
  ),
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_NDVI_Tea.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_Centroid_Tea.shp",
    type = "Tea B"
  ),
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_NDVI_PalmOil.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_Centroid_PalmOil.shp",
    type = "Palm Oil A"
  ),
  list(
    grvi_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_NDVI_PalmOil.tif",
    points_path = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_Centroid_PalmOil.shp",
    type = "Palm Oil B"
  )
)

# Baca dan gabungkan data GRVI untuk masing-masing jenis
grvi_data <- lapply(paths, function(x) {
  points <- st_read(x$points_path)
  grvi_values <- read_and_extract_grvi(x$grvi_path, points)
  data.frame(Jenis = x$type, GRVI = grvi_values)
})

# Gabungkan data frame menjadi satu
grvi_data_df <- do.call(rbind, grvi_data)

# Buat boxplot dengan gaya yang diinginkan
p <- ggplot(grvi_data_df, aes(x = Jenis, y = GRVI)) +
  geom_boxplot(
    width = 0.6,       # Mengatur lebar boxplot menjadi lebih kecil
    fill = "grey",     # Warna boxplot polos
    color = "black",   # Warna garis border
    outlier.shape = 16, # Bentuk outlier
    outlier.size = 2,   # Ukuran outlier
    outlier.color = "black" # Warna outliers
  ) +
  ylim(0.2, 0.65) +   # Mengatur batas sumbu y
  labs(
    x = "Type of Plantation",
    y = "NDVI"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title = element_text(size = 17, face = "bold"),
    axis.text = element_text(size = 12),  # Ukuran teks sumbu x diperkecil
    axis.line = element_line(color = "black", size = 1),
    panel.grid.major = element_line(color = "gray", size = 0.5, linetype = "dashed"), # Garis grid mayor
    panel.grid.minor = element_blank() # Tidak ada garis grid minor
  )

# Tampilkan plot
print(p)
