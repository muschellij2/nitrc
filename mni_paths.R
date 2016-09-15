mni152 = c(
  "mni_152_lin" = "http://packages.bic.mni.mcgill.ca/mni-models/icbm152/mni_icbm152_lin_nifti.zip",
  "mni_152_nonlin6" = "http://packages.bic.mni.mcgill.ca/mni-models/icbm152/mni_icbm152_nl_VI_nifti.zip",
  "mni_icbm152_nlin_sym_09a" = "http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_sym_09a_nifti.zip",
  "mni_icbm152_nlin_sym_09a" = "http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_asym_09a_nifti.zip",
  "mni_icbm152_nlin_sym_09b" = "http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_sym_09b_nifti.zip",
  "mni_icbm152_nlin_asym_09b" = "http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_asym_09b_nifti.zip",
  "mni_icbm152_nlin_sym_09c" = "http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_sym_09c_nifti.zip",
  "mni_icbm152_nlin_asym_09c" = "http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_asym_09c_nifti.zip")

colin = c(
  "mni_colin27_1998" = "http://packages.bic.mni.mcgill.ca/mni-models/colin27/mni_colin27_1998_nifti.zip",
  "mni_colin27_2008" = "http://packages.bic.mni.mcgill.ca/mni-models/colin27/mni_colin27_2008_nifti.zip"
)

mni305 = c("mni305_lin" = "http://packages.bic.mni.mcgill.ca/mni-models/mni305/mni305_lin_nifti.zip")

niphd = c(
  "nihpd_sym_all" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_all_nifti.zip",
  "nihpd_sym_04.5-18.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_04.5-18.5_nifti.zip",
  "nihpd_sym_04.5-08.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_04.5-08.5_nifti.zip",
  "nihpd_sym_07.0-11.0" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_07.0-11.0_nifti.zip",
  "nihpd_sym_07.5-13.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_07.5-13.5_nifti.zip",
  "nihpd_sym_07.5-13.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_07.5-13.5_nifti.zip",
  "nihpd_sym_10.0-14.0" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_10.0-14.0_nifti.zip",
  "nihpd_sym_13.0-18.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_sym_13.0-18.5_nifti.zip",

  "nihpd_asym_all" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_all_nifti.zip",
  "nihpd_asym_04.5-18.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_04.5-18.5_nifti.zip",
  "nihpd_asym_04.5-08.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_04.5-08.5_nifti.zip",
  "nihpd_asym_07.0-11.0" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_07.0-11.0_nifti.zip",
  "nihpd_asym_07.5-13.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_07.5-13.5_nifti.zip",
  "nihpd_asym_07.5-13.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_07.5-13.5_nifti.zip",
  "nihpd_asym_10.0-14.0" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_10.0-14.0_nifti.zip",
  "nihpd_asym_13.0-18.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj1/nihpd_asym_13.0-18.5_nifti.zip",

  "nihpd_asym_0-4.5" = "http://www.bic.mni.mcgill.ca/~vfonov/nihpd/obj2/nihpd_obj2_asym_nifti.zip"
)

pd = c("mni_pd25" = "http://packages.bic.mni.mcgill.ca/mni-models/PD25/mni_PD25_20160706_nifti.zip")

mni_atlas_links = c(mni152, mni305, colin, niphd, pd)
save(mni_atlas_links, file = "data/mni_atlas_links.rda", compression_level = 9)