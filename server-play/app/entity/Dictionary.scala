package entity

import org.joda.time.DateTime

/**
  * Created by jpoulin on 3/25/17.
  */
case class Dictionary(id:Long,
                     filename: String,
                     originalFilename: String,
                     description: String,
                     fileSize: Long,
                     createdAt: DateTime,
                     updatedAt: DateTime
                     )
