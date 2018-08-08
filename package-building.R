pkgs <- c("broom.consumeArbitrary", "broom.consumeSpecific",
          "broom.UseDepends", 
          "broom.UseImports", "broom.extend")

for (i in pkgs){
  devtools::document(i)
  devtools::install_local(i)
}