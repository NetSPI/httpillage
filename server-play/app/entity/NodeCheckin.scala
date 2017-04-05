package entity

import org.joda.time.DateTime

/**
  * Nodes will periodically checkin, by providing the latest response code for a job
  */
case class NodeCheckin(id: Long,
                      nodeId: Long,
                      jobId: Long,
                      responseCode: Int,
                      createdAt: DateTime,
                      updatedAt: DateTime
                      )
