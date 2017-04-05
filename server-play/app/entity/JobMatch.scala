package entity

import org.joda.time.DateTime

/**
  * Handles tracking all matches for a particular JobSearch
  */
case class JobMatch(id: Long,
                   jobId: Long,
                   nodeId: Long,
                   httpRequest: String,
                   httpResponse: String,
                   matchedString: String,
                   payload: String, // Can't remember how this was utilized
                   createdAt: DateTime,
                   updatedAt: DateTime
                   )
