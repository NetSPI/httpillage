package entity

import org.joda.time.DateTime

/**
  * Define the queries to search for in jobs. These will be delivered
  * to the nodes, which will perform the search.
  *
  * Matches will be sent from the node -> server and will be created as
  * JobMatch objects
  */
case class JobSearch (id: Long,
                     jobId: Long,
                     matchType: String,
                     matchValue: String,
                     createdAt: DateTime,
                     updatedAt: DateTime
                     )