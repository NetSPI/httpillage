package controllers

import javax.inject._

import services.NodeCheckinService
import entity.NodeCheckin
import org.joda.time.DateTime
import play.api._
import play.api.libs.functional.syntax._
import play.api.libs.json.{JsPath, Json, Writes}
import play.api.mvc._

import scala.concurrent.Await
import scala.concurrent.duration._

@Singleton
class NodeCheckinsController @Inject()(checkinService: NodeCheckinService) extends Controller {

  def checkin(nodeId: Long, jobId: Long, statusCode: Long) = Action {
    Ok
  }

  def getCheckins = Action {
    Ok(Json.toJson(Await.result(checkinService.getCheckins, 5000 milliseconds)))
  }

  def getCheckinById(nodeCheckinId: Long) = Action {
    Ok(Json.toJson(Await.result(checkinService.getCheckinById(nodeCheckinId), 5000 milliseconds)))
  }

  def getCheckinsByNode(nodeId: Long) = Action {
    Ok(Json.toJson(Await.result(checkinService.getCheckinByNodeId(nodeId), 5000 milliseconds)))
  }

  def getCheckinsByJob(jobId: Long) = Action {
    Ok(Json.toJson(Await.result(checkinService.getCheckinByJobId(jobId), 5000 milliseconds)))
  }

  implicit val getAllCheckinWrites: Writes[NodeCheckin] = (
    (JsPath \ "id").write[Long] and
      (JsPath \ "nodeId").write[Long] and
      (JsPath \ "jobId").write[Long] and
      (JsPath \ "responseCode").write[Int] and
      (JsPath \ "createdAt").write[DateTime]
    ) (unlift(NodeCheckin.unapply))
}
