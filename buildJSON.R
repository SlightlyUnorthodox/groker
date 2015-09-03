require('rjson')
require('RSQLite')

db <- dbConnect(SQLite(), dbname = '~/grokit/src/Tool_DataPath/executable/' +
  'datapath.sqlite')
df <- dbGetQuery(db, 'SELECT CA.jType, CA.attribute, CR.relation ' +
  'FROM CatalogAttributes CA ' +
  'INNER JOIN CatalogRelations CR ON CA.relID=CR.relID')
output <- toJSON(df)
fileConn <- file('~/schema.json')
writeLines(output, fileConn)
close(fileConn)