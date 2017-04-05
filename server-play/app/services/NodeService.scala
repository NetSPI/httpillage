package services

import entity.Node

import javax.inject.Inject
import scala.concurrent.duration._
import scala.concurrent.{Await, Future}

import dao.NodeDAO

/**
  * Created by jpoulin on 3/28/17.
  */
class NodeService @Inject()(nodeDAO: NodeDAO) {
  def getNodes = {
    nodeDAO.all()
  }

  def getNodeById(id: Long): Future[Option[Node]] = {
    nodeDAO.getNodeById(id)
  }
}
