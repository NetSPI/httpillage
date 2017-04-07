package services

import javax.inject.Inject

import dao.JobDAO
import entity.Job

import scala.concurrent.Future

/**
  * Created by jpoulin on 3/28/17.
  */
class JobService @Inject()(jobDAO: JobDAO) {
  def getJobs = {
    jobDAO.all()
  }

  def getJobById(jobId: Long): Future[Option[Job]] = {
    jobDAO.getJobById(jobId)
  }

  def createJob(job: Job) = {
    jobDAO.insert(job)
  }

  def deleteJob(jobId: Long) = {
    jobDAO.delete(jobId)
  }
}
