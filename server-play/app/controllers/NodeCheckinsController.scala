package controllers

import javax.inject._

import services.NodeCheckinService
import entity.NodeCheckin
import org.joda.time.DateTime
import play.api.libs.functional.syntax._
import play.api.libs.json._
import play.api.libs.json.Reads._
import play.api.mvc._

import scala.concurrent.{Await, Future}
import scala.concurrent.duration._

@Singleton
class NodeCheckinsController @Inject()(checkinService: NodeCheckinService) extends Controller {

  def checkin() = Action.async(parse.json) {
    request =>
      import scala.concurrent.ExecutionContext.Implicits.global

      val json = request.body.validate[CreateCheckinRequest]
      json.fold(
        invalid => {
          Future(BadRequest(Json.obj("status" -> "KO", "message" -> JsError.toJson(invalid))))
        },
        valid => {

          val checkin = NodeCheckin(
            -999,
            json.get.nodeId,
            json.get.jobId,
            json.get.responseCode,
            DateTime.now
          )

          val checkinCreated = checkinService.performCheckin(checkin)

          Future(Ok(Json.toJson(Await.result(checkinCreated, 5000 milliseconds))))
        }
      )
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


  implicit val createCheckin: Reads[CreateCheckinRequest] = (
    (JsPath \ "nodeId").read[Long] and
      (JsPath \ "jobId").read[Long] and
      (JsPath \ "responseCode").read[Int]
  ) (CreateCheckinRequest.apply _)
}

case class CreateCheckinRequest(
                               nodeId: Long,
                               jobId: Long,
                               responseCode: Int
                               )
