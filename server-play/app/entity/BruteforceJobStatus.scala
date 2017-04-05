package entity

import org.joda.time.DateTime

/**
  * Keep track of the progress of a bruteforce job
  */
case class BruteforceJobStatus (id: Long,
                               nodeId: Long,
                               jobId: Long,
                               index: Long,
                               createdAt: DateTime
                               )