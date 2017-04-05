package entity

import org.joda.time.DateTime

/**
  * Created by jpoulin on 3/25/17.
  */
case class Job(
              id:Long,
              description: String,
              httpMethod: String,
              httpUri: String,
              httpHost: String,
              httpHeaders: String,
              httpData: String,
              attackType: String,
              attackMode: String,
              status: String,
              userId: Long,
              dictionaryId: Long,          // This should be in a different model
              bruteforceCharset: String,  // This should be in a different model
              nextIndex: Long,             // This should be in a different model
              createdAt: DateTime,
              updatedAt: DateTime
            )
