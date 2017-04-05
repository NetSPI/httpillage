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
              httpData: Option[String],
              attackType: String,
              attackMode: String,
              status: Option[String],
              owner: Long,
              dictionaryId: Option[Long],          // This should be in a different model
              bruteforceCharset: Option[String],  // This should be in a different model
              nextIndex: Option[Long],             // This should be in a different model
              createdAt: DateTime,
              updatedAt: DateTime
            )
