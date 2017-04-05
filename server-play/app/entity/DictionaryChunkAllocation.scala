package entity

import org.joda.time.DateTime

/**
  * Created by jpoulin on 3/25/17.
  */
case class DictionaryChunkAllocation(id: Long,
                                    jobId: Long,
                                    nodeId: Long,
                                    startByte: Long,
                                    endByte: Long,
                                    completed: Int,
                                    createdAt: DateTime,
                                    updatedAt: DateTime
                                    )
