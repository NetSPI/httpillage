package services

import javax.inject.Inject

import dao.JobDAO

/**
  * Created by jpoulin on 3/28/17.
  */
class JobService @Inject()(jobDAO: JobDAO) {
  def getJobs = {
    jobDAO.all()
  }
}
