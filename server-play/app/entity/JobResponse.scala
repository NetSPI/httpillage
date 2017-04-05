package entity

import org.joda.time.DateTime

/**
  * The entire HTTP response of a particular request. This will be used to store requests
  * that have matches, and also in the mode that allows the node's to store all requests.
  */
case class JobResponse(id: Long,
                      jobId: Long,
                      nodeId: Long,
                      responseCode: Int,
                      response: String,
                      createdAt: DateTime
                      )
