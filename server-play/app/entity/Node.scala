package entity

import org.joda.time.DateTime

/**
  * Created by jpoulin on 3/25/17.
  */
case class Node(id: Long,
               ipAddress: String,
               macAddress: String,
               name: String,
               lastSeen: DateTime,
               createdAt: DateTime,
               updatedAt: DateTime
               )