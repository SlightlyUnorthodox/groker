require('rjson')
require('RSQLite')

db <- dbConnect(SQLite(), dbname = paste('~/grokit/src/Tool_DataPath/',
  'executable/datapath.sqlite', sep = ""))
df <- dbGetQuery(db, paste('SELECT CA.jType, CA.attribute, CR.relation',
  'FROM CatalogAttributes CA',
  'INNER JOIN CatalogRelations CR ON CA.relID=CR.relID', sep = " ")
output <- toJSON(df)
fileConn <- file('~/schema.json')
writeLines(output, fileConn)
close(fileConn)