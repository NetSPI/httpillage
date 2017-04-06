package services


import javax.inject.Inject

import scala.concurrent.{Await, Future}
import dao.NodeCheckinDAO
import entity.NodeCheckin
import org.joda.time.DateTime

/**
  * Created by jpoulin on 3/28/17.
  */
class NodeCheckinService @Inject()(checkinDAO: NodeCheckinDAO) {
  def getCheckins = {
    checkinDAO.all()
  }

  def getCheckinById(id: Long): Future[Option[NodeCheckin]] = {
    checkinDAO.getCheckinById(id)
  }

  def getCheckinByNodeId(nodeId: Long): Future[Seq[NodeCheckin]] = {
    checkinDAO.getCheckinByNodeId(nodeId)
  }

  def getCheckinByJobId(jobId: Long): Future[Seq[NodeCheckin]] = {
    checkinDAO.getCheckinByJobId(jobId)
  }

  def performCheckin(nodeCheckin: NodeCheckin) = {
    checkinDAO.insert(nodeCheckin)
  }
}
