package services

import entity.JobResponse
import javax.inject.Inject

import scala.concurrent.{Await, Future}
import dao.JobResponseDAO

/**
  * Created by jpoulin on 3/28/17.
  */
class JobResponseService @Inject()(jobResponseDAO: JobResponseDAO) {
  def getJobResponses = {
    jobResponseDAO.all()
  }

  def getJobResponsesById(id: Long): Future[Option[JobResponse]] = {
    jobResponseDAO.getJobResponseById(id)
  }

  def getJobResponsesByJobId(jobId: Long): Future[Seq[JobResponse]] = {
    jobResponseDAO.getJobResponsesByJobId(jobId)
  }
}

