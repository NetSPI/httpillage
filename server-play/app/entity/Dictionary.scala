package entity

/**
  * Created by jpoulin on 3/25/17.
  */
case class Dictionary(id:Long,
                     filename: String,
                     originalFilename: String,
                     description: String,
                     fileSize: Long,
                     preview: String
                     )
