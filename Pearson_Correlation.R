# Instal dan muat paket yang diperlukan jika belum terinstal
if (!requireNamespace("terra", quietly = TRUE)) {
  install.packages("terra")
}
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}

# Muat paket
library(terra)
library(sf)

# Fungsi untuk membaca raster dan centroid, serta mengekstrak nilai berdasarkan centroid
extract_values <- function(grvi_path, ndvi_path, centroid_path) {
  grvi_raster <- rast(grvi_path)
  ndvi_raster <- rast(ndvi_path)
  centroids <- st_read(centroid_path)
  
  # Ekstrak nilai raster berdasarkan centroid
  grvi_values <- extract(grvi_raster, vect(centroids))[, 2] # kolom ke-2 adalah nilai raster
  ndvi_values <- extract(ndvi_raster, vect(centroids))[, 2] # kolom ke-2 adalah nilai raster
  
  # Gabungkan nilai GRVI dan NDVI ke dalam satu data frame
  data <- data.frame(GRVI = grvi_values, NDVI = ndvi_values)
  return(data)
}

# Path untuk masing-masing lokasi
paths <- list(
  Tea_A = list(
    grvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_GRVI_Tea_10m_median.tif",
    ndvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_NDVI_Tea.tif",
    centroid = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P1_Centroid_Tea.shp"
  ),
  Tea_B = list(
    grvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_GRVI_Tea_10m_median.tif",
    ndvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_NDVI_Tea.tif",
    centroid = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D4P2_Centroid_Tea.shp"
  ),
  Palm_Oil_A = list(
    grvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_GRVI_PalmOil_10m_median.tif",
    ndvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_NDVI_PalmOil.tif",
    centroid = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D2P1_Centroid_PalmOil.shp"
  ),
  Palm_Oil_B = list(
    grvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_GRVI_PalmOil_10m_median.tif",
    ndvi = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_NDVI_PalmOil.tif",
    centroid = "C:/Users/DELL/Desktop/Tugas Pak AW Paper SIG PJ Keruangan/D3P1_Centroid_PalmOil.shp"
  )
)

# Gabungkan data dari semua lokasi
all_data <- do.call(rbind, lapply(paths, function(p) extract_values(p$grvi, p$ndvi, p$centroid)))

# Buang nilai NA
all_data <- na.omit(all_data)

# Hitung korelasi Pearson
pearson_corr <- cor(all_data$GRVI, all_data$NDVI, method = "pearson")

# Tampilkan hasil
cat("Koefisien Korelasi Pearson antara GRVI dan NDVI adalah:", pearson_corr, "\n")

cor_test_result <- cor.test(all_data$GRVI, all_data$NDVI, method = "pearson")
print(cor_test_result)

